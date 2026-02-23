#!/usr/bin/env bash
set -euo pipefail

db="${OPENCODE_DB_PATH:-$HOME/.local/share/opencode/opencode.db}"
sid=""
dir="$PWD"
fmt="text"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session)
      sid="${2:-}"
      shift 2
      ;;
    --dir)
      dir="${2:-}"
      shift 2
      ;;
    --db)
      db="${2:-}"
      shift 2
      ;;
    --json)
      fmt="json"
      shift
      ;;
    -h | --help)
      cat <<'EOF'
Usage: session-usage.sh [--session <id>] [--dir <path>] [--db <path>] [--json]

Options:
  --session <id>  Use a specific session ID.
  --dir <path>    Directory to match when --session is not set (default: current directory).
  --db <path>     Override database path (default: $OPENCODE_DB_PATH or ~/.local/share/opencode/opencode.db).
  --json          Output JSON instead of text.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if ! command -v sqlite3 >/dev/null 2>&1; then
  echo "sqlite3 is required but not found in PATH." >&2
  exit 1
fi

if [[ ! -f "$db" ]]; then
  echo "OpenCode database not found: $db" >&2
  exit 1
fi

safe_dir=${dir//\'/\'\'}
safe_sid=${sid//\'/\'\'}

where="(directory = '$safe_dir' OR '$safe_dir' LIKE directory || '/%' OR directory LIKE '$safe_dir' || '/%')"
if [[ -n "$sid" ]]; then
  where="id = '$safe_sid'"
fi

sql="
WITH target AS (
  SELECT id, title, directory, time_updated
  FROM session
  WHERE $where
  ORDER BY time_updated DESC
  LIMIT 1
),
spend AS (
  SELECT COALESCE(SUM(COALESCE(json_extract(m.data, '\$.cost'), 0)), 0) AS cost
  FROM message m
  JOIN target t ON m.session_id = t.id
  WHERE json_extract(m.data, '\$.role') = 'assistant'
),
last AS (
  SELECT
    COALESCE(json_extract(m.data, '\$.tokens.input'), 0) AS input_tokens,
    COALESCE(json_extract(m.data, '\$.tokens.output'), 0) AS output_tokens,
    COALESCE(json_extract(m.data, '\$.tokens.reasoning'), 0) AS reasoning_tokens,
    COALESCE(json_extract(m.data, '\$.tokens.cache.read'), 0) AS cache_read_tokens,
    COALESCE(json_extract(m.data, '\$.tokens.cache.write'), 0) AS cache_write_tokens
  FROM message m
  JOIN target t ON m.session_id = t.id
  WHERE
    json_extract(m.data, '\$.role') = 'assistant'
    AND COALESCE(json_extract(m.data, '\$.tokens.output'), 0) > 0
  ORDER BY m.time_created DESC
  LIMIT 1
)
SELECT
  t.id AS session_id,
  t.title AS title,
  printf('%.6f', s.cost) AS cost_usd,
  COALESCE(l.input_tokens, 0) AS input_tokens,
  COALESCE(l.output_tokens, 0) AS output_tokens,
  COALESCE(l.reasoning_tokens, 0) AS reasoning_tokens,
  COALESCE(l.cache_read_tokens, 0) AS cache_read_tokens,
  COALESCE(l.cache_write_tokens, 0) AS cache_write_tokens,
  (
    COALESCE(l.input_tokens, 0) +
    COALESCE(l.output_tokens, 0) +
    COALESCE(l.reasoning_tokens, 0) +
    COALESCE(l.cache_read_tokens, 0) +
    COALESCE(l.cache_write_tokens, 0)
  ) AS context_tokens
FROM target t
CROSS JOIN spend s
LEFT JOIN last l;
"

if [[ "$fmt" == "json" ]]; then
  out=$(sqlite3 -json "$db" "$sql")
  if [[ "$out" == "[]" ]]; then
    echo "No matching session found for: ${sid:-$dir}" >&2
    exit 1
  fi
  echo "$out"
  exit 0
fi

row=$(sqlite3 "$db" "$sql")
if [[ -z "$row" ]]; then
  echo "No matching session found for: ${sid:-$dir}" >&2
  exit 1
fi

IFS='|' read -r id title_val cost input output reasoning cache_read cache_write ctx <<<"$row"

echo "Session: $id"
echo "Title: $title_val"
echo "Cost: \$${cost}"
echo "Context tokens: $ctx"
echo "Breakdown: input=$input output=$output reasoning=$reasoning cache.read=$cache_read cache.write=$cache_write"
