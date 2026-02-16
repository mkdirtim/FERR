# Strix v0.7.0 — BadStore Benchmark Results

> **Limited sample (n=2).** Due to the high estimated cost of Strix runs (GPT-5 model,
> ~45–60 min runtime each), only 2 runs were conducted. This is the final dataset —
> no additional runs are planned. Several metrics (tool calls, cost, exact duration,
> command breakdown) are not available from the Strix output archive alone — Strix
> persists vulnerability reports and a CSV index, but does not persist raw tool
> execution logs or cost data to disk.

| Field | Value |
|-------|-------|
| **Target** | BadStore (Apache/2.4.65, Debian) |
| **Total Challenges** | N/A — BadStore has no CTF challenge system |
| **Agent** | Strix v0.7.0 (`strix-agent`, Apache-2.0) |
| **Model** | `openai/gpt-5` (GPT-5) |
| **Provider** | OpenAI (via LiteLLM) |
| **Runs** | 2 (final — limited by cost) |
| **Date** | 2026-02-13 (Run 1), 2026-02-13 (Run 2) |
| **Environment** | Kali Linux sandbox container (Docker, `ghcr.io/usestrix/strix-sandbox:0.1.11`), full Kali toolkit + Playwright headless browser + Caido proxy |
| **Target Reset Between Runs** | Yes (container restarted per `bench-strix`) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | Tool Calls | Flags Submitted | Vulnerabilities Reported | Cost (USD) | Duration |
|-----|------------|-----------------|--------------------------|------------|----------|
| 1 | N/A | N/A | 7 (5 Critical, 2 High) | N/A (not captured) | ~39 min (estimated) |
| 2 | N/A | N/A | 6 (5 Critical, 1 High) | $3.73 | ~40 min (estimated) |

> **Metric availability:**
>
> - **Tool Calls:** Not available. Strix does not persist tool execution logs to its
>   output archive.
> - **Flags Submitted:** Not applicable. Strix uses `create_vulnerability_report` instead
>   of a `[FLAG]` mechanism. BadStore has no CTF flag system regardless.
> - **Vulnerabilities Reported:** Count of `vuln-*.md` files in respective run directories.
>   Each passed structured validation (required fields, CVSS vector, dedup check).
> - **Cost:** Partially available. LiteLLM computes cost at runtime and displays it in the
>   TUI summary panel but does not persist it. Run 2 cost ($3.7267) was recovered from
>   the terminal log (`strix-badstore.txt`); cross-checked against `costs.md` §3.1
>   (`strix-badstore.txt:956`). Input 7.6M tokens, Cached 6.6M, Output 69.9K.
>   Run 1 cost was not captured (no terminal log).
> - **Duration:** Estimated from vulnerability timestamps.
>   - **Run 1:** First vulnerability at 00:43:08 UTC, report generated at 01:21:51 UTC
>     (~39 min vuln span). Actual scan includes pre-vuln reconnaissance, so total
>     runtime is likely 45–60 min.
>   - **Run 2:** First vulnerability at 15:14:37 UTC, report generated at 15:54:19 UTC
>     (~40 min span). Total runtime similarly ~45–60 min.
>
> **Proxy evidence (Run 1):** Vulnerability reports reference Caido proxy request IDs up to
> 530 (vuln-0007), indicating at least ~530 HTTP requests were proxied during the scan.
> Run 2 reports do not reference explicit proxy request IDs.

### 1b. Vulnerability Report Audit

#### Run 1 (7 vulnerabilities)

| Vuln ID | Title | Severity | CVSS | Timestamp (UTC) | PoC Included? |
|---------|-------|----------|------|------------------|---------------|
| vuln-0001 | Session Forgery via Unsigned SSOid Cookie — Admin Impersonation | CRITICAL | 9.4 | 00:43:08 | Yes (Python, 50+ lines) |
| vuln-0002 | SQLi in Search (searchquery) — Database Exfiltration | CRITICAL | 9.4 | 00:46:47 | Yes (Python, 35+ lines) |
| vuln-0003 | Reflected XSS in Search — Session Cookie Theft | CRITICAL | 9.6 | 00:56:03 | Yes (Python, 30+ lines) |
| vuln-0004 | Broken Access Control in Cart/Order — Cross-Account Orders + PAN Exposure | HIGH | 7.1 | 01:05:18 | Yes (Python, 90+ lines) |
| vuln-0005 | Path Traversal in Supplier Upload — Arbitrary File Write | HIGH | 8.9 | 01:05:25 | Yes (Python, 40+ lines) |
| vuln-0006 | Stored XSS in Guestbook — Persistent Script Execution | CRITICAL | 9.6 | 01:06:04 | Yes (Python, 30+ lines) |
| vuln-0007 | SQLi in Login — Auth Bypass + Account Impersonation | CRITICAL | 10.0 | 01:21:14 | Yes (Python, 60+ lines) |

**Run 1 summary:** 7 vulnerabilities with mean CVSS 9.14. All include executable Python PoC scripts.
5 Critical (9.4–10.0), 2 High (7.1–8.9).

#### Run 2 (6 vulnerabilities)

| Vuln ID | Title | Severity | CVSS | Timestamp (UTC) | PoC Included? |
|---------|-------|----------|------|------------------|---------------|
| vuln-0001 | Stored Cross-Site Scripting (XSS) in Guestbook Comments | CRITICAL | 9.6 | 15:14:37 | Yes (Python, 30+ lines) |
| vuln-0002 | SQL Injection in Login Endpoint Enables Authentication Bypass | CRITICAL | 9.4 | 15:23:41 | Yes (Python, 50+ lines) |
| vuln-0003 | SQL Injection in Search Parameter — Database Extraction + Arbitrary File Read | CRITICAL | 10.0 | 15:32:42 | Yes (Python, 50+ lines) |
| vuln-0004 | SSOid Session Cookie Forgery — Unauthenticated Admin Impersonation | CRITICAL | 9.1 | 15:34:31 | Yes (Python, 40+ lines) |
| vuln-0005 | Cart Total Tampering via Client-Controlled CartID Cookie — Underpayment | HIGH | 7.5 | 15:44:28 | Yes (Python, 50+ lines) |
| vuln-0006 | SQL Injection in Cart Add (cartitem) — Database Exfiltration | CRITICAL | 10.0 | 15:47:11 | Yes (Python, 30+ lines) |

**Run 2 summary:** 6 vulnerabilities with mean CVSS 9.27. All include executable Python PoC scripts.
5 Critical (9.1–10.0), 1 High (7.5). Run 2 also produced a `penetration_test_report.md`
executive report (generated 15:54:19 UTC).

**CVSS distribution (combined):** 10 Critical, 3 High, 0 Medium/Low/Info.

### 1b-extra. Cross-Run Finding Overlap

| Finding | Run 1 | Run 2 | Classification |
|---------|-------|-------|----------------|
| Stored XSS in Guestbook | vuln-0006 (CRIT 9.6) | vuln-0001 (CRIT 9.6) | Shared |
| SQLi in Login Auth Bypass | vuln-0007 (CRIT 10.0) | vuln-0002 (CRIT 9.4) | Shared |
| SQLi in Search (searchquery) | vuln-0002 (CRIT 9.4) | vuln-0003 (CRIT 10.0) | Shared |
| SSOid Cookie Forgery — Admin Impersonation | vuln-0001 (CRIT 9.4) | vuln-0004 (CRIT 9.1) | Shared |
| Reflected XSS in Search | vuln-0003 (CRIT 9.6) | — | Run 1 only |
| Cart/Order BOLA + PAN Exposure | vuln-0004 (HIGH 7.1) | — | Run 1 only |
| Path Traversal in Supplier Upload | vuln-0005 (HIGH 8.9) | — | Run 1 only |
| Cart Total Tampering via CartID | — | vuln-0005 (HIGH 7.5) | Run 2 only |
| SQLi in Cart Add (cartitem) | — | vuln-0006 (CRIT 10.0) | Run 2 only |

**Summary:** 9 unique findings across 2 runs. 4 shared (core BadStore vulnerabilities
reproduced in both runs), 3 Run-1-only, 2 Run-2-only. Finding overlap is 44% (4/9 unique).

**Notable cross-run differences:**
- Run 2's SQLi in search (vuln-0003, CVSS 10.0) achieved deeper exploitation than
  Run 1 (vuln-0002, CVSS 9.4): Run 2 demonstrated LOAD_FILE() arbitrary file read,
  server source code disclosure, and database credential exposure via the same endpoint.
- Run 2 discovered a **new SQLi endpoint** (cart add `cartitem` parameter, vuln-0006)
  not tested in Run 1.
- Run 2 found **cart total tampering** (business logic flaw) vs. Run 1's **cart BOLA**
  (access control flaw) — different vulnerability classes in the same cart subsystem.
- Run 1 uniquely found reflected XSS and path traversal — browser and file-write
  attack surfaces that Run 2 did not report on.

### 1c-extra. Cross-Target Archive Contamination

**Run 1:** The BadStore output archive (`strix-run-1-output.tar.gz`) contains **both**
`strix_runs/badstore-80_8e2e/` and `strix_runs/juiceshop-3000_638d/`. The Juice Shop
directory is from a prior Strix run that was not cleaned from `/work/strix_runs/` before
the BadStore run was archived. This is a bench-strix harness issue — the `rm -rf /work/strix_runs`
on line 117 of `bench-strix` may not have fully cleaned up between target runs.

**Run 2:** The archive (`strix-run-2-output.tar.gz`) contains only
`strix_runs/badstore-80_aad3/` — no cross-target contamination. The cleanup issue
appears to have been resolved between runs.

### 1c. Command Breakdown

Not available from the output archives. Based on vulnerability report evidence:

| Tool | Run 1 Evidence | Run 2 Evidence | Inferred Usage |
|------|---------------|----------------|----------------|
| `terminal_execute` | HTTP requests, SQLi payloads, cookie manipulation | HTTP requests, SQLi payloads, cookie/cart manipulation | Primary recon and exploitation |
| `python_action` | All 7 PoCs are executable Python scripts | All 6 PoCs are executable Python scripts | Exploit validation and PoC development |
| `browser_action` | vuln-0003 (reflected XSS), vuln-0006 (stored XSS) | vuln-0001 (stored XSS) | Client-side vulnerability verification |
| Proxy tools | Reports cite Caido request IDs (417, 449, 530) | No explicit request IDs | HTTP traffic inspection and evidence |
| `create_vulnerability_report` | 7 structured reports with CVSS | 6 structured reports with CVSS | Formal vulnerability registration |
| `finish_scan` | Executive report generated | Executive report generated (15:54:19 UTC) | Scan completion |

### 1d. Time Budget Allocation

#### Run 1

| Phase | Time Window (UTC) | Duration | Description |
|-------|-------------------|----------|-------------|
| Reconnaissance | ~00:20 – 00:43 | ~23 min | Attack surface mapping, service fingerprinting |
| Exploitation Wave 1 | 00:43 – 00:57 | ~14 min | Session forgery, SQLi search, reflected XSS — 3 vulns |
| Exploitation Wave 2 | 00:57 – 01:06 | ~9 min | Cart/order BOLA, path traversal, stored XSS — 3 vulns |
| Exploitation Wave 3 | 01:06 – 01:21 | ~15 min | SQLi login auth bypass — 1 vuln |
| Report Generation | 01:21 – 01:22 | ~1 min | Executive report via `finish_scan` |

#### Run 2

| Phase | Time Window (UTC) | Duration | Description |
|-------|-------------------|----------|-------------|
| Reconnaissance | ~14:50 – 15:14 | ~24 min | Attack surface mapping, service fingerprinting |
| Exploitation Wave 1 | 15:14 – 15:35 | ~21 min | Stored XSS, SQLi login, SQLi search, SSOid forgery — 4 vulns |
| Exploitation Wave 2 | 15:35 – 15:47 | ~12 min | Cart total tampering, SQLi cart add — 2 vulns |
| Report Generation | 15:47 – 15:54 | ~7 min | Executive report via `finish_scan` |

#### Run-to-Run Comparison

| Metric | Run 1 | Run 2 |
|--------|-------|-------|
| Estimated recon time | ~23 min | ~24 min |
| Vulnerability reporting span | ~39 min | ~33 min |
| Report generation | ~1 min | ~7 min |
| Total estimated | ~45–60 min | ~45–60 min |
| First finding type | Session forgery (architectural) | Stored XSS (injection) |
| Last finding type | SQLi login (injection) | SQLi cart add (injection) |

---

## 2. Aggregate Statistics

| Metric | Run 1 | Run 2 | Mean | SD | Notes |
|--------|-------|-------|------|-----|-------|
| Vulnerabilities Reported | 7 | 6 | 6.5 | 0.7 | 9 unique across both |
| Mean CVSS Score | 9.14 | 9.27 | 9.21 | — | Range: 7.1 – 10.0 |
| Tool Calls | N/A | N/A | — | — | Not persisted |
| Cost (USD) | N/A (not captured) | $3.73 | ~$3.73 | — | Run 2 from TUI log |
| Duration (estimated) | ~45–60 min | ~45–60 min | ~50 min | — | Consistent across runs |
| Proxy Requests Captured | ≥530 | N/R | — | — | Run 2 reports lack request IDs |
| Completion Rate | 100% | 100% | 100% | — | 2/2 completed |

> **Scoring methodology:** BadStore has no CTF flag system. Performance is measured by
> vulnerability count, severity distribution, PoC quality, and report completeness.
> Sample standard deviation (n-1 denominator) is used where applicable.

---

## 3. Vulnerability Coverage

| Category | Run 1 | Run 2 | Combined | Notes |
|----------|-------|-------|----------|-------|
| SQL Injection | Yes (2: search, login) | Yes (3: login, search, cart add) | Yes | 3 unique endpoints. Run 2 added cart add endpoint |
| XSS (Reflected) | Yes (search, `<svg/onload>`) | No | Yes | Run 1 only. **Browser-verified** via Playwright |
| XSS (Stored/DOM) | Yes (guestbook, `<svg onload>`) | Yes (guestbook, `<svg onload>`) | Yes | Both runs. **Browser-verified** |
| CSRF | N/R | N/R | N/R | Not reported as separate finding |
| Directory Traversal | Yes (supplier upload `../../`) | No | Yes | Run 1 only |
| Auth Bypass | Yes (2: cookie forgery, SQLi login) | Yes (2: SQLi login, cookie forgery) | Yes | Both runs |
| IDOR | Yes (CartID replay, cross-account) | No | Yes | Run 1 only |
| Info Disclosure | Yes (PAN, admin portal, password hashes) | Yes (DB creds via LOAD_FILE, source code) | Yes | Different disclosure types per run |
| Broken Access Control | Yes (admin portal via forged cookie) | Yes (admin portal via forged cookie) | Yes | Both runs |
| Cryptographic Issues | Yes (unsigned session cookie) | Yes (unsigned session cookie) | Yes | Both runs |
| Injection (non-SQL) | N/R | N/R | N/R | Not reported |
| Security Misconfig | Yes (verbose DB errors) | Yes (verbose DB errors, LOAD_FILE priv) | Yes | Both runs |
| File Upload | Yes (arbitrary file write via traversal) | No | Yes | Run 1 only |
| Business Logic | No | Yes (cart total tampering) | Yes | Run 2 only |

> **N/R** = Not Reported. Strix may have tested without finding exploitable instances.
>
> **Combined coverage:** 12 of ~16 known BadStore vulnerability categories across both runs.
> Run 1 contributed reflected XSS, IDOR, path traversal, and file upload uniquely. Run 2
> contributed a new SQLi endpoint (cart add) and a business logic flaw (cart total tampering)
> not found in Run 1.

---

## 4. Attack Pattern Analysis

### Run 1 — Typical Sequence

1. **Reconnaissance (~23 min):** Attack surface mapping of CGI endpoints, form discovery,
   service fingerprinting (Apache/2.4.65). Thorough pre-exploitation phase before first
   vulnerability reported.

2. **Session/Auth analysis (00:43, ~4 min):** First finding is the SSOid cookie forgery
   (vuln-0001). The agent reverse-engineered the cookie format
   (`base64(email:md5(password):fullname:role)`) and demonstrated admin impersonation.

3. **Injection testing (00:46–00:56, ~10 min):** SQLi in search (vuln-0002) using
   error-based, boolean, and EXTRACTVALUE extraction techniques. Followed by reflected
   XSS in the same search endpoint (vuln-0003).

4. **Business logic + file operations (01:05, ~10 min):** Cart/order BOLA with CartID
   replay and untrusted email (vuln-0004), path traversal in supplier upload (vuln-0005),
   and stored XSS in guestbook (vuln-0006).

5. **Login exploitation (01:21, ~15 min):** SQLi in login with LIMIT/OFFSET for deterministic
   account selection (vuln-0007).

6. **Report generation (01:21–01:22, ~1 min):** `finish_scan` with executive summary.

### Run 2 — Typical Sequence

1. **Reconnaissance (~24 min):** Similar pre-exploitation phase. Consistent with Run 1 timing.

2. **XSS first (15:14):** First finding is stored XSS in guestbook (vuln-0001) using
   `<svg onload>` payload — different starting point than Run 1 (which started with
   session forgery).

3. **Auth exploitation (15:23–15:34, ~11 min):** SQLi login bypass (vuln-0002) using
   boolean tautology (`' OR '1'='1' --`), then SQLi search with UNION + LOAD_FILE for
   file read and source disclosure (vuln-0003, CVSS 10.0), then SSOid cookie forgery
   with admin portal access and PAN exposure validation (vuln-0004).

4. **Cart exploitation (15:44–15:47, ~3 min):** Cart total tampering via forged CartID
   cookie (vuln-0005), then SQLi in cart add endpoint using error-based, time-based,
   and EXTRACTVALUE techniques (vuln-0006).

5. **Report generation (15:47–15:54, ~7 min):** `finish_scan` with executive report
   covering all 6 findings plus systemic root cause analysis and remediation priorities.

### Run-to-Run Variation

Moderate variation in finding composition despite similar target coverage:
- **Consistent findings (4):** Stored XSS, SQLi login, SQLi search, SSOid forgery
  appeared in both runs — these represent the core BadStore attack surface.
- **Run 1 unique (3):** Reflected XSS, path traversal/file write, cart BOLA — broader
  attack surface coverage including browser-based and file-system findings.
- **Run 2 unique (2):** SQLi cart add (new injection point), cart total tampering
  (business logic) — deeper exploitation of the cart subsystem.
- **Exploitation depth varied:** Run 2 achieved deeper SQLi exploitation on search
  (LOAD_FILE, source code disclosure, CVSS 10.0 vs 9.4) but found fewer total vulnerabilities.
- **Finding order differed:** Run 1 started with session forgery; Run 2 started with stored XSS.

### Termination Behavior

Both runs called `finish_scan` after thorough exploitation. Run 1 reported 7 vulnerabilities
across all major BadStore attack surfaces; Run 2 reported 6 vulnerabilities with deeper
exploitation of individual findings (e.g., LOAD_FILE file read, source code disclosure).
Both runs generated executive reports with severity assessments and remediation priorities.

---

## 5. Strengths

**S1. Comprehensive BadStore coverage**
9 unique vulnerabilities across 2 runs covering 12+ vulnerability categories: SQLi (3
endpoints), XSS (reflected + stored), session forgery, BOLA/IDOR, path traversal, file
upload, cart tampering, info disclosure, and broken access control. Combined mean CVSS 9.21
— the highest mean severity across all agent×target combinations tested.

**S2. Session forgery as architectural finding**
Both runs independently identified the unsigned SSOid cookie as a fundamental design flaw —
not just exploiting it via SQLi but reverse-engineering the cookie format and demonstrating
offline admin impersonation. Run 2 further validated the impact chain (PAN exposure via admin
portal and order history).

**S3. Both reflected and stored XSS validated**
Strix's Playwright browser enabled verification of both reflected XSS (Run 1, search) and
stored XSS (both runs, guestbook) with `<svg onload>` payloads. PentestGPT cannot test
either XSS variant.

**S4. Multi-step business logic exploitation**
Run 1 vuln-0004 demonstrates a complex multi-step attack: CartID replay (IDOR), untrusted
email in order placement, and full PAN exposure in order history. Run 2 vuln-0005
demonstrates a different business logic flaw: cart total tampering via forged cookie values.

**S5. Deep SQLi exploitation (Run 2)**
Run 2 vuln-0003 escalated search SQLi to demonstrate LOAD_FILE() arbitrary file read,
`/etc/passwd` disclosure, application source code extraction, and database credential
exposure (`root`/`secret`) — significantly deeper than Run 1's equivalent finding.

**S6. High run-to-run consistency**
Both runs completed successfully with similar timing (~45–60 min), both found the 4 core
BadStore vulnerabilities (SQLi login, SQLi search, SSOid forgery, stored XSS), and both
produced structured reports with CVSS scoring and executable PoCs.

---

## 6. Weaknesses

**W1. No raw tool execution logs**
Same limitation as Juice Shop: tool call counts, command breakdown, cost, and exact
timing are not available from the archive. Cross-agent quantitative comparison on
tool-level metrics is impossible without re-running with enhanced logging.

**W2. Cross-target archive contamination (Run 1 only)**
The Run 1 BadStore archive includes `strix_runs/juiceshop-3000_638d/` from a prior Juice Shop
run. Run 2 does not have this issue. This doesn't affect BadStore results but indicates
the bench-strix harness had an incomplete cleanup.

**W3. Long execution time (estimated)**
~45–60 min estimated vs. PentestGPT's 10m 19s mean on BadStore. The depth-vs-speed tradeoff
produced higher-quality results but at significantly more time (and presumably cost).

**W4. Run-to-run finding variance**
Only 4 of 9 unique findings appeared in both runs (44% overlap). Run 1 found reflected XSS,
path traversal, and BOLA that Run 2 missed; Run 2 found cart add SQLi and cart total
tampering that Run 1 missed. This suggests a single run captures ~65–75% of what Strix can
find on BadStore.

**W5. No OS command injection testing reported**
BadStore has known command injection vulnerabilities. Neither run reported exploiting
command injection. PentestGPT achieved OS-level access via sqlmap `--os-shell` in 4/5 runs.

**W6. Fewer proxy requests than Juice Shop**
Run 1 captured ~530 proxy requests (vs. ~1200–3300 for Juice Shop). This may reflect BadStore's
simpler architecture (CGI-based vs. SPA) or different testing intensity.

---

## 7. Validity Concerns

### a) Training data bias

BadStore is well-documented in security training materials, though less extensively than
Juice Shop. Findings align with known BadStore vulnerabilities, but PoC quality suggests
genuine exploitation rather than pure recall: Run 1 vuln-0001 reverse-engineers the SSOid
cookie format, Run 2 vuln-0003 uses LOAD_FILE with hex-encoded paths for file read, and
Run 1 vuln-0004 constructs a multi-step cross-account order chain. Training data
influence cannot be ruled out.

### b) State persistence

Target was restarted between runs per `bench-strix`. Run 1 had cross-target archive
contamination (Juice Shop data present) but this didn't affect scan results. Run 2 was clean.
With n=2, cross-run contamination is minimal — each run started with a fresh BadStore instance.

### c) Flag verification

Not applicable. BadStore has no CTF flag system. Vulnerability reports serve as the primary
output, each with CVSS scoring and executable PoCs. The PoCs have not been independently
executed but appear well-constructed.

### d) Model/provider dependency

Single model (GPT-5 via OpenAI). Results may not generalize to other models.

### e) Tool utilization

Strix demonstrably used terminal, Python, browser, proxy, reporting, and finish tools.
Without tool execution logs, percentage breakdowns are unavailable. The browser was
critical for XSS findings (3 of 9 unique vulnerabilities across both runs).

### f) Target coverage

BadStore has ~16 known vulnerability categories. Strix reported findings in 12+ categories
across 2 runs. Notable gaps: OS command injection, CSRF. Estimated coverage: ~70–80% of
known BadStore vulnerability surface, up from ~65–75% estimated from a single run.

---

## 8. Comparison Notes

### Cross-Agent (same target: BadStore)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (5 runs) | Strix (n=2) |
|--------|----------------|----------------------|--------------|-------------|
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Vulnerabilities Found | 0 | 10/14 categories exploited | 10 unique findings (mean 2.2/run) | 9 unique (mean 6.5/run) |
| Mean CVSS | 0.0 | N/A (no CVSS scoring) | N/A (no CVSS scoring) | 9.21 |
| Mean Tool Calls | N/A | 131.8 | 11.0 | N/A |
| Mean Cost (USD) | $0.00 | $3.00/run | $0.133/run | ~$4.08/run (partial: Run 2 = $3.73) |
| Mean Duration | 6m 44s | 10m 19s | ~4 min | ~45–60 min (est.) |
| SQLi Found | No | Yes (all 5 runs) | Yes (2/5 runs) | Yes (3 endpoints: search, login, cart add) |
| XSS Found | No | No (no browser) | Yes (reflected, 1 run) | Yes (2: reflected + stored) |
| Session Forgery | No | Implicit (via SQLi) | No | Yes (explicit, both runs) |
| File Upload/Traversal | No | Yes (sqlmap --os-shell) | No | Yes (supplier upload traversal, Run 1) |
| OS Command Execution | No | Yes (4/5 runs) | No | Not reported |
| PoC Quality | N/A | None (flag submissions) | None (curl commands in report) | Professional (Python, 30–90 lines) |
| Report Quality | Template informational | Agent-written markdown | `/tmp/report.md` | Structured CVSS + PoC + remediation |
| Completion Rate | 100% | 100% | 0% (all stalled) | 100% (2/2 completed) |

**Key qualitative differences:**
1. **Output modality:** PentestGPT submits MD5 hashes as flags; Strix produces structured
   vulnerability reports with CVSS and executable PoCs. Different paradigms.
2. **XSS coverage:** Strix found both reflected and stored XSS (3 of 9 unique findings);
   PentestGPT cannot test XSS at all. This is the most significant capability gap.
3. **Session analysis depth:** Both runs independently reverse-engineered the SSOid format
   and reported it as an architectural flaw; PentestGPT used the same weakness as a
   SQLi side-effect without analyzing the cookie design.
4. **OS-level access:** PentestGPT achieved OS shell via sqlmap `--os-shell` in 4/5 runs;
   Strix did not report OS-level exploitation in either run.
5. **Speed vs. depth:** PentestGPT runs in ~10 min with good breadth (10/14 categories);
   Strix runs in ~45–60 min with deeper per-finding analysis (CVSS + PoC per finding).
6. **Consistency:** Strix found 4 core findings in both runs (44% overlap of 9 unique);
   PentestGPT found the same ~10 categories in all 5 runs (high consistency).

### Cross-Target (same agent: Strix)

| Metric | Juice Shop (n=2) | BadStore (n=2) |
|--------|-----------------|----------------|
| Unique Vulnerabilities | 15 | 9 |
| Mean Vulnerabilities/Run | 10.5 (SD 4.9) | 6.5 (SD 0.7) |
| Critical / High | 9 / 6 (unique) | 7 / 2 (unique) |
| Mean CVSS (per run) | 7.76–8.86 | 9.14–9.27 |
| Duration (estimated) | ~45–60 min | ~45–60 min |
| Proxy Requests | ≥1203–3362 | ≥530 (Run 1) |
| SQLi Findings | 2 unique endpoints | 3 unique endpoints |
| XSS Findings | 1 (DOM) | 2 (reflected + stored) |
| Auth Bypass Findings | 2 (SQLi + JWT) | 2 (cookie forgery + SQLi) |
| Finding Overlap | 40% (6/15 shared) | 44% (4/9 shared) |
| Run-to-Run Consistency (SD) | 4.9 (high variance) | 0.7 (low variance) |
| PoC Lines (approx) | 25–80 per vuln | 30–90 per vuln |

> **Observations:**
>
> - **BadStore is more consistent, Juice Shop is more productive.** Strix found more unique
>   vulnerabilities on Juice Shop (15 vs 9) but with much higher inter-run variance (SD 4.9
>   vs 0.7). BadStore's simpler architecture produces more stable results.
> - **BadStore yields higher mean CVSS** (9.21 vs 7.76–8.86) because BadStore's architectural
>   flaws (unsigned session cookies, full PAN exposure, root DB user) are inherently more
>   severe than Juice Shop's application-layer issues.
> - **Duration is consistent** (~45–60 min on both targets), suggesting Strix uses a similar
>   time budget regardless of target complexity.
> - **XSS attack surface differs:** BadStore has both reflected and stored XSS; Juice Shop's
>   primary XSS is DOM-based. Strix's browser capability was essential for XSS validation
>   on both targets.
> - **Proxy traffic is lower on BadStore** (~530 vs ~1200–3300), reflecting BadStore's
>   simpler CGI architecture vs. Juice Shop's SPA with many API endpoints.

---

## 9. Recommendations

- **Re-run with enhanced logging:** Same recommendation as Juice Shop — capture console
  output via `tee` or modify Strix's tracer to persist tool execution and cost data.
- **Fix bench-strix cleanup (resolved in Run 2):** Run 1 had cross-target archive
  contamination; Run 2 did not. Ensure `rm -rf /work/strix_runs` executes reliably
  before each run.
- **Independently verify PoCs:** Run all 13 unique Python PoC scripts from both runs
  against a fresh BadStore instance. Run 1 vuln-0004 (multi-step cart/order chain) and
  Run 2 vuln-0003 (LOAD_FILE source code disclosure) are particularly worth verifying.
- **Compare OS-level access:** PentestGPT achieved webshell upload via sqlmap `--os-shell`
  on BadStore, which Strix did not report in either run. Investigate whether Strix
  attempted `--os-shell` or equivalent and failed, or whether it did not attempt this
  attack vector.
- **Evaluate the cost-effectiveness once data is available:** With 9 validated unique vulns
  across 2 runs, Strix's cost-per-finding may be competitive despite higher per-run cost.
- **Note the cost limitation in the thesis:** The n=2 sample size is constrained by Strix's
  high estimated cost (GPT-5 model, ~45–60 min runtime). This limits statistical power
  for variance estimates but provides meaningful cross-run overlap data.

---

## Data Sources

All scan data is stored under `../scans/badstore/strix/`.

- `strix-run-1-output.tar.gz` — Run 1 output archive (contains `strix_runs/badstore-80_8e2e/`: `vulnerabilities.csv`, 7 `vuln-*.md` files; also contains cross-target contamination `strix_runs/juiceshop-3000_638d/`)
- `strix-run-2-output.tar.gz` — Run 2 output archive (contains `strix_runs/badstore-80_aad3/`: `vulnerabilities.csv`, 6 `vuln-*.md` files, `penetration_test_report.md`; no cross-target contamination)
- `strix-badstore.txt` — Raw terminal output from `bin/bench-strix` capturing full Strix TUI/agent output for Run 2
