#!/usr/bin/env bash
# ============================================================
# Dry run: tests ONE run per approach before the full experiment
# Verifies JSON parsing, CSV writing, and that both approaches work
# Run from an EXTERNAL terminal (not inside Claude Code)
# ============================================================
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGS_DIR="$PROJECT_DIR/logs"
MCP_CONFIG="$PROJECT_DIR/.mcp.json"
MCP_CONFIG_DISABLED="$PROJECT_DIR/.mcp.experiment.disabled.json"
MCP_CONFIG_ORIGINAL="$PROJECT_DIR/.mcp.experiment.original.json"
mkdir -p "$LOGS_DIR"

unset CLAUDECODE

parse() {
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d$1)" 2>/dev/null || echo "MISSING"
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
      "args": ["@playwright/mcp@latest", "--headless", "--output-dir", "$PROJECT_DIR/scripts/screenshots"]
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

if approach == "mcp":
  bad = sorted(t for t in toolset if t in {"Skill", "Bash", "Read"})
  if bad or not has_mcp:
    print(f"mixed_mcp_run bad={bad} has_mcp={has_mcp}")
    sys.exit(42)
else:
  bad = sorted(t for t in toolset if t.startswith("mcp__playwright__"))
  if bad:
    print(f"mixed_cli_run bad={bad}")
    sys.exit(42)

print("ok")
PY
}

run_test() {
  local label="$1" prompt="$2" log_file="$3" allowed="$4" disallowed="$5" mode="$6"
  local session_file="${log_file%.json}.session.jsonl"
  local extra_flags=()
  if [[ "$mode" == "mcp" ]]; then
    restore_mcp_server
    set_mcp_headless_config
    extra_flags+=(--disable-slash-commands)
  else
    disable_mcp_server
  fi

  # Kill all browser/playwright-related processes before each run
  pkill -f "Google Chrome for Testing" 2>/dev/null || true
  pkill -f "[Cc]hromium"               2>/dev/null || true
  pkill -f "@playwright/mcp"           2>/dev/null || true
  pkill -f "playwright"                2>/dev/null || true
  sleep 5

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  DRY RUN: $label"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  cd "$PROJECT_DIR"
  claude_args=(
    -p "$prompt"
    --output-format json
    --model claude-sonnet-4-6
    --dangerously-skip-permissions
    --allowedTools "$allowed"
    --disallowedTools "$disallowed"
  )
  if [[ ${#extra_flags[@]} -gt 0 ]]; then
    claude_args+=("${extra_flags[@]}")
  fi
  claude "${claude_args[@]}" > "$log_file" 2>&1 \
    && echo "  ✓ Claude exited cleanly" \
    || echo "  ⚠ Claude exited non-zero"

  session_id=$(parse "['session_id']" < "$log_file")
  if [[ "$session_id" != "MISSING" && -n "$session_id" ]]; then
    transcript_src=$(find "$HOME/.claude/projects" -name "${session_id}.jsonl" -print -quit 2>/dev/null || true)
    [[ -n "$transcript_src" && -f "$transcript_src" ]] && cp "$transcript_src" "$session_file" || true
  fi

  if [[ -f "$session_file" ]]; then
    if purity_msg=$(check_tool_purity "$session_file" "$mode"); then
      echo "  tool_purity:           $purity_msg"
    else
      echo "  tool_purity:           $purity_msg"
      echo "  ❌ Dry run failed tool isolation check"
      exit 1
    fi
  fi

  echo ""
  echo "  Parsed fields:"
  echo "    sonnet_input:          $(parse "['modelUsage']['claude-sonnet-4-6']['inputTokens']"              < "$log_file")"
  echo "    sonnet_output:         $(parse "['modelUsage']['claude-sonnet-4-6']['outputTokens']"             < "$log_file")"
  echo "    cache_read_tokens:     $(parse "['modelUsage']['claude-sonnet-4-6']['cacheReadInputTokens']"     < "$log_file")"
  echo "    cache_creation_tokens: $(parse "['modelUsage']['claude-sonnet-4-6']['cacheCreationInputTokens']" < "$log_file")"
  echo "    total_cost_usd:        $(parse "['total_cost_usd']"                                              < "$log_file")"
  echo "    duration_ms:           $(parse "['duration_ms']"                                                 < "$log_file")"
  echo "    num_turns:             $(parse "['num_turns']"                                                   < "$log_file")"
  echo ""
  echo "  Full JSON → $log_file"
}

# Prompts — Task C (JWT extraction), one per approach
PROMPT_C_MCP='Use the playwright MCP to: Go to http://localhost:3333, log in with email admin@juice-sh.op and password admin123, then execute JavaScript to retrieve the value stored in localStorage under the key "token". Decode the JWT payload and report the claims you find (user ID, email, role).'
PROMPT_C_PC='Use the playwright-cli skill to: Go to http://localhost:3333, log in with email admin@juice-sh.op and password admin123, then execute JavaScript to retrieve the value stored in localStorage under the key "token". Decode the JWT payload and report the claims you find (user ID, email, role).'

MCP_ALLOWED="mcp__playwright__*"
PC_ALLOWED="Bash(playwright-cli:*)"
MCP_DISALLOWED="Skill,Bash(*),Read,TodoWrite,Task"
PC_DISALLOWED="mcp__playwright__*,TodoWrite,Task"

backup_original_mcp_config
trap cleanup_mcp_config EXIT

run_test "playwright-mcp │ Task C" "$PROMPT_C_MCP" "$LOGS_DIR/dryrun-mcp.json" "$MCP_ALLOWED" "$MCP_DISALLOWED" "mcp"
echo "  ⏳ Cooling down 10s before next run..."
sleep 10
run_test "playwright-cli │ Task C" "$PROMPT_C_PC"  "$LOGS_DIR/dryrun-pc.json"  "$PC_ALLOWED" "$PC_DISALLOWED" "cli"

echo ""
echo "══════════════════════════════════════════════════"
echo "  Dry run complete. Check output above for MISSING fields."
echo "  If all fields parsed correctly → run the full experiment:"
echo "    ./scripts/run_experiment.sh"
echo "══════════════════════════════════════════════════"
