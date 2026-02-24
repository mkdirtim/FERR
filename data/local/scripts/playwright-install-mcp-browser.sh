#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$ROOT" ]; then
  ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
fi
CFG="$ROOT/.opencode/opencode.jsonc"
SPEC="${PLAYWRIGHT_MCP_SPEC:-}"

if [ -z "$SPEC" ]; then
  if command -v rg >/dev/null 2>&1; then
    SPEC="$(rg -o -m1 "@playwright/mcp@[0-9][^\", ]*" "$CFG" || true)"
  else
    SPEC="$(grep -Eo "@playwright/mcp@[0-9][^\", ]*" "$CFG" | head -n1 || true)"
  fi
fi

if [ -z "$SPEC" ]; then
  echo "Could not find a pinned @playwright/mcp version in $CFG"
  exit 1
fi

echo "Using MCP package: $SPEC"

if [ "${1:-}" = "--dry-run" ]; then
  exit 0
fi

TMP="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT

cat > "$TMP/package.json" <<'EOF'
{"name":"pw-local","private":true}
EOF

cd "$TMP"
bun add "$SPEC"
./node_modules/.bin/playwright install chromium

case "$(uname -s)" in
Darwin)
  echo "Installed browsers under: $HOME/Library/Caches/ms-playwright"
  ;;
*)
  echo "Installed browsers under: $HOME/.cache/ms-playwright"
  ;;
esac
