#!/usr/bin/env bash
set -euo pipefail

# Two-case skill POC for Juice Shop.
# Goal: verify the harness works end-to-end (prompt -> tools -> logs -> screenshots).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$DEFAULT_PROJECT_DIR}"

POC_DIR="$PROJECT_DIR/poc"
LOGS_DIR="$POC_DIR/logs"
SCREENSHOTS_DIR="$POC_DIR/screenshots"
RESULTS_CSV="$POC_DIR/results.csv"
if [[ -f "$PROJECT_DIR/.mcp.json" ]]; then
  MCP_BASE_DIR="$PROJECT_DIR"
else
  MCP_BASE_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
fi
MCP_JSON="$MCP_BASE_DIR/.mcp.json"
MCP_BACKUP="$MCP_BASE_DIR/.mcp.poc.backup.json"

mkdir -p "$LOGS_DIR" "$SCREENSHOTS_DIR"
RUN_CWD="$PROJECT_DIR"
if [[ ! -d "$RUN_CWD/.claude" ]]; then
  parent_dir="$(cd "$RUN_CWD/.." && pwd)"
  if [[ -d "$parent_dir/.claude" ]]; then
    RUN_CWD="$parent_dir"
  fi
fi
cd "$RUN_CWD"
unset CLAUDECODE

# POC keeps browser control via MCP only (no bash fallback).
ALLOWED_TOOLS="mcp__playwright__*,Skill"
DISALLOWED_TOOLS="Bash,Read,TodoWrite,Task"

PROMPT_C1=$'$sql-injection\nTarget: http://localhost:3333\nTask: Attempt SQL injection login bypass at the Juice Shop login page using a classic tautology payload (for example in the email field), then report if authentication was bypassed. Save at least one screenshot and keep actions strictly in scope.'
PROMPT_C2=$'$idor\n$broken-function-level-authorization\nTarget: http://localhost:3333\nTask: Demonstrate an authorization chain: (1) attempt object-level unauthorized access (IDOR/BOLA style), (2) attempt an unauthorized privileged action (BFLA style), and (3) if possible combine both into one chain. Use at least two identities when needed. Save at least one screenshot and provide concrete evidence.'

backup_mcp() {
  if [[ -f "$MCP_JSON" && ! -f "$MCP_BACKUP" ]]; then
    cp "$MCP_JSON" "$MCP_BACKUP"
  fi
}

restore_mcp() {
  if [[ -f "$MCP_BACKUP" ]]; then
    mv "$MCP_BACKUP" "$MCP_JSON"
  fi
}

set_mcp_config() {
  cat > "$MCP_JSON" <<EOF
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

parse_json_field() {
  local file="$1"
  local path="$2"
  python3 - "$file" "$path" <<'PY'
import json, sys
file_path, path = sys.argv[1], sys.argv[2]
try:
    with open(file_path, encoding="utf-8") as f:
        data = json.load(f)
except Exception:
    print("")
    sys.exit(0)

cur = data
for part in path.split("."):
    if not part:
        continue
    if isinstance(cur, dict):
        cur = cur.get(part)
    else:
        cur = None
        break
if cur is None:
    print("")
elif isinstance(cur, (dict, list)):
    print(json.dumps(cur, ensure_ascii=False))
else:
    print(cur)
PY
}

copy_transcript() {
  local log_json="$1"
  local out_session="$2"
  local session_id
  session_id="$(parse_json_field "$log_json" "session_id")"
  [[ -z "$session_id" ]] && return 0

  local src
  src="$(find "$HOME/.claude/projects" -name "${session_id}.jsonl" -print -quit 2>/dev/null || true)"
  [[ -n "$src" && -f "$src" ]] && cp "$src" "$out_session" || true
}

check_purity() {
  local session_file="$1"
  python3 - "$session_file" <<'PY'
import json, sys
session_file = sys.argv[1]
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
has_skill = "Skill" in toolset
bad = sorted(t for t in toolset if t in {"Bash", "Read", "TodoWrite", "Task"})
print(f"has_mcp={has_mcp};has_skill={has_skill};bad={','.join(bad)}")
if (not has_mcp) or bad:
    sys.exit(42)
PY
}

collect_screenshots() {
  local run_id="$1"
  local marker_file="$2"
  local run_dir="$SCREENSHOTS_DIR/$run_id"
  local moved=0
  mkdir -p "$run_dir"

  local src_dirs=(
    "$RUN_CWD"
    "$PROJECT_DIR"
    "$RUN_CWD/.playwright-cli"
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
      moved=$((moved + 1))
    done < <(
      find "$src" -maxdepth 1 -type f -newer "$marker_file" \
        \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) \
        -print 2>/dev/null || true
    )
  done
  echo "$moved"
}

run_one() {
  local run_id="$1"
  local case_id="$2"
  local prompt="$3"
  local log_json="$LOGS_DIR/${run_id}.json"
  local debug_log="$LOGS_DIR/${run_id}.debug.log"
  local session_jsonl="$LOGS_DIR/${run_id}.session.jsonl"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  POC RUN │ $run_id │ $case_id"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  pkill -f "Google Chrome for Testing" 2>/dev/null || true
  pkill -f "[Cc]hromium"               2>/dev/null || true
  pkill -f "@playwright/mcp"           2>/dev/null || true
  pkill -f "playwright"                2>/dev/null || true
  sleep 2

  local marker
  marker="$(mktemp "$POC_DIR/.shot-marker-${run_id}.XXXXXX")"
  touch "$marker"

  local args=(
    -p "$prompt"
    --output-format json
    --model claude-sonnet-4-6
    --dangerously-skip-permissions
    --disable-slash-commands
    --allowedTools "$ALLOWED_TOOLS"
    --disallowedTools "$DISALLOWED_TOOLS"
    --max-turns 30
  )

  if claude "${args[@]}" >"$log_json" 2>"$debug_log"; then
    echo "  ✓ Claude exited cleanly"
  else
    echo "  ⚠ Claude exited non-zero (see $debug_log)"
  fi

  copy_transcript "$log_json" "$session_jsonl"

  local purity="no_session_file"
  if [[ -f "$session_jsonl" ]]; then
    if purity="$(check_purity "$session_jsonl")"; then
      echo "  tool_purity: $purity"
    else
      echo "  tool_purity: $purity"
      echo "  ❌ Purity check failed for $run_id"
    fi
  fi

  local shots
  shots="$(collect_screenshots "$run_id" "$marker")"
  rm -f "$marker"

  local turns cost duration sid result
  turns="$(parse_json_field "$log_json" "num_turns")"
  cost="$(parse_json_field "$log_json" "total_cost_usd")"
  duration="$(parse_json_field "$log_json" "duration_ms")"
  sid="$(parse_json_field "$log_json" "session_id")"
  result="$(parse_json_field "$log_json" "result" | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g' | cut -c1-160)"

  echo "  screenshots_moved: $shots"
  echo "  turns: $turns | cost_usd: $cost | duration_ms: $duration"

  printf '%s,%s,%s,%s,%s,%s,%s,"%s"\n' \
    "$run_id" "$case_id" "$turns" "$cost" "$duration" "$sid" "$shots" "$result" \
    >> "$RESULTS_CSV"
}

backup_mcp
trap restore_mcp EXIT
set_mcp_config

echo "run_id,case_id,num_turns,total_cost_usd,duration_ms,session_id,screenshots_moved,result_excerpt" > "$RESULTS_CSV"

run_one "POC-C1-SQLI" "C1_SQLI" "$PROMPT_C1"
sleep 5
run_one "POC-C2-IDOR-BFLA" "C2_IDOR_BFLA" "$PROMPT_C2"

echo ""
echo "══════════════════════════════════════════════════"
echo "POC complete."
echo "Results CSV: $RESULTS_CSV"
echo "Logs:        $LOGS_DIR"
echo "Screenshots: $SCREENSHOTS_DIR"
echo "══════════════════════════════════════════════════"
