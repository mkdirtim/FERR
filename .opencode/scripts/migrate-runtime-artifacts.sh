#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
DEST_BASE="$ROOT/data/pentest/running"
STAMP="$(date +%Y%m%d-%H%M%S)"
DEST="$DEST_BASE/_stray-migration-$STAMP"
APPLY=0

if [[ "${1:-}" == "--apply" ]]; then
  APPLY=1
fi

is_run_dir() {
  [[ "$(basename "$1")" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]
}

queue=()

collect_loose() {
  local base="$1"
  [[ -d "$base" ]] || return 0
  while IFS= read -r -d '' item; do
    local name
    name="$(basename "$item")"
    if [[ -d "$item" ]] && is_run_dir "$item"; then
      continue
    fi
    if [[ "$name" == "_stray-migration-"* ]]; then
      continue
    fi
    if [[ "$name" == ".gitkeep" ]]; then
      continue
    fi
    queue+=("$item")
  done < <(find "$base" -mindepth 1 -maxdepth 1 -print0)
}

collect_loose "$ROOT/data/pentest/running"
collect_loose "$ROOT/packages/opencode/data/pentest/running"

if [[ -d "$ROOT/packages/opencode" ]]; then
  while IFS= read -r -d '' item; do
    queue+=("$item")
  done < <(find "$ROOT/packages/opencode" -maxdepth 1 -type f \( \
    -name "session-ses_*.md" -o \
    -name "page-*.yml" -o \
    -name "console-*.log" -o \
    -name "network-*.log" -o \
    -name "jwt*.png" -o \
    -name "sqli-*.png" -o \
    -name "sqli_*.png" -o \
    -name "sqli-*.json" -o \
    -name "login-*.yml" -o \
    -name "login-*.log" -o \
    -name "juice-shop-*.yml" \
  \) -print0)
fi

if [[ "${#queue[@]}" -eq 0 ]]; then
  echo "No stray runtime artifacts found."
  exit 0
fi

echo "Found ${#queue[@]} stray runtime path(s)."
for item in "${queue[@]}"; do
  echo " - $item"
done

if [[ "$APPLY" -ne 1 ]]; then
  echo
  echo "Dry-run only. Re-run with --apply to move paths into:"
  echo "  $DEST"
  exit 0
fi

mkdir -p "$DEST"

for item in "${queue[@]}"; do
  rel="${item#"$ROOT"/}"
  target="$DEST/$rel"
  mkdir -p "$(dirname "$target")"
  mv "$item" "$target"
done

echo "Migration complete."
echo "Stray runtime artifacts moved to: $DEST"
