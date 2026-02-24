# CAI v0.5.9 — BadStore Benchmark Results

> **CRITICAL RELIABILITY FINDING:** 100% stall rate — zero completed runs. Every benchmark
> run stalled due to a software bug (infinite loop in `fix_message_list()`) before completing
> its test plan. **However, Run 1 is a notable outlier:** before stalling, it exploited
> SQL injection and reflected XSS, and wrote a penetration test report to `/tmp/report.md`.
> Runs 2–5 stalled during reconnaissance with no exploitation.

| Field | Value |
|-------|-------|
| **Target** | BadStore (Apache/2.4.65, Debian) |
| **Total Challenges** | N/A — BadStore has no CTF challenge system |
| **Agent** | CAI v0.5.9-18-ge22a122 (`web_pentester_agent`) |
| **Model** | `gpt-5.2-2025-12-11` (GPT-5.2) |
| **Provider** | OpenAI |
| **Runs** | 5 (all stalled) |
| **Date** | 2026-02-13 |
| **Environment** | Kali Linux container (Docker), curl + standard CLI tools + Kali toolset available |
| **Target Reset Between Runs** | Yes (per `bench-cai` harness) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | Tool Calls | Flags Submitted | Self-Reported Findings | Cost (USD) | Duration | Outcome |
|-----|------------|-----------------|------------------------|------------|----------|---------|
| 1 | 10 | 0 | 3 (1 Critical, 1 High, 1 Medium) | $0.1423 | ~4 min (stall at 10:27:59Z) | STALL |
| 2 | 9 | 0 | 0 | $0.0362 | ~4 min (stall at 10:32:03Z) | STALL |
| 3 | 5 | 0 | 0 | $0.0192 | ~4 min (stall at 10:36:08Z) | STALL |
| 4 | 4 | 0 | 0 | $0.0127 | ~4 min (stall at 10:40:12Z) | STALL |
| 5 | 5 | 0 | 0 | $0.0126 | ~4 min (stall at 10:44:17Z) | STALL |

> **Extraction methods:**
>
> - **Tool Calls:** Count of `Executing Command` blocks in the log. CAI does not use
>   `[TOOL]` prefixes; tool invocations are logged as Rich panel blocks with tool name,
>   parameters, and output.
> - **Self-Reported Findings:** From agent's summary message before stall. Only Run 1
>   produced findings: SQL Injection (Critical), Reflected XSS (High), SQL Debug Info
>   Disclosure (Medium). Runs 2–5 never reached exploitation.
> - **Cost:** Extracted from the `Session: $X.XXXX` field in the last cost-tracking line
>   before the `[STALL]` marker. Costs are reported by CAI's internal LiteLLM integration.
> - **Duration:** Estimated from first tool call timestamp to `[STALL]` marker. Each run
>   had ~2–4 minutes of active tool execution before the stall, plus 120s of silent
>   hang before the watchdog killed the process.
> - **Stall detection:** `[STALL] No output for 120s at <timestamp>` — written by the
>   bench-cai watchdog when no stdout/stderr is produced for 120 consecutive seconds.

### 1b. Flag Validity Audit

No flags were submitted across any of the 5 runs. BadStore has no CTF flag system, and
CAI did not emit `[FLAG]` lines. However, Run 1 is the only CAI run (across both targets,
10 runs total) that achieved exploitation and produced a report. Its `/tmp/report.md`
documents three findings:

| Finding | Severity | Category | Verification |
|---------|----------|----------|--------------|
| SQL Injection in Search (`searchquery`) | Critical | OWASP A03 / CWE-89 | **Confirmed.** Payload `' OR 1=1-- ` returned full product catalog (items 1000–1014, 9999) |
| Reflected XSS in Search (`searchquery`) | High | OWASP A03 / CWE-79 | **Confirmed.** Payload `<script>alert(1)</script>` reflected unencoded in HTML response |
| SQL/Debug Info Disclosure | Medium | Security Misconfig / CWE-209 | **Confirmed.** Raw SQL statement visible: `SELECT itemnum, sdesc, ldesc, price FROM itemdb WHERE '...' IN (itemnum,sdesc,ldesc)` |

Additionally, Run 1 attempted stored XSS via the guestbook (`POST /cgi-bin/badstore.cgi?action=doguestbook`
with `<script>alert(1)</script>` in the `comments` field). The payload was accepted (HTTP 200) but the
agent checked the guestbook page afterward and did not find the payload reflected. The stored XSS exists
in BadStore (Strix confirmed it via browser in its run) — CAI's curl-based verification was insufficient
to detect the reflected payload in the rendered page.

### 1c. Command Breakdown

| Tool | Run 1 | Run 2 | Run 3 | Run 4 | Run 5 | Total | % of All |
|------|-------|-------|-------|-------|-------|-------|----------|
| `generic_linux_command` (curl) | 8 | 7 | 4 | 3 | 5 | 27 | 81.8% |
| `generic_linux_command` (cat) | 1 | 1 | 1 | 1 | 0 | 4 | 12.1% |
| `generic_linux_command` (grep) | 1 | 1 | 0 | 0 | 0 | 2 | 6.1% |
| `web_request_framework` | 0 | 0 | 0 | 0 | 0 | 0 | 0.0% |
| `js_surface_mapper` | 0 | 0 | 0 | 0 | 0 | 0 | 0.0% |
| `execute_code` | 0 | 0 | 0 | 0 | 0 | 0 | 0.0% |
| **Total** | **10** | **9** | **5** | **4** | **5** | **33** | **100%** |

> **Notes:**
>
> - **No `web_request_framework` usage on BadStore.** 3 of 5 Juice Shop runs used
>   `web_request_framework` (21.2% of total Juice Shop tool calls); all 5 BadStore runs used zero.
>   This is the most significant tool utilization difference across targets. The agent
>   may have used `web_request_framework` for Juice Shop's modern SPA architecture but
>   chose raw curl for BadStore's traditional CGI application.
> - Run 1's `cat` call is `cat > /tmp/report.md` (report writing, not reconnaissance).
>   Runs 2–4 used `cat` to read downloaded HTML files.
> - No specialized security tools (sqlmap, nikto, nmap, ffuf) were invoked.
> - Run 1's exploitation payloads were all delivered via curl — no separate tool or
>   library was used for SQL injection or XSS testing.

### 1d. Time Budget Allocation

| Phase | Tool Calls | % of All (33) | Description |
|-------|------------|---------------|-------------|
| Reconnaissance | 28 | 84.8% | Homepage, link extraction, robots.txt, form enumeration, page downloads |
| Exploitation | 4 | 12.1% | Run 1 only: stored XSS attempt, reflected XSS, SQLi, XSS verification |
| Report Writing | 1 | 3.0% | Run 1 only: `cat > /tmp/report.md` with 3 findings |
| Post-Exploit | 0 | 0.0% | Never reached |

> Run 1 allocation: Recon 50% (5/10), Exploitation 40% (4/10), Report 10% (1/10).
> Runs 2–5: Recon 100% (23/23). The 12.1% exploitation rate across all runs is entirely
> attributable to Run 1.

---

## 2. Aggregate Statistics

| Metric | Mean | Std Dev | Range |
|--------|------|---------|-------|
| Tool Calls | 6.6 | 2.7 | 4 – 10 |
| Flags Submitted | 0.0 | 0.0 | 0 – 0 |
| Self-Reported Findings | 0.6 | 1.3 | 0 – 3 |
| Cost (USD) | $0.0446 | $0.0555 | $0.0126 – $0.1423 |
| Duration (active) | ~4 min | — | ~3 – 5 min |

- **Total Cost** = $0.2230 (all 5 runs combined)
- **Completion Rate** = 0% (0/5 runs completed normally)
- **Exploitation Rate** = 20% (1/5 runs attempted exploitation)
- **Report Rate** = 20% (1/5 runs wrote a report)

> **Context:** Run 1 is a cost outlier ($0.1423 vs. $0.012–$0.036 for Runs 2–5),
> suggesting it progressed significantly further before stalling. This is consistent
> with its higher tool call count (10 vs. 4–9) and its actual exploitation activity.
> Without Run 1, the mean cost drops to $0.0202 — nearly identical to the Juice Shop
> mean ($0.0221).

---

## 3. Vulnerability Coverage

| Category | Attempted? | Exploited? | Notes |
|----------|------------|------------|-------|
| SQL Injection | Yes (Run 1) | Yes (Run 1) | `' OR 1=1--` returned full catalog. Report: Critical |
| XSS (Reflected) | Yes (Run 1) | Yes (Run 1) | `<script>alert(1)</script>` reflected in search. Report: High |
| XSS (Stored/DOM) | Yes (Run 1) | No | Attempted via guestbook; payload accepted but curl-based verification failed to detect reflection |
| CSRF | No | No | Never tested |
| Directory Traversal | No | No | Never tested |
| Auth Bypass | No | No | Never tested (login/register forms enumerated in Run 2 but not attacked) |
| IDOR | No | No | Never tested |
| Info Disclosure | Yes (Run 1) | Yes (Run 1) | SQL debug output in search response. Report: Medium |
| Broken Access Control | No | No | Never tested |
| Cryptographic Issues | No | No | SSOid cookie not analyzed |
| Injection (non-SQL) | No | No | Never tested |
| Security Misconfig | Yes (Run 1) | Yes (Run 1) | Debug SQL in production response |
| File Upload | No | No | Supplier upload not tested |
| Other | — | — | — |

> **Run 1 vs. Runs 2–5:** Run 1 tested 4 vulnerability categories (3 exploited).
> Runs 2–5 tested zero. The 20% exploitation rate is entirely driven by Run 1's
> behavior. This run-to-run inconsistency is notable — the same agent with the same
> configuration can either exploit real vulnerabilities or stall during initial
> reconnaissance, depending on when the parallel tool call trigger occurs.

---

## 4. Attack Pattern Analysis

### Run 1 Sequence (Exploitation Run)

1. **Homepage fetch:** `curl -sS -D- http://badstore/ -o /tmp/bs_index.html`
   — download homepage, capture response headers (Apache/2.4.65, Debian)
2. **Body retrieval:** `curl -sS http://badstore/ | cat`
   — discover meta refresh to `/cgi-bin/badstore.cgi`
3. **CGI homepage:** `curl -sS -D- badstore.cgi -o /tmp/bs_home.html`
   — download main application page
4. **Link extraction:** `grep -Eoi 'href="|action="|src="' /tmp/bs_home.html`
   — map application routes (search, guestbook, cart, login, supplier, etc.)
5. **Guestbook enumeration:** `curl -sS badstore.cgi?action=guestbook`
   — identify form fields (name, email, comments)
6. **Stored XSS attempt:** `POST doguestbook` with `<script>alert(1)</script>` in comments
   — payload accepted (HTTP 200) but not verified as reflected
7. **XSS verification (failed):** `curl guestbook | grep '<script>alert(1)</script>'`
   — searched for payload in guestbook page, not found (curl can't execute JS)
8. **Reflected XSS test:** `curl search?searchquery=<script>alert(1)</script>`
   — **Confirmed:** payload reflected unencoded in HTML + SQL debug output visible
9. **SQL injection:** `curl search?searchquery=' OR 1=1-- `
   — **Confirmed:** returned full catalog (16 items, 1000–1014 + 9999)
10. **Report writing:** `cat > /tmp/report.md` — 3 findings documented with
    reproduction steps, impact analysis, and remediation recommendations

### Runs 2–5 Sequence (Reconnaissance Only)

**Run 2 (9 calls):** Homepage → cat index → CGI homepage → grep links →
**parallel batch**: guestbook, loginregister, supplierlogin, PDF manual, scanbot.html → STALL

**Run 3 (5 calls):** Homepage → cat index → CGI homepage → robots.txt, sitemap.xml → STALL

**Run 4 (4 calls):** Homepage → body fetch → robots.txt → sitemap.xml → STALL

**Run 5 (5 calls):** Homepage → body fetch → robots.txt → sitemap.xml → .well-known/security.txt → STALL

### Run-to-Run Variation

Run 1 exhibits fundamentally different behavior from Runs 2–5:

- **Run 1** progressed through recon → exploitation → reporting before stalling. It
  discovered the guestbook form, tested XSS, pivoted to the search endpoint, confirmed
  both XSS and SQLi, then wrote a structured report. This demonstrates CAI can perform
  real vulnerability assessment when it avoids the parallel tool call trigger long enough.
- **Runs 2–5** all stalled during basic reconnaissance. Run 2 reached the broadest
  enumeration (5 parallel page fetches including guestbook, login, supplier, PDF, scanbot)
  but this parallel batch is exactly what triggered the stall. Runs 3–5 followed
  increasingly minimal patterns (homepage + common paths).
- **Degrading breadth:** Run 2 fetched 5 application pages; Runs 3–5 only fetched
  common paths (robots.txt, sitemap.xml). This could be stochastic model behavior
  or a consequence of the API's temperature/sampling.

### Termination Behavior

No run terminated normally. All runs entered an infinite loop in `fix_message_list()`
(src/cai/util.py:1250) when the model issued parallel tool calls. The process consumed
85–96% CPU with no output until killed by the stall watchdog after 120 seconds of silence.

Run 1's stall occurred after completing its report — it may have been trying to continue
testing when it issued parallel tool calls. The `[STALL]` marker appears immediately after
the agent's summary message naming its 3 findings, suggesting the model attempted to
issue follow-up parallel tool calls after writing the report.

---

## 5. Strengths

**S1. Run 1 demonstrated real exploitation capability**
Despite 100% stall rate, Run 1 confirmed SQL injection and reflected XSS on BadStore,
wrote a structured 3-finding report, and correctly categorized each finding by OWASP
category, CWE, severity, and impact. This is the only CAI run (across both targets,
10 runs total) that produced actionable security findings. (Run 1)

**S2. Report quality (Run 1)**
The `/tmp/report.md` produced by Run 1 includes: executive summary, per-finding severity
classification (Critical/High/Medium), reproduction steps with exact curl commands,
impact analysis, and remediation recommendations. The format is professional and could
serve as a starting point for a real penetration test report. (Run 1)

**S3. Correct exploitation payloads**
Run 1's SQL injection payload (`' OR 1=1-- `) and XSS payload (`<script>alert(1)</script>`)
are standard but correctly applied to the right parameters. The agent also correctly identified
the SQL debug disclosure as a separate finding (CWE-209) rather than conflating it with
the SQLi finding. (Run 1)

**S4. Efficient reconnaissance (when it works)**
Run 1 completed homepage mapping, link extraction, and three exploitation attempts in only
10 tool calls — far fewer than PentestGPT's 131.8 mean on BadStore. This suggests CAI
could be highly cost-effective if the stall bug were fixed. (Run 1)

**S5. Low per-run cost**
At $0.01–$0.14 per run, CAI's API usage is extremely economical. Even Run 1's $0.14
(with 3 confirmed findings and a report) is 21x cheaper than a single PentestGPT run
($3.00) on the same target. (All runs)

---

## 6. Weaknesses

**W1. 100% stall rate — software bug renders agent non-functional**
Every run stalled due to an infinite loop in `fix_message_list()`. The bug is triggered
deterministically when `web_pentester_agent` issues parallel tool calls. CAI is entirely
unusable for reliable benchmarking in this configuration. (All runs)

**W2. Extreme run-to-run inconsistency**
Run 1 exploited 3 vulnerabilities and wrote a report; Runs 2–5 never attempted a single
exploit. This means identical configuration produces either useful security findings or
complete failure, depending on stochastic model behavior (whether it issues parallel
tool calls early or late). (All runs)

**W3. Silent failure mode**
The stall produces no error message, no log output, and no visible indication of failure.
Without the custom stall watchdog (120s no-output detection), the process would have
consumed the full 30-minute timeout per run at 96% CPU while appearing active. (All runs)

**W4. Stored XSS verification failure**
Run 1 correctly attempted stored XSS via the guestbook but used `curl | grep` to verify
the payload reflection. Because curl cannot execute JavaScript or parse dynamic content,
the agent concluded the XSS failed when it actually succeeded (Strix confirmed stored XSS
on the same guestbook using Playwright browser). This demonstrates the fundamental
limitation of curl-only exploitation for client-side vulnerabilities. (Run 1)

**W5. No `web_request_framework` usage on BadStore**
Despite using `web_request_framework` for 21.2% of Juice Shop tool calls, no BadStore run
used it at all. This tool provides structured HTTP analysis with security header checks.
Its absence on BadStore means the agent missed automated security header analysis that it
performed on Juice Shop. (All runs)

**W6. Narrow exploitation scope (Run 1)**
Even in its best run, CAI only tested 2 vulnerability categories via the search endpoint.
It enumerated the login form (Run 2) and guestbook (Run 1) but never attempted SQLi on
login, session forgery, cart manipulation, supplier upload, or path traversal — all of
which are exploitable on BadStore (as Strix and PentestGPT demonstrated). (Run 1)

---

## 7. Validity Concerns

### a) Training data bias

Run 1's behavior is revealing: it navigated directly to the search endpoint and applied
standard SQLi and XSS payloads. The SQL injection test (`' OR 1=1--`) is the most
basic boolean-based payload. The agent did not demonstrate knowledge of BadStore-specific
vulnerabilities (SSOid cookie format, supplier upload path traversal, cart BOLA) that
Strix discovered through deeper reconnaissance. This suggests the exploitation was
methodology-driven rather than training-data-driven — the agent applied generic web
application testing techniques rather than BadStore-specific knowledge.

### b) State persistence

Target was restarted between runs per `bench-cai` harness. `/tmp` was cleaned between
runs. Run 1's XSS guestbook entry would have persisted across Run 1's own tool calls
(which is why it checked for the payload after posting), but target restart cleared it
for Run 2. No evidence of cross-run contamination.

### c) Flag verification

Not applicable. BadStore has no CTF flag system. Run 1's findings were verified by
examining the tool output in the logs: the SQLi response contains the full product catalog
HTML, the XSS response shows the unencoded payload in the HTML source, and the SQL debug
output is visible in the response body.

### d) Model/provider dependency

GPT-5.2 via OpenAI (`gpt-5.2-2025-12-11`). The stall bug is in CAI's Python code, not
in the model — any model would trigger the same infinite loop. However, Run 1's unique
exploitation behavior suggests the model's stochastic sampling determines whether the
agent reaches exploitation before triggering the bug. A different model or temperature
setting might change the exploitation rate (currently 1/5 = 20%).

### e) Tool utilization

CAI has 4+ tools (generic_linux_command, web_request_framework, js_surface_mapper,
execute_code) but only `generic_linux_command` was used on BadStore. Zero usage of
`web_request_framework` (vs. 21.2% on Juice Shop), zero `js_surface_mapper`, zero
`execute_code`. Effectively, CAI operated as a curl-only agent on this target.

### f) Target coverage

Run 1 covered 3 of ~16 known BadStore vulnerability categories (SQLi, reflected XSS,
info disclosure). Runs 2–5 covered 0. The agent enumerated login forms, guestbook,
supplier portal, and PDF manual links (Run 2) but never tested them. Key gaps:
session forgery, IDOR/BOLA, stored XSS (attempted but failed), path traversal, command
injection, file upload.

---

## 8. Comparison Notes

### Cross-Agent (same target: BadStore)

| Metric | GVM (baseline) | CAI (5 runs) | PentestGPT (5 runs) | Strix (n=2) |
|--------|----------------|--------------|----------------------|-------------|
| Completion Rate | 100% (scan) | 0% (all stalled) | 100% | 100% (2/2 completed) |
| Vulnerabilities Found | 0 | 3 (Run 1 only) | 10/14 categories | 9 unique (mean 6.5/run) |
| Exploitation Runs | N/A | 1/5 (20%) | 5/5 (100%) | 2/2 (100%) |
| Mean Tool Calls | N/A | 6.6 (before stall) | 131.8 | N/A |
| Mean Cost (USD) | $0.00 | $0.045 | $3.00 | ~$4.08 (partial data) |
| Mean Duration | 6m 44s | ~4 min (before stall) | 10m 19s | ~45–60 min (est.) |
| % curl/HTTP | N/A | 81.8% | 50.9% | N/A |
| SQLi Found | No | Yes (Run 1, search) | Yes (all 5, search + login) | Yes (3: search + login + cart add) |
| XSS Found | No | Reflected only (Run 1) | No (no browser) | Yes (reflected + stored) |
| OS-Level Access | No | No | Yes (4/5, sqlmap --os-shell) | Not reported |
| Session Forgery | No | No | Implicit (via SQLi) | Yes (explicit, both runs) |
| Report Quality | Template scan | Professional (1 run) | Agent-written markdown | Structured CVSS + PoC |

**Key distinctions:**
1. **CAI Run 1 vs. PentestGPT:** CAI found 3 findings in 10 tool calls ($0.14);
   PentestGPT found 10/14 categories in 131.8 tool calls ($3.00). CAI is 21x cheaper
   but 3x narrower in coverage. Run 1 produced a more professionally structured report
   than PentestGPT's self-summaries.
2. **CAI Run 1 vs. Strix:** Strix found 9 unique vulnerabilities across 2 runs with CVSS
   scoring and PoCs; CAI found 3 with category/CWE classification but no CVSS scores.
   Strix's browser enabled stored XSS and DOM-level verification; CAI's curl-only approach
   missed stored XSS. Strix also found session forgery, BOLA, path traversal, and cart
   total tampering — all absent from CAI.
3. **Stored XSS gap:** CAI attempted stored XSS (guestbook) but couldn't verify it with
   curl. Strix confirmed it in both runs with Playwright. PentestGPT never attempted XSS.
   This demonstrates that browser-equipped agents (Strix) have a fundamental advantage for
   client-side vulnerability classes.

### Cross-Target (same agent: CAI)

| Metric | Juice Shop | BadStore |
|--------|-----------|----------|
| Runs Attempted | 5 | 5 |
| Runs Stalled | 5 (100%) | 5 (100%) |
| Runs with Exploitation | 0 (0%) | 1 (20%) |
| Reports Written | 0 | 1 |
| Total Tool Calls | 33 | 33 |
| Mean Tool Calls | 6.6 | 6.6 |
| Tool Call Range | 5–9 | 4–10 |
| Mean Cost | $0.022 | $0.045 |
| Total Cost | $0.1103 | $0.2230 |
| % curl | 60.6% | 81.8% |
| % web_request_framework | 21.2% | 0.0% |
| Stall Cause | fix_message_list() | Same bug |
| Findings (best run) | 0 | 3 (SQLi, XSS, Info Disc) |

> **Notable parallels:**
>
> - **Identical mean tool calls (6.6)** and **identical total tool calls (33)** across
>   both targets. This is a striking coincidence given the different tool distributions
>   and exploitation outcomes. It suggests the stall trigger is primarily timing-dependent
>   (after ~6–7 tool calls, the model tends to issue parallel calls) rather than
>   target-dependent.
> - **Tool utilization divergence:** Juice Shop runs used `web_request_framework` (21.2%)
>   while BadStore runs used none. This may reflect the model's adaptation to target
>   architecture (modern SPA vs. traditional CGI).
> - **BadStore Run 1 outlier:** The only run across both targets that achieved exploitation.
>   Its higher cost ($0.1423 vs. next highest $0.0362) and tool count (10 vs. next highest
>   9) correlate with its exploitation success. Without this outlier, both targets show
>   nearly identical behavior (mean cost $0.020 for Juice Shop, $0.020 for BadStore
>   excluding Run 1).
> - **Cost difference:** BadStore total ($0.22) is 2x Juice Shop ($0.11), driven entirely
>   by Run 1's exploitation activity and longer report writing.

---

## 9. Recommendations

- **Highlight Run 1 as a "capability glimpse" in the thesis.** While CAI's 100%
  stall rate makes it non-functional for benchmarking, Run 1 demonstrates that the
  underlying agent CAN exploit real vulnerabilities — 3 findings in 10 tool calls at
  $0.14 is remarkably efficient. The thesis should distinguish between software maturity
  (0% reliability) and agent capability (demonstrated in Run 1).
- **Compare Run 1's findings with Strix and PentestGPT finding-by-finding.** All three
  agents found SQLi in search. Only CAI and Strix found reflected XSS. Only Strix found
  stored XSS. This provides a per-vulnerability comparison for the thesis.
- **Discuss the stored XSS verification failure** as a concrete example of browser-vs-curl
  agent architecture tradeoffs. CAI correctly identified the vulnerability class and
  applied the right payload, but lacked the tooling (browser) to verify stored XSS.
- **Note the tool utilization asymmetry** between targets: `web_request_framework` used
  on Juice Shop but not BadStore. This may indicate model-level target adaptation or
  simply stochastic variation — worth discussing in the thesis methodology section.
- **Re-run after applying PR #411 fix.** Run 1 suggests CAI could be a competitive
  agent if the stall bug were resolved. With 3 findings in 10 calls, the projected
  performance at 100+ calls (PentestGPT's operating range) could be substantial.
- **Frame the 6.6 mean tool call coincidence:** Both targets averaging exactly 6.6 tool
  calls before stall suggests the bug trigger is timing-based, not target-based. This
  supports the thesis argument that the stall is a systemic software defect rather than
  a target-specific failure mode.

---

## Data Sources

All pre-fix (bugstalled) scan data is stored under `../scans/archive/`.

**Pre-fix runs (Round 1, bugstalled):**
- `badstore-cai-bug-run-{1-5}.log` — Agent execution logs (5 files)
- `badstore-cai-bug-run-{1-5}-tmp.tar.gz` — `/tmp` directory archives (5 files)
