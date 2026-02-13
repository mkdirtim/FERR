# CAI — Juice Shop Benchmark Results

> **Two benchmark rounds were conducted.** Round 1 (v0.5.9, pre-fix) stalled in
> every run due to an infinite loop in `fix_message_list()` — see §1-extra and
> `stalled-cai-juiceshop-results.md` for full details. Round 2 (post-fix) applied
> the PR #411 patch locally, enabling the agent to complete assessments and write
> reports. This file presents Round 2 as the primary results, with Round 1 data
> included as historical comparison in §1-extra and §8.

| Field | Value |
|-------|-------|
| **Target** | OWASP Juice Shop (v19.1.1) |
| **Total Challenges** | 110 |
| **Agent** | CAI (vunknown, PR #411 fix applied locally) (`web_pentester_agent`) |
| **Model** | `gpt-5.2-2025-12-11` (GPT-5.2) |
| **Provider** | OpenAI |
| **Runs** | 5 (Round 2, post-fix) + 5 (Round 1, pre-fix — all stalled) |
| **Date** | 2026-02-13 |
| **Environment** | Kali Linux container (Docker), curl + standard CLI tools + Kali toolset available |
| **Target Reset Between Runs** | Yes (per `bench-cai` harness) |

---

## 1. Quantitative Results (Round 2: Post-Fix)

### 1a. Per-Run Summary

| Run | Tool Calls | Flags Submitted | Self-Reported Findings | Cost (USD) | Duration | Outcome |
|-----|------------|-----------------|------------------------|------------|----------|---------|
| 1 | 8 | 0 | 3 (1 High, 1 Med, 1 Low) | $0.0759 | ~4 min | IDLE (post-report) |
| 2 | 3 | 0 | 3 (1 Med, 1 Low, 1 Info) | $0.0366 | ~4 min | IDLE (post-report) |
| 3 | 6 | 0 | 3 (1 Med, 1 Low-Med, 1 Info) | $0.0733 | ~4 min | IDLE (post-report) |
| 4 | 10 | 0 | 2 (1 High, 1 Low) | $0.0977 | ~10 min | IDLE (post-report, rate limited) |
| 5 | 0 | 0 | 0 | $0.0000 | ~6 min | RATE_LIMIT |

> **Extraction methods:**
>
> - **Tool Calls:** Count of tool invocation panels (`Executing Command`) in the log.
>   CAI logs tool calls as Rich panel blocks with tool name, parameters, and output.
> - **Flags Submitted:** Zero across all runs. CAI has no flag submission mechanism
>   and was not instructed to capture CTF flags.
> - **Self-Reported Findings:** Extracted from the agent's final summary message
>   after writing `/tmp/report.md`. Severity ratings are the agent's own assessment.
> - **Cost:** Extracted from `Session: $X.XXXX` in the last cost-tracking line before
>   the `[STALL]` marker. Costs are reported by CAI's internal LiteLLM integration.
> - **Duration:** Wall clock from first tool call timestamp to `[STALL]` marker.
>   Includes ~120s of idle time (stall watchdog timeout) for Runs 1–4.
>   Run 4 includes ~4 min of OpenAI rate limit waits. Run 5 spent its entire
>   duration on rate limit retries (3 attempts, all failed).
> - **Outcome:** "IDLE" means the agent completed its assessment, wrote a report,
>   and went idle at the REPL prompt. The 120s stall watchdog then killed the process.
>   This is fundamentally different from the pre-fix "STALL" (infinite CPU loop).

### 1b. Flag Validity Audit

No flags were submitted. CAI has no `[FLAG]` emission mechanism, and the harness
prompt (`"Target in scope: ${url}. Write findings to /tmp/report.md."`) does not
instruct the agent to capture or submit CTF flags. This is a harness design
limitation, not an agent limitation.

### 1c. Command Breakdown

| Tool | Run 1 | Run 2 | Run 3 | Run 4 | Run 5 | Total | % of All |
|------|-------|-------|-------|-------|-------|-------|----------|
| `generic_linux_command` (curl) | 4 | 1 | 4 | 8 | 0 | 17 | 63.0% |
| `generic_linux_command` (cat) | 2 | 1 | 1 | 1 | 0 | 5 | 18.5% |
| `generic_linux_command` (grep) | 1 | 0 | 0 | 1 | 0 | 2 | 7.4% |
| `web_request_framework` | 1 | 1 | 0 | 0 | 0 | 2 | 7.4% |
| `js_surface_mapper` | 0 | 0 | 1 | 0 | 0 | 1 | 3.7% |
| `execute_code` | 0 | 0 | 0 | 0 | 0 | 0 | 0.0% |
| **Total** | **8** | **3** | **6** | **10** | **0** | **27** | **100%** |

> **Notes:**
>
> - 4 of 5 `cat` calls are report writing (`cat > /tmp/report.md`); 1 is file
>   reading (`cat /tmp/robots.txt` in Run 1). Report writing accounts for 14.8%
>   of all tool calls.
> - `js_surface_mapper` was used for the first time across all CAI runs (pre- and
>   post-fix) in Run 3, discovering 22+ API endpoints from JavaScript analysis.
>   Despite this, the agent did not probe the discovered endpoints for vulnerabilities.
> - `web_request_framework` provides structured HTTP analysis with automated security
>   header checks. Used in Runs 1 and 2 only.
> - No specialized security tools (sqlmap, nikto, nmap, ffuf, hydra) were invoked.
> - Run 5 executed zero tools — rate limited before any tool call could be made.

### 1d. Time Budget Allocation

| Phase | % of Tool Calls | Description |
|-------|-----------------|-------------|
| Reconnaissance | 85.2% (23/27) | Homepage, robots.txt, sitemap.xml, /ftp/, API probing, JS mapping |
| Exploitation | 0% (0/27) | No exploitation payloads attempted |
| Post-Exploit | 0% (0/27) | Never reached |
| Report Writing | 14.8% (4/27) | `cat > /tmp/report.md` in Runs 1–4 |

> The agent completes reconnaissance and immediately writes a report. It never
> transitions to exploitation — no SQLi payloads, no authentication bypass attempts,
> no file download via traversal techniques, no active vulnerability testing. Run 4
> came closest to exploitation by downloading `acquisitions.md` from `/ftp/`, but
> this was passive file retrieval rather than vulnerability exploitation.

---

## 1-extra. Round 1 Results (Pre-Fix, Historical)

> Full details in `stalled-cai-juiceshop-results.md`. Summary below.

Round 1 used CAI v0.5.9-18-ge22a122 before the PR #411 fix was applied. All 5 runs
stalled due to an infinite loop in `fix_message_list()` (src/cai/util.py:1250) when
the `web_pentester_agent` issued parallel tool calls.

| Run | Tool Calls | Cost (USD) | Outcome |
|-----|------------|------------|---------|
| 1 | 6 | $0.0206 | STALL (infinite loop) |
| 2 | 7 | $0.0204 | STALL (infinite loop) |
| 3 | 6 | $0.0203 | STALL (infinite loop) |
| 4 | 9 | $0.0355 | STALL (infinite loop) |
| 5 | 5 | $0.0135 | STALL (infinite loop) |

- **Mean tool calls:** 6.6 | **Mean cost:** $0.0221 | **Total cost:** $0.1103
- **Findings:** 0 | **Reports written:** 0 | **Exploitation attempts:** 0
- **Stall cause:** CPU-burning infinite loop (85–96% CPU, no output) when the model
  issued parallel `tool_calls` in a single assistant message. The process appeared
  active but produced no useful work until killed by the 120s stall watchdog.
- **Tool distribution:** curl 60.6%, web_request_framework 21.2%, grep 12.1%,
  python3 3.0%, Other 3.0%

**Root cause (PR #411):** When `web_pentester_agent` issues parallel tool calls,
the second tool response's predecessor in the message list is another tool response,
not the assistant message. The validation logic only checks the immediately preceding
message for a matching `tool_call_id`. Failing to find one, it attempts to reorder
messages in an infinite loop. The fix replaces the single-predecessor check with a
backward traversal.

---

## 2. Aggregate Statistics (Round 2: Post-Fix)

| Metric | Mean | Std Dev | Range |
|--------|------|---------|-------|
| Tool Calls | 5.4 | 4.0 | 0 – 10 |
| Flags Submitted | 0.0 | 0.0 | 0 – 0 |
| Self-Reported Findings | 2.2 | 1.3 | 0 – 3 |
| Cost (USD) | $0.0567 | $0.039 | $0.00 – $0.0977 |
| Duration (wall clock) | ~6 min | — | ~4 – 10 min |

- **Total Cost** = $0.2835 (all 5 post-fix runs combined)
- **Report Rate** = 80% (4/5 runs wrote `/tmp/report.md`)
- **Exploitation Rate** = 0% (0/5 runs attempted exploitation)
- **Rate Limit Failures** = 1 (Run 5 completely blocked; Run 4 degraded)

> **Context:** Total cost for all 5 post-fix runs ($0.28) is less than the cost
> of a single PentestGPT run ($2.27–$2.98). Combined with Round 1, total CAI cost
> across all 10 Juice Shop runs is $0.39. Standard deviation uses sample formula
> (n−1 denominator) for consistency with other results files.

---

## 3. Vulnerability Coverage

| Category | Attempted? | Exploited? | Notes |
|----------|------------|------------|-------|
| SQL Injection | No | No | Not attempted in any run |
| XSS (Reflected) | No | N/A | No browser; not attempted |
| XSS (Stored/DOM) | No | N/A | No browser |
| CSRF | No | N/A | No browser |
| Directory Traversal | No | No | Run 4 tried to download `.bak` file but was blocked by extension filter; did not attempt null byte bypass |
| Auth Bypass | No | No | Not attempted |
| IDOR | No | No | Not attempted; Run 3 discovered API endpoints but did not test for IDOR |
| Info Disclosure | Yes | Yes | /ftp directory listing (Runs 1, 4), acquisitions.md download (Run 4), X-Recruiting header (Runs 2, 3), unauthenticated API response (Run 3) |
| Broken Access Control | No | No | Not attempted |
| Cryptographic Issues | No | No | Not attempted |
| Injection (non-SQL) | No | No | Not attempted |
| Security Misconfig | Yes | No | CORS wildcard identified (all runs), missing CSP/HSTS identified (Runs 1, 2); passive observation only, no exploitation demonstrated |
| File Upload | No | No | Not attempted |
| Other | — | — | — |

> All findings are passive observations from HTTP response headers and directory
> listings. No vulnerability was actively tested with exploitation payloads.
> The agent identified configuration issues but never attempted to demonstrate
> impact (e.g., crafting a CORS exploitation PoC, testing CORS on authenticated
> endpoints, attempting SQLi on API endpoints discovered via `js_surface_mapper`).

---

## 4. Attack Pattern Analysis

### Typical Sequence (Post-Fix)

1. **Homepage fetch:** `curl -sS -D- http://juiceshop:3000/` — capture headers + HTML
2. **Common path probing:** `curl` robots.txt, sitemap.xml
3. **Surface mapping (Run 3 only):** `js_surface_mapper` — analyze JavaScript for API endpoints
4. **Directed probing:** `curl` /ftp/ directory listing, /api/Products (varies by run)
5. **File reading (Runs 1, 4):** `cat`/`grep` to extract data from downloaded files
6. **Report writing:** `cat > /tmp/report.md` — structured pentest report with findings
7. **IDLE** — agent declares findings written, goes idle at REPL prompt
8. **STALL** — 120s watchdog kills the process

### Run-to-Run Variation

The reconnaissance strategy varies more than in the pre-fix runs, reflecting
deeper engagement with the target:

- **Run 1** (8 tools): Most methodical — homepage, robots.txt, sitemap.xml,
  `web_request_framework` for security analysis, file reading, /ftp/ directory
  exploration, grep for file links. Found 3 findings including High-severity
  /ftp directory listing.
- **Run 2** (3 tools): Minimalist — homepage fetch, `web_request_framework`
  security analysis, immediate report. Fastest to complete. Found 3 findings
  but all Low/Info severity.
- **Run 3** (6 tools): Most innovative — first use of `js_surface_mapper` across
  all CAI runs, discovering 22+ API endpoints. Probed `/api/Products` to confirm
  unauthenticated access. Found the most architecturally significant finding
  (unauthenticated API exposure) but did not follow up with IDOR/injection testing.
- **Run 4** (10 tools): Most thorough but rate-limited — extensive /ftp/ exploration
  including actual file downloads (`acquisitions.md` content retrieved). Only run to
  download and read a target file. Multiple rate limit pauses (~4 min total delay).
  Found 2 findings but with the strongest evidence (downloaded confidential document).
- **Run 5** (0 tools): Completely blocked by OpenAI rate limits. 3 retry attempts
  all failed ("Rate limit exceeded after 3 retries"). Never executed any tools.

### Termination Behavior

No run terminated normally. All productive runs (1–4) completed their assessment and
went idle at the CAI REPL prompt, waiting for user input. The 120s stall watchdog
then killed the process. This is fundamentally different from the pre-fix stall:

| Aspect | Pre-Fix (Round 1) | Post-Fix (Round 2) |
|--------|--------------------|--------------------|
| Cause | Infinite loop in `fix_message_list()` | Agent completes work, goes idle |
| CPU | 85–96% (active spin) | ~0% (waiting for input) |
| Output | None (frozen) | Report written before idle |
| Work done | Partial recon only | Recon + report complete |
| Recovery | None (must be killed) | None (harness limitation) |

The harness prompt ("Write findings to /tmp/report.md") is a single-turn instruction.
Once the agent writes the report, it has no further objective. A multi-turn prompt
or explicit "continue testing" instruction might yield deeper results. The configured
`CAI_MAX_TURNS=100` was never approached (max actual turns: 10 in Run 4).

---

## 5. Strengths

**S1. Bug fix enables functional assessment**
After applying PR #411, CAI successfully completed assessments in 4 of 5 runs,
producing structured reports with 2–3 findings each. This demonstrates that the
`web_pentester_agent` is capable of conducting web security assessments when the
parallel tool call bug is resolved. (Runs 1–4)

**S2. Structured, professional report output**
All 4 productive runs wrote well-structured pentest reports to `/tmp/report.md`
with severity ratings, affected endpoints, steps to reproduce, evidence, impact
analysis, and remediation recommendations. Report quality is comparable to
entry-level manual pentest reports. (Runs 1–4)

**S3. Extremely low cost**
At $0.04–$0.10 per productive run, CAI is the most cost-efficient agent tested.
Total cost for 5 post-fix runs ($0.28) is less than a single PentestGPT run ($2.27).
The cost-to-finding ratio is approximately $0.03 per finding. (All runs)

**S4. Unique tooling: js_surface_mapper**
Run 3 demonstrated `js_surface_mapper`, a specialized tool that analyzes JavaScript
source files and extracts API endpoints, authentication flows, high-value strings,
and external origins. This tool discovered 22+ API endpoints in a single invocation
— information that took PentestGPT multiple curl calls to partially discover. No
other tested agent has an equivalent automated JS analysis tool. (Run 3)

**S5. Evidence-based findings with PoC**
Run 4 provided concrete evidence by downloading `acquisitions.md` from `/ftp/`,
demonstrating that the confidential document ("This document is confidential! Do not
distribute!") is accessible without authentication. This is stronger evidence than
simply noting the directory listing exists. (Run 4)

---

## 6. Weaknesses

**W1. Zero exploitation — recon-only agent**
Despite having 100 configured turns and a 30-minute timeout, the agent never
attempted a single exploitation payload across all 5 post-fix runs. No SQL injection,
no authentication bypass, no XSS, no IDOR probing, no null byte traversal. The
agent identifies surface-level configuration issues and stops. Even when Run 3
discovered 22+ API endpoints via `js_surface_mapper`, it probed only one
(`/api/Products`) and only to confirm it returns JSON. (All runs)

**W2. Premature report writing / single-pass strategy**
All productive runs follow the same pattern: brief recon (3–10 tool calls) → write
report → go idle. The agent treats the assessment as a single pass rather than
iterating through discovered attack surface. It never returns to test findings
from earlier phases. Average of 5.4 tool calls per run is far below PentestGPT's
94.8 and the configured limit of 100. (All runs)

**W3. Rate limit vulnerability**
OpenAI rate limiting completely blocked Run 5 and significantly degraded Run 4
(~4 minutes of rate limit waits in a ~10-minute run). This is an operational
reliability issue: 20% of runs produced zero results due to provider-side rate
limiting. Unlike the pre-fix software bug, this is an external dependency that
cannot be fixed in the CAI codebase. (Runs 4, 5)

**W4. No escalation from recon to active testing**
The agent correctly identifies `/ftp/` directory listing, permissive CORS, missing
security headers, and unauthenticated APIs — all of which are reconnaissance
findings. But it never escalates to active testing: does not attempt SQL injection
on API endpoints, does not test CORS on authenticated endpoints, does not attempt
null byte bypass on restricted files (despite Run 4 discovering the extension
filter). (All runs)

**W5. Inconsistent finding depth across runs**
Findings vary significantly across runs despite identical targets:
- Runs 1, 4 found the High-severity /ftp exposure; Runs 2, 3 did not probe /ftp
- Only Run 3 used `js_surface_mapper` and found unauthenticated API exposure
- Only Runs 2, 3 reported X-Recruiting header disclosure
- Run 4 was the only run to download and read an actual file

No single run found all 5 unique finding categories. A complete assessment would
require aggregating findings across all 4 productive runs.

**W6. 85% of tool budget spent on reconnaissance**
85.2% of tool calls are reconnaissance (fetching pages, reading files, probing
endpoints) and 14.8% are report writing. 0% is exploitation. This allocation
reflects a fundamentally passive assessment approach.

---

## 7. Validity Concerns

### a) Training data bias

Moderate concern. The agent's reconnaissance pattern (homepage → robots.txt →
sitemap.xml → /ftp/) is standard web testing methodology and does not necessarily
indicate training data recall. However, Run 3's `js_surface_mapper` output
identified Juice Shop–specific URLs (e.g., `pwning.owasp-juice.shop`,
`owasp-juice.shop`) from JavaScript analysis, confirming the agent processes
target-specific data rather than relying solely on recall. The agent's failure
to exploit known Juice Shop vulnerabilities (unlike PentestGPT, which immediately
navigates to known vulnerable endpoints) suggests it is not leveraging Juice Shop
walkthroughs from training data.

### b) State persistence

Target was restarted between runs per `bench-cai` harness. `/tmp` was cleaned
between runs. State persistence is not a concern — all activity was read-only
reconnaissance that did not modify target state (no account creation, no data
submission, no state changes).

### c) Flag verification

Not applicable. CAI was not instructed to capture CTF flags and has no flag
submission mechanism. The harness prompt requests only a report (`/tmp/report.md`).
Direct comparison with PentestGPT's flag-based metrics is not meaningful without
modifying CAI's harness to include flag-capture instructions.

### d) Model/provider dependency

GPT-5.2 via OpenAI (`gpt-5.2-2025-12-11`). Results may differ with other models.
The rate limiting in Runs 4–5 is OpenAI-specific and would not occur with a
different provider. The recon-only behavior may be model-dependent — a model with
stronger offensive security training might escalate to exploitation given the same
agent framework and tools.

### e) Tool utilization

CAI has a richer tool surface than PentestGPT (`generic_linux_command`,
`web_request_framework`, `js_surface_mapper`, `execute_code`, MCP tools). Post-fix
utilization improved over pre-fix:

| Tool | Pre-Fix Usage | Post-Fix Usage |
|------|---------------|----------------|
| `generic_linux_command` (curl) | 60.6% | 63.0% |
| `generic_linux_command` (cat) | 0% | 18.5% |
| `generic_linux_command` (grep) | 12.1% | 7.4% |
| `web_request_framework` | 21.2% | 7.4% |
| `js_surface_mapper` | 0% | 3.7% |
| `execute_code` | 0% | 0% |

`js_surface_mapper` was used for the first time in post-fix Run 3 but only in
1 of 5 runs. `execute_code` remains unused. No Kali-specific tools (sqlmap,
nikto, nmap, ffuf) were invoked in either round.

### f) Target coverage

Minimal coverage. Of the ~14 vulnerability categories tested, the agent attempted
2 (Info Disclosure, Security Misconfig) and exploited 1 (Info Disclosure via /ftp
file access). No browser-dependent challenges were attempted (no browser available).
Of Juice Shop's 110 CTF challenges, 0 were solved. The agent's coverage is limited
to passive observation of HTTP responses and directory listings.

---

## 8. Comparison Notes

### Cross-Agent (same target: Juice Shop)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (5 runs, post-fix) | Strix (n=2) |
|--------|----------------|----------------------|------------------------|-------------|
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Completion Rate | 100% (scan) | 100% | 80% (1 rate limited) | 100% (2/2 completed) |
| Vulnerabilities Found | 0 (app-layer) | 0 verified flags; ~9 categories exploited | 5 unique findings (passive) | 15 unique (mean 10.5/run) |
| Mean Tool Calls | N/A (plugin-based) | 94.8 | 5.4 | N/A (not logged) |
| Mean Flags Submitted | N/A | 3.4 | 0 (no flag mechanism) | N/A (reports instead) |
| Mean Cost (USD) | $0.00 | $2.49 | $0.057 | N/A (not logged) |
| Total Cost | $0.00 | $12.45 | $0.28 | N/A |
| Mean Duration | 37m 50s | 7m 17s | ~6 min (incl. stall) | ~45–60 min (est.) |
| % curl | N/A | 80.0% | 63.0% | N/A (multi-tool) |
| % specialized tools | N/A | 1.1% | 11.1% | N/A |
| Browser Capability | No | No | No | Yes (Playwright) |
| Exploitation Attempted | No | Yes (SQLi, auth bypass) | No | Yes (SQLi, XSS, JWT, IDOR, mass assignment) |
| Report Quality | Template-based | Agent-written markdown | Agent-written markdown | Structured CVSS + PoC |

> **Key finding:** CAI and PentestGPT represent opposite failure modes on Juice Shop.
> PentestGPT actively exploits vulnerabilities (SQLi, auth bypass, file traversal) but
> cannot capture CTF flags, resulting in 0 verified results despite real exploitation.
> CAI identifies surface-level issues at 44× lower cost but never attempts exploitation,
> resulting in passive-only findings. Strix successfully exploits and validates 15 unique
> vulnerabilities across 2 runs (mean 10.5/run) with structured CVSS + PoC evidence.
> GVM finds nothing at the application layer.

### Cross-Target (same agent: CAI)

| Metric | Juice Shop (post-fix) | BadStore (post-fix) |
|--------|----------------------|---------------------|
| Runs Attempted | 5 | 5 |
| Completion Rate | 80% | 100% |
| Mean Tool Calls | 5.4 | 11.0 |
| Mean Cost | $0.057 | $0.133 |
| % curl | 63.0% | 72.7% |
| % specialized tools | 11.1% | 3.6% |
| Vuln Categories Attempted | 2/14 | 6/14 |
| Report Writing Overhead | 14.8% | 9.1% |

> CAI performs markedly better against BadStore: 100% completion (vs 80%),
> double the tool calls, 3× the vulnerability categories, and a 60%
> exploitation rate (vs 40%). BadStore's simpler legacy stack surfaces more
> actionable attack surface per dollar spent.

### Pre-Fix vs Post-Fix Comparison

| Metric | Round 1 (Pre-Fix, v0.5.9) | Round 2 (Post-Fix, PR #411) |
|--------|---------------------------|----------------------------|
| Runs | 5 | 5 |
| Stall Rate | 100% (infinite loop) | 20% (1 rate limit failure) |
| Stall Cause | `fix_message_list()` infinite loop | Agent idle at REPL + watchdog |
| CPU During Stall | 85–96% (active spin) | ~0% (waiting for input) |
| Mean Tool Calls | 6.6 | 5.4 |
| Total Tool Calls | 33 | 27 |
| Mean Cost | $0.022 | $0.057 |
| Total Cost | $0.11 | $0.28 |
| Reports Written | 0/5 (0%) | 4/5 (80%) |
| Total Findings | 0 | 11 (across 4 runs) |
| Unique Finding Categories | 0 | 5 |
| Exploitation Attempts | 0 | 0 |
| `js_surface_mapper` Used | 0 times | 1 time (Run 3) |
| Tool Diversity | 4 tools | 5 tools |

> **Impact of the fix:** PR #411 transformed CAI from a non-functional tool (100%
> stall rate, 0 findings) to a functional but shallow assessment agent (80% completion,
> passive findings only). The fix resolved the reliability problem but revealed a
> deeper capability limitation: even when the agent can execute unlimited tool calls,
> it chooses to stop after brief reconnaissance and report writing. The pre-fix runs
> actually used more tool calls on average (6.6 vs 5.4), suggesting the stall
> triggered later in the reconnaissance sequence. Post-fix, the agent voluntarily
> stops earlier because it reaches the report-writing phase instead of being killed
> mid-recon.
>
> **Cost increase:** Post-fix runs cost 2.6× more than pre-fix ($0.057 vs $0.022)
> because the agent generates longer responses (report content) and uses more input
> tokens (tool output from completed calls). This is expected — productive work costs
> more than interrupted work.

---

## 9. Recommendations

- **Do not interpret passive findings as the ceiling of CAI's capability.** The
  single-turn harness prompt ("Write findings to /tmp/report.md") incentivizes
  quick reporting over deep testing. Modify the prompt to explicitly request
  exploitation attempts (e.g., "Test for SQL injection, XSS, and authentication
  bypass before writing your report") and compare results.
- **Increase the stall watchdog timeout or implement a smarter idle detector.**
  The current 120s timeout kills sessions that completed their work normally.
  Consider detecting the agent's "report written" declaration and sending a
  follow-up prompt to continue testing, rather than killing the process.
- **Address OpenAI rate limiting for benchmark reliability.** Run 5 produced
  zero results due to provider rate limits. Consider adding delay between benchmark
  runs, using a different model provider, or increasing the retry budget beyond 3
  attempts.
- **Compare with `one_tool_agent` configuration.** The `web_pentester_agent` was
  chosen for its richer tool surface, but the single-pass recon→report pattern
  may be agent-type specific. Testing with different CAI agent types could reveal
  whether the shallow assessment behavior is agent-dependent or model-dependent.
- **Document the pre-fix vs post-fix comparison for the thesis.** The CAI
  benchmark illustrates two distinct failure modes of autonomous agents:
  (1) software reliability (the infinite loop bug) and (2) capability depth
  (recon-only behavior even when exploitation tools are available). Both are
  relevant findings for the thesis discussion of agent maturity.
- **Frame findings relative to harness design.** CAI's lack of flag capture is a
  harness limitation (no flag instruction in prompt), not an agent limitation.
  PentestGPT's harness explicitly detects and submits flag-like strings. Direct
  flag-count comparison between agents is not meaningful without normalizing
  harness design.

---

## Data Sources

All scan data is stored under `data/projects/scans/juiceshop/cai/`.

**Post-fix runs (Round 2):**
- `cai-run-{1-5}.log` — Agent execution logs (5 files)
- `cai-run-{1-4}-tmp.tar.gz` — `/tmp` directory archives (4 files; Run 5 produced no output due to rate limiting)

**Pre-fix runs (Round 1, bugstalled):**
- `bugstalled-cai-run-{1-5}.log` — Agent execution logs (5 files)
- `bugstalled-cai-run-{1-5}-tmp.tar.gz` — `/tmp` directory archives (5 files)
- `bugstalled-cai-run-1-session.tar.gz` — Session archive (Run 1 only, 45 bytes)

**Cross-references:**
- `stalled-cai-juiceshop-results.md` — Detailed pre-fix analysis (referenced in §1-extra)
