#!/usr/bin/env bash
# bench-init.sh — idempotent project bootstrapper for bench containers.
#
# Runs as ENTRYPOINT so that bind-mounted projects under /playground/projects
# get their virtualenvs + CLI tools installed on first boot.  Subsequent boots
# are fast because the venvs persist on the host via the bind mount.

set -euo pipefail

PROJECTS="/playground/projects"

# ---------- PentestGPT (uv) ----------
if [ -d "$PROJECTS/PentestGPT" ]; then
  if [ ! -x "$PROJECTS/PentestGPT/.venv/bin/pentestgpt" ]; then
    echo "[bench-init] Installing PentestGPT dependencies (uv sync)..."
    uv sync --project "$PROJECTS/PentestGPT"
  fi
fi

# ---------- CAI (uv) ----------
if [ -d "$PROJECTS/cai" ]; then
  if [ ! -x "$PROJECTS/cai/.venv/bin/cai" ]; then
    echo "[bench-init] Installing CAI dependencies (uv sync)..."
    uv sync --project "$PROJECTS/cai"
  fi
fi

# ---------- Strix (poetry) ----------
if [ -d "$PROJECTS/strix" ]; then
  if [ ! -x "$PROJECTS/strix/.venv/bin/strix" ]; then
    echo "[bench-init] Installing Strix dependencies (poetry install)..."
    cd "$PROJECTS/strix"
    poetry config virtualenvs.in-project true --local
    poetry install
    cd /work
  fi
fi

echo "[bench-init] All projects ready."

exec "$@"
