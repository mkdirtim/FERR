#!/usr/bin/env bash
# ============================================================
# Demo run — headed browser, any task
# Usage: ./run_demo.sh [mcp|cli] [A|B|C]
# Default: mcp, Task A (SQL injection bypass — most visual)
# For documentation / screen recording purposes.
# Run from an EXTERNAL terminal (not inside Claude Code)
# ============================================================
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MCP_JSON="$PROJECT_DIR/.mcp.json"
MCP_BACKUP="$PROJECT_DIR/.mcp.headless.json"
MCP_DISABLED="$PROJECT_DIR/.mcp.demo.disabled.json"

unset CLAUDECODE

APPROACH="${1:-mcp}"   # mcp | cli
TASK="${2:-A}"         # A | B | C

MCP_ALLOWED="mcp__playwright__*"

# ── Task prompts ──────────────────────────────────────────
TASK_A='Go to http://localhost:3333, navigate to the login page, and attempt to bypass authentication using SQL injection: enter the email '"'"' OR true--'"'"' with any password. Take a screenshot showing the result and report whether the login was bypassed.'
TASK_B='Go to http://localhost:3333, find the search field in the navigation bar, and enter the XSS payload: <iframe src="javascript:alert('\''xss'\'')">. Take a screenshot of the result and report whether the payload was reflected or executed in the page.'
TASK_C='Go to http://localhost:3333, log in with email admin@juice-sh.op and password admin123, then execute JavaScript to retrieve the value stored in localStorage under the key "token". Decode the JWT payload and report the claims you find (user ID, email, role).'

case "$TASK" in
  A) TASK_BODY="$TASK_A" ; TASK_LABEL="Task A — SQL Injection Bypass" ;;
  B) TASK_BODY="$TASK_B" ; TASK_LABEL="Task B — DOM XSS via Search" ;;
  C) TASK_BODY="$TASK_C" ; TASK_LABEL="Task C — JWT Extraction from localStorage" ;;
  *) echo "Usage: $0 [mcp|cli] [A|B|C]" ; exit 1 ;;
esac

# ── Approach config ───────────────────────────────────────
EXTRA_FLAGS=()
case "$APPROACH" in
  mcp)
    PROMPT="Use the playwright MCP to: $TASK_BODY"
    LABEL="playwright-mcp (headed)"
    ALLOWED="$MCP_ALLOWED"
    DISALLOWED="Skill,Bash(*),Read,TodoWrite,Task"
    EXTRA_FLAGS+=(--disable-slash-commands)
    # Swap out headless config for the duration of this run
    cp "$MCP_JSON" "$MCP_BACKUP"
    mkdir -p "$PROJECT_DIR/scripts/screenshots/demo"
    cat > "$MCP_JSON" <<EOF
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--output-dir", "$PROJECT_DIR/scripts/screenshots/demo"]
    }
  }
}
EOF
    ;;
  cli)
    PROMPT="Use the playwright-cli skill to (IMPORTANT: run the browser in visible headed mode, e.g. playwright-cli open --headed ...): $TASK_BODY"
    LABEL="playwright-cli (headed)"
    ALLOWED="Bash(playwright-cli:*)"
    DISALLOWED="mcp__playwright__*,TodoWrite,Task"
    if [[ -f "$MCP_JSON" ]]; then
      mv "$MCP_JSON" "$MCP_DISABLED"
    fi
    ;;
  *)
    echo "Usage: $0 [mcp|cli] [A|B|C]"
    exit 1
    ;;
esac

restore_mcp() {
  if [[ -f "$MCP_DISABLED" ]]; then
    mv "$MCP_DISABLED" "$MCP_JSON"
    echo "  ↩ Restored .mcp.json (CLI isolation)"
  fi
  if [[ -f "$MCP_BACKUP" ]]; then
    mv "$MCP_BACKUP" "$MCP_JSON"
    echo "  ↩ Restored headless .mcp.json"
  fi
}
trap restore_mcp EXIT

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  DEMO RUN │ $LABEL │ $TASK_LABEL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "$PROJECT_DIR"
claude_args=(
  -p "$PROMPT"
  --output-format stream-json
  --verbose
  --model claude-sonnet-4-6
  --dangerously-skip-permissions
  --allowedTools "$ALLOWED"
  --disallowedTools "$DISALLOWED"
)
if [[ ${#EXTRA_FLAGS[@]} -gt 0 ]]; then
  claude_args+=("${EXTRA_FLAGS[@]}")
fi
claude "${claude_args[@]}" | python3 -u -c "
import sys, json

def fmt_tool(name, inp):
    short = name.replace('mcp__playwright__', '')
    for key in ('url', 'command', 'script', 'expression', 'text', 'element', 'selector', 'key', 'action'):
        if key in inp:
            val = str(inp[key])[:100].replace('\n', ' ')
            return f'  → {short:30s}  {val}'
    if inp:
        k, v = next(iter(inp.items()))
        return f'  → {short:30s}  {str(v)[:100].replace(chr(10), \" \")}'
    return f'  → {short}'

turn = 0
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        event = json.loads(line)
    except Exception:
        continue

    etype = event.get('type', '')

    if etype == 'assistant':
        turn += 1
        content = event.get('message', {}).get('content', [])
        for block in content:
            if block.get('type') == 'tool_use':
                print(f'  [{turn:02d}] {fmt_tool(block[\"name\"], block.get(\"input\", {}))}')
                sys.stdout.flush()

    elif etype == 'result':
        cost   = event.get('total_cost_usd', 0)
        ms     = event.get('duration_ms', 0)
        turns  = event.get('num_turns', '')
        result = str(event.get('result', ''))[:300]
        print()
        print('  Result: ' + result)
        print(f'  Cost:   \${cost:.4f}')
        print(f'  Turns:  {turns}')
        print(f'  Time:   {ms / 1000:.1f}s')
        sys.stdout.flush()
"

echo ""
echo "  Demo complete."
