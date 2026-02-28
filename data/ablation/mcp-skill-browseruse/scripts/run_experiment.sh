#!/usr/bin/env bash
# ============================================================
# Browser Automation Token Usage Experiment
# Playwright MCP vs playwright-cli
# Run from an EXTERNAL terminal (not inside Claude Code)
# ============================================================
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_FILE="$PROJECT_DIR/data/results.csv"
LOGS_DIR="$PROJECT_DIR/logs"
SCREENSHOTS_DIR="$PROJECT_DIR/screenshots"
MCP_CONFIG="$PROJECT_DIR/.mcp.json"
MCP_CONFIG_DISABLED="$PROJECT_DIR/.mcp.experiment.disabled.json"
MCP_CONFIG_ORIGINAL="$PROJECT_DIR/.mcp.experiment.original.json"

mkdir -p "$LOGS_DIR"
mkdir -p "$SCREENSHOTS_DIR"
cd "$PROJECT_DIR"
unset CLAUDECODE

# ── Tool isolation ────────────────────────────────────────
# MCP arm: disable skills so runs cannot fall back to playwright-cli.
# CLI arm: temporarily hide .mcp.json so MCP tools are unavailable.
MCP_ALLOWED="mcp__playwright__*"
PC_ALLOWED="Bash(playwright-cli:*)"
MCP_DISALLOWED="Skill,Bash(*),Read,TodoWrite,Task"
PC_DISALLOWED="mcp__playwright__*,TodoWrite,Task"

# ── Prompts ───────────────────────────────────────────────
TASK_A='Go to http://localhost:3333, navigate to the login page, and attempt to bypass authentication using SQL injection: enter the email '"'"' OR true--'"'"' with any password. Take a screenshot showing the result and report whether the login was bypassed.'
TASK_B='Go to http://localhost:3333, find the search field in the navigation bar, and enter the XSS payload: <iframe src="javascript:alert('\''xss'\'')">. Take a screenshot of the result and report whether the payload was reflected or executed in the page.'
TASK_C='Go to http://localhost:3333, log in with email admin@juice-sh.op and password admin123, then execute JavaScript to retrieve the value stored in localStorage under the key "token". Decode the JWT payload and report the claims you find (user ID, email, role).'

get_prompt() {
  local approach="$1" task="$2"
  local base prefix
  case "$task" in
    A) base="$TASK_A" ;;
    B) base="$TASK_B" ;;
    C) base="$TASK_C" ;;
  esac
  [[ "$approach" == "playwright-cli" ]] && prefix="Use the playwright-cli skill to:" \
                                        || prefix="Use the playwright MCP to:"
  echo "$prefix $base"
}

# ── JSON parsing (single python3 call per run) ────────────
parse_log() {
  python3 -c "
import sys, json, re
try:
  d = json.load(sys.stdin)
except Exception:
  for _ in range(11): print('')
  sys.exit(0)
s = d.get('modelUsage', {}).get('claude-sonnet-4-6', {})
h = d.get('modelUsage', {}).get('claude-haiku-4-5-20251001', {})
snippet = re.sub(r'[\r\n\t]+', ' ', d.get('result', '')).strip()[:120]
print(s.get('inputTokens', ''))
print(s.get('outputTokens', ''))
print(s.get('cacheReadInputTokens', ''))
print(s.get('cacheCreationInputTokens', ''))
print(h.get('inputTokens', 0))
print(h.get('outputTokens', 0))
print(d.get('total_cost_usd', ''))
print(d.get('duration_ms', ''))
print(d.get('num_turns', ''))
print(snippet)
print(d.get('session_id', ''))
" < "$1" 2>/dev/null
}

disable_mcp_server() {
  if [[ -f "$MCP_CONFIG" ]]; then
    mv "$MCP_CONFIG" "$MCP_CONFIG_DISABLED"
  fi
}

restore_mcp_server() {
  if [[ -f "$MCP_CONFIG_DISABLED" ]]; then
    mv "$MCP_CONFIG_DISABLED" "$MCP_CONFIG"
  fi
}

backup_original_mcp_config() {
  if [[ -f "$MCP_CONFIG" && ! -f "$MCP_CONFIG_ORIGINAL" ]]; then
    cp "$MCP_CONFIG" "$MCP_CONFIG_ORIGINAL"
  fi
}

set_mcp_headless_config() {
  cat > "$MCP_CONFIG" <<EOF
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--headless", "--output-dir", "$SCREENSHOTS_DIR"]
    }
  }
}
EOF
}

cleanup_mcp_config() {
  restore_mcp_server
  if [[ -f "$MCP_CONFIG_ORIGINAL" ]]; then
    mv "$MCP_CONFIG_ORIGINAL" "$MCP_CONFIG"
  fi
}

check_tool_purity() {
  python3 - "$1" "$2" <<'PY'
import json, sys
session_file, approach = sys.argv[1], sys.argv[2]
tools = []
with open(session_file, encoding="utf-8", errors="ignore") as fh:
  for line in fh:
    try:
      obj = json.loads(line)
    except Exception:
      continue
    msg = obj.get("message")
    if not isinstance(msg, dict):
      continue
    for part in msg.get("content") or []:
      if isinstance(part, dict) and part.get("type") == "tool_use":
        name = part.get("name")
        if name:
          tools.append(name)

toolset = set(tools)
has_mcp = any(t.startswith("mcp__playwright__") for t in toolset)

if approach == "playwright-mcp":
  bad = sorted(t for t in toolset if t in {"Skill", "Bash", "Read"})
  if bad or not has_mcp:
    msg = f"mixed_mcp_run bad={bad} has_mcp={has_mcp}"
    print(msg)
    sys.exit(42)
else:
  bad = sorted(t for t in toolset if t.startswith("mcp__playwright__"))
  if bad:
    msg = f"mixed_cli_run bad={bad}"
    print(msg)
    sys.exit(42)

print("ok")
PY
}

collect_screenshots() {
  local run_id="$1"
  local marker_file="$2"
  local run_dir="$SCREENSHOTS_DIR/$run_id"
  local moved_count=0

  mkdir -p "$run_dir"

  local src_dirs=(
    "$PROJECT_DIR"
    "$PROJECT_DIR/.playwright-cli"
    "$PROJECT_DIR/scripts/screenshots"
    "$SCREENSHOTS_DIR"
  )

  for src in "${src_dirs[@]}"; do
    [[ -d "$src" ]] || continue

    while IFS= read -r shot; do
      [[ "$shot" == "$run_dir/"* ]] && continue

      local base target n
      base="$(basename "$shot")"
      target="$run_dir/${run_id}-${base}"
      n=1
      while [[ -e "$target" ]]; do
        target="$run_dir/${run_id}-${n}-${base}"
        n=$((n + 1))
      done

      mv "$shot" "$target"
      moved_count=$((moved_count + 1))
    done < <(
      find "$src" -maxdepth 1 -type f -newer "$marker_file" \
        \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) \
        -print 2>/dev/null || true
    )
  done

  echo "$moved_count"
}

# ── Randomized run order ──────────────────────────────────
RUNS=(
  "C-PC-2  playwright-cli  C  2"
  "A-MCP-1 playwright-mcp  A  1"
  "B-PC-1  playwright-cli  B  1"
  "C-MCP-3 playwright-mcp  C  3"
  "A-PC-2  playwright-cli  A  2"
  "B-MCP-1 playwright-mcp  B  1"
  "C-PC-1  playwright-cli  C  1"
  "A-MCP-2 playwright-mcp  A  2"
  "B-PC-3  playwright-cli  B  3"
  "C-MCP-1 playwright-mcp  C  1"
  "A-PC-3  playwright-cli  A  3"
  "B-MCP-2 playwright-mcp  B  2"
  "C-PC-3  playwright-cli  C  3"
  "A-MCP-3 playwright-mcp  A  3"
  "B-PC-2  playwright-cli  B  2"
  "C-MCP-2 playwright-mcp  C  2"
  "A-PC-1  playwright-cli  A  1"
  "B-MCP-3 playwright-mcp  B  3"
)

echo "run_id,approach,task,rep,sonnet_input,sonnet_output,sonnet_cache_read,sonnet_cache_creation,haiku_input,haiku_output,total_cost_usd,duration_ms,num_turns,session_id,result_snippet" \
  > "$RESULTS_FILE"

TOTAL=${#RUNS[@]}
CURRENT=0
backup_original_mcp_config
trap cleanup_mcp_config EXIT

for run in "${RUNS[@]}"; do
  read -r run_id approach task rep <<< "$run"
  CURRENT=$((CURRENT + 1))
  log_file="$LOGS_DIR/${run_id}.json"
  debug_file="$LOGS_DIR/${run_id}.debug.log"
  session_file="$LOGS_DIR/${run_id}.session.jsonl"
  prompt=$(get_prompt "$approach" "$task")
  extra_flags=()
  if [[ "$approach" == "playwright-mcp" ]]; then
    allowed="$MCP_ALLOWED"
    disallowed="$MCP_DISALLOWED"
    extra_flags+=(--disable-slash-commands)
    restore_mcp_server
    set_mcp_headless_config
  else
    allowed="$PC_ALLOWED"
    disallowed="$PC_DISALLOWED"
    disable_mcp_server
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Run $CURRENT/$TOTAL │ $run_id │ $approach │ Task $task │ Rep $rep"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  pkill -f "Google Chrome for Testing" 2>/dev/null || true
  pkill -f "[Cc]hromium"               2>/dev/null || true
  pkill -f "@playwright/mcp"           2>/dev/null || true
  pkill -f "playwright"                2>/dev/null || true
  sleep 5
  shot_marker="$(mktemp "$PROJECT_DIR/.shot-marker-${run_id}.XXXXXX")"
  touch "$shot_marker"

  claude_args=(
    -p "$prompt"
    --output-format json
    --model claude-sonnet-4-6
    --dangerously-skip-permissions
    --allowedTools "$allowed"
    --disallowedTools "$disallowed"
    --debug-file "$debug_file"
  )
  if [[ ${#extra_flags[@]} -gt 0 ]]; then
    claude_args+=("${extra_flags[@]}")
  fi
  claude "${claude_args[@]}" > "$log_file" 2>&1 || echo "  ⚠ Claude exited non-zero"

  f=()
  while IFS= read -r line; do f+=("$line"); done < <(parse_log "$log_file")
  sonnet_input="${f[0]:-}" sonnet_output="${f[1]:-}" sonnet_cr="${f[2]:-}" sonnet_cc="${f[3]:-}"
  haiku_input="${f[4]:-}"  haiku_output="${f[5]:-}"
  cost="${f[6]:-}" duration="${f[7]:-}" turns="${f[8]:-}" result_snippet="${f[9]:-}" session_id="${f[10]:-}"

  if [[ -n "$session_id" ]]; then
    transcript_src=$(find "$HOME/.claude/projects" -name "${session_id}.jsonl" -print -quit 2>/dev/null || true)
    [[ -n "$transcript_src" && -f "$transcript_src" ]] && cp "$transcript_src" "$session_file" || true
  fi

  if [[ -f "$session_file" ]]; then
    if purity_msg=$(check_tool_purity "$session_file" "$approach"); then
      echo "  tool_purity → $purity_msg"
    else
      echo "  ❌ tool_purity → $purity_msg"
      echo "  Aborting: tool isolation violation detected in $run_id"
      exit 1
    fi
  fi

  echo "  cost: \$${cost} │ duration: ${duration}ms │ turns: ${turns}"
  echo "  sonnet → in: ${sonnet_input} out: ${sonnet_output} cache_read: ${sonnet_cr}"
  echo "  result: ${result_snippet}"
  echo "  log → $log_file"
  echo "  debug → $debug_file"
  [[ -f "$session_file" ]] && echo "  session → $session_file" || echo "  session → NOT FOUND (session_id=${session_id:-none})"

  csv_snippet="\"${result_snippet//\"/\"\"}\""
  echo "$run_id,$approach,$task,$rep,$sonnet_input,$sonnet_output,$sonnet_cr,$sonnet_cc,$haiku_input,$haiku_output,$cost,$duration,$turns,$session_id,$csv_snippet" \
    >> "$RESULTS_FILE"

  SHOT_DIR="$SCREENSHOTS_DIR/$run_id"
  moved_shots="$(collect_screenshots "$run_id" "$shot_marker")"
  rm -f "$shot_marker"
  echo "  screenshots → $SHOT_DIR (moved: $moved_shots)"

  echo "  ⏳ Cooling down 10s..."
  sleep 10
done

echo ""
echo "══════════════════════════════════════════════════"
echo "  All $TOTAL runs complete."
echo "  Results → $RESULTS_FILE"
echo "  Logs    → $LOGS_DIR/"
echo "══════════════════════════════════════════════════"
