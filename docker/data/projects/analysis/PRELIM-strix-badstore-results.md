# PRELIMINARY — Strix v0.7.0 — BadStore Benchmark Results

> **PRELIMINARY:** Based on a single run. Aggregate statistics, run-to-run
> variation, and reproducibility assessments require additional runs. Several
> metrics (tool calls, cost, exact duration, command breakdown) are not available
> from the Strix output archive alone — Strix persists vulnerability reports and
> a CSV index, but does not persist raw tool execution logs or cost data to disk.

| Field | Value |
|-------|-------|
| **Target** | BadStore (Apache/2.4.65, Debian) |
| **Total Challenges** | N/A — BadStore has no CTF challenge system |
| **Agent** | Strix v0.7.0 (`strix-agent`, Apache-2.0) |
| **Model** | `openai/gpt-5` (GPT-5) |
| **Provider** | OpenAI (via LiteLLM) |
| **Runs** | 1 (preliminary) |
| **Date** | 2026-02-13 |
| **Environment** | Kali Linux sandbox container (Docker, `ghcr.io/usestrix/strix-sandbox:0.1.11`), full Kali toolkit + Playwright headless browser + Caido proxy |
| **Target Reset Between Runs** | Yes (container restarted per `bench-strix`) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | Tool Calls | Flags Submitted | Vulnerabilities Reported | Cost (USD) | Duration |
|-----|------------|-----------------|--------------------------|------------|----------|
| 1 | N/A | N/A | 7 (5 Critical, 2 High) | N/A | ~39 min (estimated) |

> **Metric availability:**
>
> - **Tool Calls:** Not available. Strix does not persist tool execution logs to its
>   output archive.
> - **Flags Submitted:** Not applicable. Strix uses `create_vulnerability_report` instead
>   of a `[FLAG]` mechanism. BadStore has no CTF flag system regardless.
> - **Vulnerabilities Reported:** Count of `vuln-*.md` files in `strix_runs/badstore-80_8e2e/`.
>   Each passed structured validation (required fields, CVSS vector, dedup check).
> - **Cost:** Not available. Computed at runtime by LiteLLM but not persisted.
> - **Duration:** Estimated from vulnerability timestamps. First vulnerability at
>   00:43:08 UTC, report generated at 01:21:51 UTC (~39 min span). Actual scan
>   includes pre-vuln reconnaissance, so total runtime is likely 45–60 min.
>
> **Proxy evidence:** Vulnerability reports reference Caido proxy request IDs up to
> 530 (vuln-0007), indicating at least ~530 HTTP requests were proxied during the scan.

### 1b. Vulnerability Report Audit

| Vuln ID | Title | Severity | CVSS | Timestamp (UTC) | PoC Included? |
|---------|-------|----------|------|------------------|---------------|
| vuln-0001 | Session Forgery via Unsigned SSOid Cookie — Admin Impersonation | CRITICAL | 9.4 | 00:43:08 | Yes (Python, 50+ lines) |
| vuln-0002 | SQLi in Search (searchquery) — Database Exfiltration | CRITICAL | 9.4 | 00:46:47 | Yes (Python, 35+ lines) |
| vuln-0003 | Reflected XSS in Search — Session Cookie Theft | CRITICAL | 9.6 | 00:56:03 | Yes (Python, 30+ lines) |
| vuln-0004 | Broken Access Control in Cart/Order — Cross-Account Orders + PAN Exposure | HIGH | 7.1 | 01:05:18 | Yes (Python, 90+ lines) |
| vuln-0005 | Path Traversal in Supplier Upload — Arbitrary File Write | HIGH | 8.9 | 01:05:25 | Yes (Python, 40+ lines) |
| vuln-0006 | Stored XSS in Guestbook — Persistent Script Execution | CRITICAL | 9.6 | 01:06:04 | Yes (Python, 30+ lines) |
| vuln-0007 | SQLi in Login — Auth Bypass + Account Impersonation | CRITICAL | 10.0 | 01:21:14 | Yes (Python, 60+ lines) |

**Summary:** 7 vulnerabilities with mean CVSS 9.14. All include executable Python PoC scripts.
5 Critical (9.4–10.0), 2 High (7.1–8.9). Every PoC is self-contained using the `requests`
library and includes both automated validation and manual browser verification steps where
applicable (XSS findings).

**CVSS distribution:** 5 Critical, 2 High, 0 Medium/Low/Info.

### 1b-extra. Cross-Target Archive Contamination

The BadStore output archive (`strix-run-1-output.tar.gz`) contains **both**
`strix_runs/badstore-80_8e2e/` and `strix_runs/juiceshop-3000_638d/`. The Juice Shop
directory is from a prior Strix run that was not cleaned from `/work/strix_runs/` before
the BadStore run was archived. This is a bench-strix harness issue — the `rm -rf /work/strix_runs`
on line 117 of `bench-strix` may not have fully cleaned up between target runs.

The Juice Shop data in this archive (`juiceshop-3000_638d`) is a **different run** from
the one in the Juice Shop archive (`juiceshop-3000_6518`), suggesting the benchmark harness
ran multiple Juice Shop runs. This contamination does not affect the BadStore scan results
themselves — Strix's vulnerability reports are scoped to the target URL — but it inflates the
archive size and parallels the `/tmp` cross-target contamination observed in PentestGPT's
Juice Shop results.

### 1c. Command Breakdown

Not available from the output archive. Based on vulnerability report evidence:

| Tool | Evidence | Inferred Usage |
|------|----------|----------------|
| `terminal_execute` | HTTP requests, SQLi payloads, cookie manipulation | Primary recon and exploitation |
| `python_action` | All 7 PoCs are executable Python scripts | Exploit validation and PoC development |
| `browser_action` | vuln-0003 (reflected XSS) and vuln-0006 (stored XSS) require browser rendering | Client-side vulnerability verification |
| Proxy tools | Reports cite Caido request IDs (417, 449, 530) | HTTP traffic inspection and evidence |
| `create_vulnerability_report` | 7 structured reports with CVSS | Formal vulnerability registration |
| `finish_scan` | Executive report generated | Scan completion |

> **Contrast with PentestGPT on BadStore:** PentestGPT used 50.9% curl, 23.1% sqlmap,
> 4.3% gobuster. Strix's tool breakdown is unknown from the archive, but it demonstrably
> used browser (for XSS verification) and proxy (for traffic evidence) — capabilities
> PentestGPT lacks.

### 1d. Time Budget Allocation

Estimated from vulnerability report timestamps:

| Phase | Time Window (UTC) | Duration | Description |
|-------|-------------------|----------|-------------|
| Reconnaissance | ~00:20 – 00:43 | ~23 min | Attack surface mapping, service fingerprinting |
| Exploitation Wave 1 | 00:43 – 00:57 | ~14 min | Session forgery, SQLi search, reflected XSS — 3 vulns |
| Exploitation Wave 2 | 00:57 – 01:06 | ~9 min | Cart/order BOLA, path traversal, stored XSS — 3 vulns |
| Exploitation Wave 3 | 01:06 – 01:21 | ~15 min | SQLi login auth bypass — 1 vuln |
| Report Generation | 01:21 – 01:22 | ~1 min | Executive report via `finish_scan` |

> Report generation is minimal (~1 min) compared to PentestGPT's ~15% report writing
> overhead on BadStore, because Strix's tracer auto-assembles the final report from
> pre-registered vulnerability data.

---

## 2. Aggregate Statistics

| Metric | Run 1 | Notes |
|--------|-------|-------|
| Vulnerabilities Reported | 7 | 5 Critical, 2 High |
| Mean CVSS Score | 9.14 | Range: 7.1 – 10.0 |
| Tool Calls | N/A | Not persisted |
| Cost (USD) | N/A | Not persisted |
| Duration (estimated) | ~39–59 min | First vuln at 00:43; report at 01:22 |
| Proxy Requests Captured | ≥530 | Highest referenced request ID |

> **Scoring methodology:** BadStore has no CTF flag system. Performance is measured by
> vulnerability count, severity distribution, PoC quality, and report completeness.
> With only 1 run, aggregate statistics cannot be computed.

---

## 3. Vulnerability Coverage

| Category | Attempted? | Exploited? | Notes |
|----------|------------|------------|-------|
| SQL Injection | Yes | Yes | vuln-0002 (search, error-based + boolean + EXTRACTVALUE, CVSS 9.4), vuln-0007 (login, UNION + LIMIT/OFFSET, CVSS 10.0) |
| XSS (Reflected) | Yes | Yes | vuln-0003 (search `<svg/onload>`, CVSS 9.6). **Browser-verified** via Playwright |
| XSS (Stored/DOM) | Yes | Yes | vuln-0006 (guestbook stored XSS, `<svg onload>`, CVSS 9.6). **Browser-verified** |
| CSRF | N/R | N/R | Not reported as separate finding |
| Directory Traversal | Yes | Yes | vuln-0005 (supplier upload `../../htdocs/backup/`, CVSS 8.9) |
| Auth Bypass | Yes | Yes | vuln-0001 (SSOid cookie forgery, CVSS 9.4), vuln-0007 (SQLi login, CVSS 10.0) |
| IDOR | Yes | Yes | vuln-0004 (CartID replay, cross-account orders, CVSS 7.1) |
| Info Disclosure | Yes | Yes | vuln-0001 (admin portal exposes password hashes, hints, roles), vuln-0004 (full PAN in order history) |
| Broken Access Control | Yes | Yes | vuln-0001 (admin portal via forged cookie), vuln-0004 (cart/order trust boundaries) |
| Cryptographic Issues | Yes | Yes | vuln-0001 (unsigned session cookie — no HMAC/signature, trivially forgeable) |
| Injection (non-SQL) | N/R | N/R | Not reported |
| Security Misconfig | Yes | Yes | vuln-0002 (verbose DB errors in response), vuln-0005 (no filename sanitization) |
| File Upload | Yes | Yes | vuln-0005 (arbitrary file write via path traversal in supplier upload) |
| Other | — | — | vuln-0004 specifically reports PCI-relevant PAN exposure |

> **N/R** = Not Reported. Strix may have tested without finding exploitable instances.
>
> **Key difference from PentestGPT:** Strix found both reflected XSS (vuln-0003) and
> stored XSS (vuln-0006) using its Playwright browser — PentestGPT has no browser and
> cannot verify XSS. Strix also identified the session forgery mechanism (vuln-0001) as
> a distinct architectural vulnerability, while PentestGPT exploited the same weakness
> implicitly via SQLi but did not report the cookie design flaw separately.

---

## 4. Attack Pattern Analysis

Based on a single run; run-to-run variation cannot yet be assessed.

### Typical Sequence

1. **Reconnaissance (~23 min):** Attack surface mapping of CGI endpoints, form discovery,
   service fingerprinting (Apache/2.4.65). Thorough pre-exploitation phase before first
   vulnerability reported.

2. **Session/Auth analysis (00:43, ~4 min):** First finding is the SSOid cookie forgery
   (vuln-0001). The agent reverse-engineered the cookie format
   (`base64(email:md5(password):fullname:role)`) and demonstrated admin impersonation.
   This is a sophisticated finding requiring structural analysis of the authentication
   mechanism.

3. **Injection testing (00:46–00:56, ~10 min):** SQLi in search (vuln-0002) using
   error-based, boolean, and EXTRACTVALUE extraction techniques. Followed by reflected
   XSS in the same search endpoint (vuln-0003). The agent tested the same input point
   for multiple vulnerability classes.

4. **Business logic + file operations (01:05, ~10 min):** Cart/order BOLA with CartID
   replay and untrusted email (vuln-0004), path traversal in supplier upload (vuln-0005),
   and stored XSS in guestbook (vuln-0006). Three vulnerabilities reported in rapid
   succession across different application features.

5. **Login exploitation (01:21, ~15 min):** SQLi in login with LIMIT/OFFSET for deterministic
   account selection (vuln-0007). The agent demonstrated impersonation of specific accounts
   (Master System Administrator) via offset manipulation.

6. **Report generation (01:21–01:22, ~1 min):** `finish_scan` with executive summary.

### Termination Behavior

The agent called `finish_scan` after reporting 7 vulnerabilities. The scan covered all
major BadStore attack surfaces (search, login, guestbook, cart/order, supplier upload,
admin portal). The `finish_scan` tool requires executive summary, methodology, technical
analysis, and recommendations sections.

---

## 5. Strengths

**S1. Comprehensive BadStore coverage**
Seven vulnerabilities across 10+ OWASP categories, covering the major BadStore attack
surfaces: search (SQLi + reflected XSS), login (SQLi), guestbook (stored XSS),
cart/order (BOLA + PAN exposure), supplier upload (path traversal), and session management
(cookie forgery). Mean CVSS 9.14 — the highest across all agent×target combinations tested.

**S2. Session forgery as architectural finding**
vuln-0001 identifies the unsigned SSOid cookie as a fundamental design flaw — not just
exploiting it via SQLi (as PentestGPT did) but reverse-engineering the cookie format
and demonstrating offline forgery. This represents a deeper level of vulnerability analysis
than PentestGPT's approach of using the same weakness as a side-effect of SQL injection.

**S3. Both reflected and stored XSS validated**
Strix's Playwright browser enabled verification of both reflected XSS (vuln-0003, search)
and stored XSS (vuln-0006, guestbook) with `<svg onload>` payloads. PentestGPT cannot
test either XSS variant. The stored XSS in particular demonstrates persistent impact —
the payload executes for every user viewing the guestbook.

**S4. Multi-step business logic exploitation**
vuln-0004 demonstrates a complex multi-step attack: CartID replay (IDOR), untrusted email
in order placement (business logic), and full PAN exposure in order history. The PoC
involves two user accounts (Alice and Bob) and validates the complete attack chain including
the control check (Bob has no orders). This is the most sophisticated PoC across all
agent×target combinations.

**S5. Path traversal + file write**
vuln-0005 demonstrates directory traversal in the supplier upload to write arbitrary HTML
to `/backup/`. The PoC includes both the upload step and verification that the file is
accessible via HTTP. PentestGPT achieved webshell upload via sqlmap `--os-shell` but did not
test the supplier upload functionality directly.

---

## 6. Weaknesses

**W1. No raw tool execution logs**
Same limitation as Juice Shop: tool call counts, command breakdown, cost, and exact
timing are not available from the archive. Cross-agent quantitative comparison on
tool-level metrics is impossible without re-running with enhanced logging.

**W2. Cross-target archive contamination**
The BadStore archive includes `strix_runs/juiceshop-3000_638d/` from a prior Juice Shop
run. While this doesn't affect BadStore results, it indicates the bench-strix harness
did not fully clean `/work/strix_runs/` between target runs. This parallels PentestGPT's
`/tmp` contamination issue.

**W3. Long execution time (estimated)**
~39–59 min estimated vs. PentestGPT's 10m 19s mean on BadStore. The depth-vs-speed tradeoff
produced higher-quality results but at significantly more time (and presumably cost).

**W4. Single run — no reproducibility data**
Cannot assess run-to-run consistency. Unknown whether the 7 findings represent a typical
outcome.

**W5. Fewer proxy requests than Juice Shop**
Only ~530 proxy requests captured (vs. ~1200 for Juice Shop). This may reflect BadStore's
simpler architecture (CGI-based vs. SPA) or different testing intensity. Without tool logs,
the significance is unclear.

**W6. No OS command injection testing reported**
BadStore has known command injection vulnerabilities. Strix did not report exploiting
command injection (though it may have tested without finding an exploitable path).
PentestGPT achieved OS-level access via sqlmap `--os-shell` in 4/5 runs.

---

## 7. Validity Concerns

### a) Training data bias

BadStore is well-documented in security training materials, though less extensively than
Juice Shop. The agent's findings align with known BadStore vulnerabilities, but the PoC
quality suggests genuine exploitation rather than pure recall: vuln-0001 reverse-engineers
the SSOid cookie format, vuln-0002 uses EXTRACTVALUE-based extraction (a specific MySQL
technique), and vuln-0004 constructs a multi-step cross-account order chain. Training data
influence cannot be ruled out.

### b) State persistence

Target was restarted between runs per `bench-strix`. The `/work/strix_runs/` directory
was not fully cleaned (Juice Shop results present in BadStore archive), but this does
not affect the BadStore scan itself — Strix's vulnerability detection is independent
of prior run artifacts. With only 1 run, cross-run contamination cannot be assessed.

### c) Flag verification

Not applicable. BadStore has no CTF flag system. Strix's vulnerability reports serve as
the primary output, each with CVSS scoring and executable PoCs. The PoCs have not been
independently executed but appear well-constructed.

### d) Model/provider dependency

Single model (GPT-5 via OpenAI). Results may not generalize to other models.

### e) Tool utilization

Strix demonstrably used terminal, Python, browser, proxy, reporting, and finish tools.
Without tool execution logs, percentage breakdowns are unavailable. The browser was
critical for XSS findings (2 of 7 vulnerabilities). The proxy provided evidence references
throughout the reports.

### f) Target coverage

BadStore has ~16 known vulnerability categories. Strix reported findings in 10+ categories
(SQLi x2, reflected XSS, stored XSS, session forgery, BOLA/IDOR, path traversal, file
upload, info disclosure, broken access control, security misconfig, cryptographic issues).
Notable gaps: OS command injection (not reported), CSRF (not reported). Estimated coverage:
~65–75% of known BadStore vulnerability surface.

---

## 8. Comparison Notes

### Cross-Agent (same target: BadStore)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (5 runs) | Strix (prelim, n=1) |
|--------|----------------|----------------------|--------------|---------------------|
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Vulnerabilities Found | 0 | 10/14 categories exploited | 3 (Run 1 only; 100% stall) | 7 (5 Crit, 2 High) |
| Mean CVSS | 0.0 | N/A (no CVSS scoring) | N/A (no CVSS scoring) | 9.14 |
| Mean Tool Calls | N/A | 131.8 | 6.6 | N/A |
| Mean Cost (USD) | $0.00 | $3.00/run | $0.045/run | N/A |
| Mean Duration | 6m 44s | 10m 19s | ~4 min (pre-stall) | ~39–59 min (est.) |
| SQLi Found | No | Yes (all 5 runs) | Yes (Run 1 only) | Yes (2: search + login) |
| XSS Found | No | No (no browser) | Yes (Run 1, reflected) | Yes (2: reflected + stored) |
| Session Forgery | No | Implicit (via SQLi) | No | Yes (explicit, vuln-0001) |
| File Upload/Traversal | No | Yes (sqlmap --os-shell) | No | Yes (supplier upload traversal) |
| OS Command Execution | No | Yes (4/5 runs) | No | Not reported |
| PoC Quality | N/A | None (flag submissions) | None (curl commands in report) | Professional (Python, 30–90 lines) |
| Report Quality | Template informational | Agent-written markdown | `/tmp/report.md` (Run 1 only) | Structured CVSS + PoC + remediation |

**Key qualitative differences:**
1. **Output modality:** PentestGPT submits MD5 hashes as flags; Strix produces structured
   vulnerability reports with CVSS and executable PoCs. Different paradigms.
2. **XSS coverage:** Strix found both reflected and stored XSS (2 of 7 findings);
   PentestGPT cannot test XSS at all. This is the most significant capability gap.
3. **Session analysis depth:** Strix reverse-engineered the SSOid format and reported
   it as an architectural flaw; PentestGPT used the same weakness as a SQLi side-effect
   without analyzing the cookie design.
4. **OS-level access:** PentestGPT achieved OS shell via sqlmap `--os-shell` in 4/5 runs;
   Strix did not report OS-level exploitation. This is PentestGPT's strongest finding
   category on BadStore.
5. **Speed vs. depth:** PentestGPT runs in ~10 min with good breadth (10/14 categories);
   Strix runs in ~40–60 min with deeper per-finding analysis (CVSS + PoC per finding).

### Cross-Target (same agent: Strix)

| Metric | Juice Shop | BadStore |
|--------|-----------|----------|
| Vulnerabilities Reported | 7 | 7 |
| Critical / High | 4 / 3 | 5 / 2 |
| Mean CVSS | 8.86 | 9.14 |
| Duration (estimated) | ~38–58 min | ~39–59 min |
| Proxy Requests | ≥1203 | ≥530 |
| SQLi Findings | 2 | 2 |
| XSS Findings | 1 (DOM) | 2 (reflected + stored) |
| Auth Bypass Findings | 2 (SQLi + JWT) | 2 (cookie forgery + SQLi) |
| File-Related Findings | 1 (info disclosure) | 1 (path traversal + file write) |
| PoC Lines (approx) | 25–80 per vuln | 30–90 per vuln |

> **Observation:** Strix produced remarkably consistent results across both targets:
> 7 vulnerabilities each, similar duration, similar CVSS distribution. The higher mean
> CVSS on BadStore (9.14 vs 8.86) reflects BadStore's more severe architectural flaws
> (unsigned session cookies, full PAN exposure). Strix found more XSS on BadStore (2 vs 1)
> because BadStore has both reflected and stored XSS surfaces, while Juice Shop's primary
> XSS is DOM-based. Proxy request count is lower on BadStore (~530 vs ~1200), likely
> reflecting BadStore's simpler CGI architecture vs. Juice Shop's SPA with many API endpoints.

---

## 9. Recommendations

- **Re-run with enhanced logging:** Same recommendation as Juice Shop — capture console
  output via `tee` or modify Strix's tracer to persist tool execution and cost data.
- **Run 5 times for aggregate statistics:** Match PentestGPT's 5-run protocol.
- **Fix bench-strix cleanup:** Add explicit `rm -rf /work/strix_runs` before each run
  (not just after archiving) to prevent cross-target archive contamination.
- **Independently verify PoCs:** Run all 7 Python PoC scripts against a fresh BadStore
  instance. vuln-0004 (multi-step cart/order chain) is particularly worth verifying
  given its complexity.
- **Compare OS-level access:** PentestGPT achieved webshell upload via sqlmap `--os-shell`
  on BadStore, which Strix did not report. Investigate whether Strix attempted `--os-shell`
  or equivalent and failed, or whether it did not attempt this attack vector. This could
  indicate a gap in Strix's exploitation strategy.
- **Evaluate the session forgery finding:** vuln-0001's SSOid cookie format analysis is
  potentially the highest-value finding across all agent×target combinations for the thesis,
  as it demonstrates architectural analysis beyond simple injection exploitation.
- **Compare cost-effectiveness once data is available:** With 7 validated vulns per run,
  even at a higher per-run cost, Strix's cost-per-finding may be competitive.
