# Container TODO

Backlog for `containers/Dockerfile` and related runtime files.

Legend: `[ ]` open, `[x]` resolved, `(partial)` in progress.

---

## Web proxy / traffic capture

Two approaches evaluated. Pick one — they are mutually exclusive.

### Approach A — mitmproxy (active proxy, LLM-native)

Full passive capture + replay via a local MITM proxy. Closest to what Strix does with Caido,
but uses a tool already in the Kali repos and with a simpler integration surface.

- [x] [PROXY-01] Add `mitmproxy` and `libnss3-tools` to the Dockerfile apt block.
  - `mitmproxy` is in Kali repos — no external download.
  - `libnss3-tools` provides `certutil` to add the CA to the Chromium/Playwright NSS store.

- [x] [PROXY-02] Write `containers/docker-entrypoint.sh` to start `mitmdump` at container boot.
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail

  MITMPROXY_PORT=8080

  # Start mitmdump in background, writing flows to /tmp/flows.mitm
  mitmdump \
    --listen-host 127.0.0.1 \
    --listen-port ${MITMPROXY_PORT} \
    --ssl-insecure \
    --save-stream-file /tmp/flows.mitm \
    --quiet &

  # Set system-wide proxy env vars (sourced by new shells via /etc/profile.d)
  cat <<EOF | sudo tee /etc/profile.d/proxy.sh > /dev/null
  export http_proxy=http://127.0.0.1:${MITMPROXY_PORT}
  export https_proxy=http://127.0.0.1:${MITMPROXY_PORT}
  export HTTP_PROXY=http://127.0.0.1:${MITMPROXY_PORT}
  export HTTPS_PROXY=http://127.0.0.1:${MITMPROXY_PORT}
  # Exclude tools with their own TLS stacks
  export NO_PROXY=127.0.0.1,localhost
  export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
  export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
  EOF

  # Add CA to NSS store for Chromium / Playwright
  mkdir -p /home/opencode/.pki/nssdb
  certutil -N -d sql:/home/opencode/.pki/nssdb --empty-password 2>/dev/null || true
  certutil -A -n "OpenHack Root CA" -t "C,," \
    -i /app/certs/ca.crt \
    -d sql:/home/opencode/.pki/nssdb

  exec "$@"
  ```

- [x] [PROXY-03] Add `ENV` lines to Dockerfile for Python `requests` trust store.
  ```dockerfile
  ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
  ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
  ```

- [x] [PROXY-04] Wire entrypoint into Dockerfile (after all installs, before EXPOSE).
  ```dockerfile
  COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
  RUN chmod +x /usr/local/bin/docker-entrypoint.sh
  ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
  CMD ["/bin/bash"]
  ```

- [x] [PROXY-05] Write a `proxy` bash skill or agent tool wrapping mitmdump flow reads.
  - List captured flows: `mitmdump -r /tmp/flows.mitm --flow-detail 1 -q`
  - Filter by URL: `mitmdump -r /tmp/flows.mitm -f "~u /api" --flow-detail 3 -q`
  - Replay a flow: `mitmdump -r /tmp/flows.mitm --client-replay /tmp/flows.mitm`
  - Optionally run `mitmweb` alongside for `GET http://127.0.0.1:8081/flows` → JSON response list

- [ ] [PROXY-08] Promote to typed custom tool via `mitmweb` REST API.
  - Replace `mitmdump` with `mitmweb --web-host 127.0.0.1 --web-port 8081` in entrypoint.
  - Write `.opencode/tools/proxy.ts` exposing: `proxy_list_flows`, `proxy_view_flow`,
    `proxy_replay_flow`, `proxy_send_request` (~150 lines TypeScript).
  - REST API: `GET /flows` → JSON array with stable flow IDs; `PUT /flows/{id}` + `POST
    /flows/{id}/replay` for byte-exact replay with modifications. No auth required.
  - **Known issue:** `mitmweb --save-stream-file` has a flush bug — writes buffer to ~100KB
    before flushing to disk instead of per-flow. Flows are immediately available via the REST
    API (in-memory), so live queries are unaffected. Persistence across restarts is laggy.
    Refs: https://discourse.mitmproxy.org/t/mitmweb-appears-to-only-flush-to-save-stream-file-on-exit/1254
          https://github.com/mitmproxy/mitmproxy/issues/7655
  - Also verify whether current `mitmdump --save-stream-file` has the same flush lag — if so,
    `mitmdump -r /tmp/flows.mitm` reads in the `tool-proxy` skill may be stale mid-session.

**Trade-offs:**
- Adds entrypoint complexity and a background process.
- System-wide proxy env vars can break tools with their own TLS stacks (`nuclei`, `httpx`,
  `interactsh`). Mitigated by `NO_PROXY=127.0.0.1,localhost` — but targets on other hosts still
  route through the proxy. May need per-tool `--no-proxy` flags.
- Strong payoff for IDOR testing, session replay, and parameter fuzzing from real captured
  traffic — use cases that are currently impossible without a proxy.

---

### Approach B — no proxy, native tools only (already installed, zero cost)

Standardise on structured JSON output from tools already in the image. No entrypoint,
no background process, no proxy env vars.

- [ ] [PROXY-06] Document canonical LLM-native traffic capture patterns in a skill or guide.

  | Goal | Command | Output |
  |---|---|---|
  | HTTP probe + fingerprint | `httpx -u <url> -json -include-response` | JSON per request |
  | Crawl + endpoint discovery | `katana -u <url> -json -store-responses -store-path /tmp/katana` | JSON + response files |
  | Spider + JS link extraction | `gospider -s <url> -o /tmp/gospider --json` | JSON per page |
  | Hidden parameter discovery | `arjun -u <url> -oJ /tmp/arjun.json` | JSON |
  | Custom request / replay | `curl -s -D - --cacert /app/certs/ca.crt <url>` | Raw HTTP |
  | Vulnerability scan | `nuclei -u <url> -json -o /tmp/nuclei.json` | JSON findings |
  | Secret scan in responses | `trufflehog filesystem /tmp/katana` | Findings to stdout |

- [ ] [PROXY-07] Add a `guide-traffic-capture` skill documenting these patterns so agents use
  them consistently instead of ad-hoc curl invocations.

**Trade-offs:**
- Zero complexity, zero Dockerfile changes.
- No passive interception — each tool makes its own targeted requests; no unified traffic log.
- Sufficient for automated scanning. Gaps appear for replay-based attacks (IDOR, session
  manipulation) where re-sending a real captured request with modifications is needed.
