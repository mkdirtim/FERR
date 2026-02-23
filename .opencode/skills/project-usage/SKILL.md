---
name: project-usage
description: Retrieve token usage and USD cost for the active session by querying the local SQLite database. Use when the user asks for current session context usage, token totals, or spend, or when a task is defined by a token budget or maximum dollar spend.
---

# Usage

Report usage directly from the local database.

## Run

- Human-readable output:
  - `bash scripts/session-usage.sh`
- JSON output:
  - `bash scripts/session-usage.sh --json`
- Force a specific session:
  - `bash scripts/session-usage.sh --session <session_id> --json`

## Behavior

- If `--session` is not provided, select the most recently updated session whose directory matches `pwd`, contains `pwd`, or is contained by `pwd`.
- Compute total spend as the sum of assistant message `cost` values in that session.
- Compute context tokens from the latest assistant message with output tokens:
  - `input + output + reasoning + cache.read + cache.write`

## Notes

- This is best-effort "current session" detection (most recently updated session in `pwd`).
- Use `OPENCODE_DB_PATH` to override the database path.
- If no session matches, run from the project directory or provide `--session`.
