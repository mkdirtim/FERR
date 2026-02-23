#!/usr/bin/env bash
# OpenHack container entrypoint
# Starts mitmproxy, configures system-wide proxy env vars, and wires the CA
# into the Chromium/Playwright NSS store before handing off to CMD.
set -euo pipefail

MITMPROXY_PORT=8080
FLOW_FILE=/tmp/flows.mitm
CA_CERT=/usr/local/share/ca-certificates/openhack-ca.crt

# ---------------------------------------------------------------------------
# 1. Start mitmdump in the background
# ---------------------------------------------------------------------------
mitmdump \
  --listen-host 127.0.0.1 \
  --listen-port "${MITMPROXY_PORT}" \
  --ssl-insecure \
  --save-stream-file "${FLOW_FILE}" \
  --quiet &

MITM_PID=$!
echo "[entrypoint] mitmdump started (pid ${MITM_PID}) → 127.0.0.1:${MITMPROXY_PORT}, flows → ${FLOW_FILE}"

# ---------------------------------------------------------------------------
# 2. Write proxy env vars to /etc/profile.d so new shells inherit them
# ---------------------------------------------------------------------------
sudo tee /etc/profile.d/proxy.sh > /dev/null <<EOF
export http_proxy=http://127.0.0.1:${MITMPROXY_PORT}
export https_proxy=http://127.0.0.1:${MITMPROXY_PORT}
export HTTP_PROXY=http://127.0.0.1:${MITMPROXY_PORT}
export HTTPS_PROXY=http://127.0.0.1:${MITMPROXY_PORT}
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
EOF

# Also export for the current process (inherited by CMD)
export http_proxy="http://127.0.0.1:${MITMPROXY_PORT}"
export https_proxy="http://127.0.0.1:${MITMPROXY_PORT}"
export HTTP_PROXY="http://127.0.0.1:${MITMPROXY_PORT}"
export HTTPS_PROXY="http://127.0.0.1:${MITMPROXY_PORT}"

# ---------------------------------------------------------------------------
# 3. Add CA to the NSS store for Chromium / Playwright
# ---------------------------------------------------------------------------
if [ -f "${CA_CERT}" ]; then
  mkdir -p /home/opencode/.pki/nssdb
  certutil -N -d sql:/home/opencode/.pki/nssdb --empty-password 2>/dev/null || true
  certutil -A \
    -n "OpenHack Root CA" \
    -t "C,," \
    -i "${CA_CERT}" \
    -d sql:/home/opencode/.pki/nssdb 2>/dev/null || true
  echo "[entrypoint] CA added to NSS store"
else
  echo "[entrypoint] WARNING: CA cert not found at ${CA_CERT}, skipping NSS import"
fi

# ---------------------------------------------------------------------------
# 4. Hand off to CMD (default: /bin/bash)
# ---------------------------------------------------------------------------
exec "$@"
