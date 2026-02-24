---
name: tools-proxy
description: Use the mitmproxy traffic capture layer to inspect, filter, and replay HTTP/HTTPS traffic
---

# Proxy — mitmproxy traffic capture and replay

`mitmdump` runs automatically on container start, listening on `127.0.0.1:8080`.
All HTTP/HTTPS traffic from curl, Playwright, and Python `requests` routes through it.
Flows are written to `/tmp/flows.mitm` and flushed to disk immediately per flow.

Use `-n` when reading flows to prevent mitmdump from trying to bind port 8080 again.

---

## Reading captured traffic

```bash
# All captured flows (summary — method, URL, status, size)
mitmdump -n -r /tmp/flows.mitm -q

# Flows with full request/response headers
mitmdump -n -r /tmp/flows.mitm -q --flow-detail 2

# Flows with full headers + body
mitmdump -n -r /tmp/flows.mitm -q --flow-detail 3
```

## Filtering

mitmproxy filter expressions (pass with `--view-filter`):

| Filter | Meaning |
|---|---|
| `~u /api/` | URL contains `/api/` |
| `~u ^https://target` | URL starts with `https://target` |
| `~m POST` | POST requests only |
| `~s 200` | Response status 200 |
| `~s 4` | Any 4xx response |
| `~b password` | Body contains `password` |
| `~h Authorization` | Has Authorization header |
| `~d target.com` | Domain is target.com |
| `expr1 & expr2` | AND |
| `expr1 \| expr2` | OR |
| `!expr` | NOT |

```bash
# All POST requests to /api with 200 response
mitmdump -n -r /tmp/flows.mitm -q --view-filter "~m POST & ~u /api & ~s 200" --flow-detail 3

# All 401/403 responses (access control candidates)
mitmdump -n -r /tmp/flows.mitm -q --view-filter "~s 401 | ~s 403"

# Responses containing a JWT
mitmdump -n -r /tmp/flows.mitm -q --view-filter "~b eyJ" --flow-detail 2
```

## Replaying a flow with modifications

Extract the flow details, then reconstruct with curl through the proxy.
The re-sent request is captured as a new flow automatically.

```bash
# Extract a specific flow's details
mitmdump -n -r /tmp/flows.mitm -q --view-filter "~u /api/user/42" --flow-detail 3

# Re-send with a different ID (IDOR test)
curl -s -x http://127.0.0.1:8080 \
  -H "Authorization: Bearer <token_from_flow>" \
  http://target/api/user/99
```

## Saving a filtered subset

```bash
# Save only API flows to a separate file for focused analysis
mitmdump -n -r /tmp/flows.mitm -w /tmp/api-flows.mitm -q --view-filter "~u /api/"

# Then read it
mitmdump -n -r /tmp/api-flows.mitm -q --flow-detail 3
```

## Checking proxy is running

```bash
# Verify mitmdump process
pgrep -a mitmdump

# Send a test request through the proxy
curl -s -x http://127.0.0.1:8080 http://juiceshop:3000 -o /dev/null -w "%{http_code}"

# Confirm the flow was captured
mitmdump -n -r /tmp/flows.mitm -q | tail -5
```

## Starting a fresh capture

```bash
pkill mitmdump 2>/dev/null || true
rm -f /tmp/flows.mitm
mitmdump \
  --listen-host 127.0.0.1 \
  --listen-port 8080 \
  --ssl-insecure \
  --save-stream-file /tmp/flows.mitm \
  --quiet &
echo "mitmdump restarted, flows at /tmp/flows.mitm"
```

## Common pentesting patterns

### Find authentication endpoints with credentials in the body
```bash
mitmdump -n -r /tmp/flows.mitm -q \
  --view-filter "~m POST & (~b password | ~b token | ~b apikey)" --flow-detail 3
```

### Find IDOR candidates — endpoints with numeric IDs
```bash
mitmdump -n -r /tmp/flows.mitm -q --view-filter "~u /[0-9]+" --flow-detail 2
```

### Find endpoints leaking sensitive data in responses
```bash
mitmdump -n -r /tmp/flows.mitm -q --view-filter "~b email & ~s 200" --flow-detail 3
```

### Capture traffic for a specific action, then inspect it
```bash
# 1. Clear flows for a focused capture
rm -f /tmp/flows.mitm

# 2. Trigger the action (via Playwright or curl through the proxy)
curl -s -x http://127.0.0.1:8080 http://target/api/orders -H "Cookie: session=abc"

# 3. Inspect what was sent and received
mitmdump -n -r /tmp/flows.mitm -q --flow-detail 3
```
