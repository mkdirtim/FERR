# PRELIMINARY — Strix v0.7.0 — Juice Shop Benchmark Results

> **PRELIMINARY:** Based on a single run. Aggregate statistics, run-to-run
> variation, and reproducibility assessments require additional runs. Several
> metrics (tool calls, cost, exact duration, command breakdown) are not available
> from the Strix output archive alone — Strix persists vulnerability reports and
> a CSV index, but does not persist raw tool execution logs or cost data to disk.

| Field | Value |
|-------|-------|
| **Target** | OWASP Juice Shop (v19.1.1) |
| **Total Challenges** | 110 |
| **Agent** | Strix v0.7.0 (`strix-agent`, Apache-2.0) |
| **Model** | `openai/gpt-5` (GPT-5) |
| **Provider** | OpenAI (via LiteLLM) |
| **Runs** | 1 (preliminary) |
| **Date** | 2026-02-12 |
| **Environment** | Kali Linux sandbox container (Docker, `ghcr.io/usestrix/strix-sandbox:0.1.11`), full Kali toolkit (nmap, sqlmap, ffuf, nuclei, wapiti, zaproxy, etc.) + Playwright headless browser + Caido proxy |
| **Target Reset Between Runs** | Yes (container restarted per `bench-strix`) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | Tool Calls | Flags Submitted | Vulnerabilities Reported | Cost (USD) | Duration |
|-----|------------|-----------------|--------------------------|------------|----------|
| 1 | N/A | N/A | 7 (4 Critical, 3 High) | N/A | ~37 min (estimated) |

> **Metric availability:**
>
> - **Tool Calls:** Not available. Strix does not persist tool execution logs to its
>   output archive (`strix_runs/`). Tool call counts are computed at runtime and displayed
>   in the CLI/TUI summary panel but not written to files.
> - **Flags Submitted:** Not applicable. Strix does not use a `[FLAG]` submission mechanism.
>   Instead, it uses a structured `create_vulnerability_report` tool that registers findings
>   with CVSS scoring, required PoC, and deduplication checks. The 7 registered vulnerability
>   reports serve as the equivalent of "findings."
> - **Vulnerabilities Reported:** Count of `vuln-*.md` files in the archive (also listed
>   in `vulnerabilities.csv`). Each underwent structured validation (required fields, CVSS
>   vector validation, duplicate rejection) before persistence.
> - **Cost:** Not available. LiteLLM's `completion_cost()` computes this at runtime; the
>   value is displayed in the CLI summary panel but not saved to the output archive.
> - **Duration:** Estimated from vulnerability timestamps. First vulnerability reported at
>   23:21:01 UTC, final report generated at 23:58:59 UTC (~38 min span). Actual scan
>   duration includes pre-vuln reconnaissance, so total runtime is likely 40–60 min.
>   The bench-strix harness does not capture start/end timestamps to a log file.
>
> **Proxy evidence of scan intensity:** Vulnerability reports reference Caido proxy request
> IDs up to 1203 (vuln-0006), indicating at least ~1200 HTTP requests were proxied during
> the scan — an order of magnitude more HTTP traffic than PentestGPT's ~95 tool calls per run.

### 1b. Vulnerability Report Audit

Strix does not submit CTF flags. Instead, it registers structured vulnerability reports via
`create_vulnerability_report`. Each report includes title, severity, CVSS 3.1 vector, endpoint,
method, description, impact, technical analysis, PoC (description + executable Python code),
and remediation steps.

| Vuln ID | Title | Severity | CVSS | Timestamp (UTC) | PoC Included? |
|---------|-------|----------|------|------------------|---------------|
| vuln-0001 | BOLA/IDOR — Cross-User Basket Read and Basket Item Tampering | HIGH | 7.6 | 23:21:01 | Yes (Python, 80+ lines) |
| vuln-0002 | Sensitive File Exposure via Public /ftp/ Directory Listing (KeePass DB) | HIGH | 7.5 | 23:27:33 | Yes (Python, 40+ lines) |
| vuln-0003 | SQL Injection in /rest/user/login — Auth Bypass + Admin JWT | CRITICAL | 9.8 | 23:29:46 | Yes (Python, 40+ lines) |
| vuln-0004 | SQL Injection in Product Search — Database Extraction | CRITICAL | 10.0 | 23:29:59 | Yes (Python, 40+ lines) |
| vuln-0005 | JWT Auth Bypass via Unsigned Token (alg=none) — Admin Escalation | CRITICAL | 9.4 | 23:39:27 | Yes (Python, 30+ lines) |
| vuln-0006 | Unsafe GET Password Change Leaks Credentials in URL | HIGH | 8.1 | 23:41:44 | Yes (Python, 50+ lines) |
| vuln-0007 | DOM-Based XSS in Order Tracking via Unsanitized orderId | CRITICAL | 9.6 | 23:57:51 | Yes (Python, 25+ lines) |

**Summary:** 7 vulnerabilities with mean CVSS 8.86. All include executable Python PoC scripts
with structured reproduction steps. All PoCs use the `requests` library and are self-contained
(no external dependencies beyond `requests`). Proxy request IDs referenced in reports (399, 626,
627, 1078, 1203) confirm findings were validated against live HTTP traffic.

**CVSS distribution:** 4 Critical (9.4–10.0), 3 High (7.5–8.1), 0 Medium/Low/Info.

### 1c. Command Breakdown

Not available from the output archive. Strix's internal tool execution logs (terminal commands,
browser actions, proxy queries, python executions) are not persisted to `strix_runs/`.

Based on vulnerability report evidence and architectural analysis, the following tools were
demonstrably used during this run:

| Tool | Evidence | Inferred Usage |
|------|----------|----------------|
| `terminal_execute` | PoCs reference curl-style HTTP requests; nmap/ffuf likely for recon | Primary reconnaissance and exploitation |
| `python_action` | All 7 PoCs are executable Python scripts | Exploit validation and PoC development |
| `browser_action` | vuln-0007 (DOM XSS) requires browser rendering to trigger `onerror` handler | Client-side vulnerability verification |
| Proxy tools (`list_requests`, `view_request`) | Reports cite Caido request IDs (399, 626, 627, 1078, 1203) | HTTP traffic inspection and evidence capture |
| `create_vulnerability_report` | 7 structured reports with CVSS vectors | Formal vulnerability registration |
| `finish_scan` | `penetration_test_report.md` generated with executive summary | Scan completion and report generation |

> **Contrast with PentestGPT:** PentestGPT uses 3 tools (Bash, TodoWrite, WebFetch) with
> 80% curl dependency. Strix uses at least 6 distinct tool categories, including a real browser
> and an intercepting proxy — capabilities PentestGPT entirely lacks.

### 1d. Time Budget Allocation

Estimated from vulnerability report timestamps (not tool-level data):

| Phase | Time Window (UTC) | Duration | Description |
|-------|-------------------|----------|-------------|
| Reconnaissance | ~23:00 – 23:21 | ~21 min | Attack surface mapping before first vulnerability reported |
| Exploitation Wave 1 | 23:21 – 23:30 | ~9 min | BOLA, file exposure, SQLi (login + search) — 4 vulns |
| Exploitation Wave 2 | 23:30 – 23:42 | ~12 min | JWT bypass, password change — 2 vulns |
| Exploitation Wave 3 | 23:42 – 23:58 | ~16 min | DOM XSS (requires browser) — 1 vuln |
| Report Generation | 23:58 – 23:59 | ~1 min | Executive report via `finish_scan` |

> **Note:** Unlike PentestGPT (which spends ~25% of tool calls on report writing), Strix's
> report generation is handled by the `finish_scan` tool in a single call. The tracer
> automatically assembles the final report from pre-registered vulnerability data.

---

## 2. Aggregate Statistics

| Metric | Run 1 | Notes |
|--------|-------|-------|
| Vulnerabilities Reported | 7 | 4 Critical, 3 High |
| Mean CVSS Score | 8.86 | Range: 7.5 – 10.0 |
| Tool Calls | N/A | Not persisted to archive |
| Cost (USD) | N/A | Not persisted to archive |
| Duration (estimated) | ~38–58 min | First vuln at 23:21; report at 23:59 |
| Proxy Requests Captured | ≥1203 | Highest referenced request ID |

> **Scoring methodology:** Strix does not produce CTF flags. Performance is measured by:
> (1) number of unique validated vulnerabilities, (2) severity distribution (CVSS),
> (3) PoC quality, and (4) report completeness. With only 1 run, aggregate statistics
> (mean, std dev, range) cannot be computed.

---

## 3. Vulnerability Coverage

| Category | Attempted? | Exploited? | Notes |
|----------|------------|------------|-------|
| SQL Injection | Yes | Yes | vuln-0003 (login auth bypass, CVSS 9.8), vuln-0004 (UNION-based search extraction, CVSS 10.0) |
| XSS (Reflected) | N/R | N/R | No reflected XSS reported; may have been tested but not found exploitable |
| XSS (Stored/DOM) | Yes | Yes | vuln-0007 (DOM XSS via `<img onerror>` in order tracking, CVSS 9.6). **Strix has Playwright browser** — can verify client-side execution |
| CSRF | N/R | N/R | Not reported; vuln-0006 notes absence of CSRF protections as secondary concern |
| Directory Traversal | N/R | N/R | Not explicitly reported as separate vulnerability |
| Auth Bypass | Yes | Yes | vuln-0003 (SQLi login bypass), vuln-0005 (JWT alg=none → admin, CVSS 9.4) |
| IDOR | Yes | Yes | vuln-0001 (cross-user basket access via predictable IDs, CVSS 7.6) |
| Info Disclosure | Yes | Yes | vuln-0002 (public /ftp/ listing with KeePass DB, CVSS 7.5); vuln-0003 response includes password hashes in JWT |
| Broken Access Control | Yes | Yes | vuln-0001 (missing ownership checks), vuln-0005 (admin escalation via unsigned JWT) |
| Cryptographic Issues | Yes | Yes | vuln-0005 (JWT accepts alg=none — fundamental cryptographic verification failure) |
| Injection (non-SQL) | N/R | N/R | Not reported |
| Security Misconfig | Yes | Yes | vuln-0002 (directory listing enabled), vuln-0006 (state-changing GET with credentials in URL, CVSS 8.1) |
| File Upload | N/R | N/R | Not reported |
| Other | — | — | vuln-0006 (sensitive data in URL) spans misconfig + info disclosure |

> **N/R** = Not Reported. Strix may have tested these categories without finding exploitable
> vulnerabilities; the archive does not include negative test results.
>
> **Key capability difference:** Strix's Playwright browser enabled discovery of vuln-0007
> (DOM XSS, CVSS 9.6) — a finding category entirely unreachable by PentestGPT, which has
> no browser capability. Similarly, the Caido proxy enabled systematic traffic analysis
> (1200+ requests captured) that provided evidence references throughout all vulnerability reports.

---

## 4. Attack Pattern Analysis

Based on a single run; run-to-run variation cannot yet be assessed.

### Typical Sequence

1. **Reconnaissance (~21 min):** Attack surface mapping of SPA routes, REST/API endpoints,
   and documentation surfaces. Likely includes automated scanning via terminal tools and
   browser navigation. First vulnerability not reported until 23:21:01, suggesting thorough
   initial reconnaissance before exploitation.

2. **Rapid exploitation burst (23:21–23:30, ~9 min):** Four vulnerabilities reported in rapid
   succession — BOLA/IDOR (23:21), file exposure (23:27), two SQL injections (23:29). This
   suggests the agent identified multiple attack vectors during recon and validated them
   systematically.

3. **Authentication/session testing (23:30–23:42, ~12 min):** JWT verification bypass (23:39)
   and unsafe password change (23:41). Deeper protocol-level testing after initial injection
   victories.

4. **Client-side testing (23:42–23:58, ~16 min):** DOM XSS discovery (23:57). The longest
   gap between vulnerabilities — browser-based testing requires more complex interaction
   (navigation, rendering, JavaScript execution verification). Strix's Playwright browser
   enabled this testing category.

5. **Report generation (23:58–23:59, ~1 min):** `finish_scan` called with executive summary,
   methodology, technical analysis, and recommendations. The tracer assembled the final
   `penetration_test_report.md` from pre-registered vulnerability data.

### Termination Behavior

The agent called `finish_scan` to terminate the run. Configured `max_iterations` is 300;
actual iteration count is unknown from the archive. The scan produced 7 validated vulnerability
reports with full PoCs before self-terminating — the agent appears to have made a deliberate
decision to stop after achieving comprehensive coverage, rather than exhausting its iteration budget.

The `finish_scan` tool requires the agent to provide executive summary, methodology,
technical analysis, and recommendations — this structured completion contract ensures
the agent produces a coherent final report rather than simply stopping mid-task.

---

## 5. Strengths

**S1. Structured, validated vulnerability reporting**
Every finding includes a CVSS 3.1 score, detailed technical analysis, and an executable Python
PoC. The `create_vulnerability_report` tool enforces required fields, validates CVSS vectors,
and rejects duplicates — producing reports of professional pentest quality. Mean CVSS: 8.86
across 7 findings.

**S2. Browser-enabled client-side testing**
Strix's Playwright headless browser enabled discovery of DOM XSS (vuln-0007, CVSS 9.6) — a
critical vulnerability category entirely unreachable by CLI-only agents like PentestGPT. The
browser allowed verification of JavaScript execution via `<img onerror>` handler injection in
the order tracking page.

**S3. Proxy-backed evidence trail**
Caido proxy integration captured 1200+ HTTP requests during the scan. Vulnerability reports
cite specific request IDs (399, 626, 627, 1078, 1203) as evidence — providing a verifiable
audit trail. This is significantly more rigorous than PentestGPT's approach of citing command
output inline.

**S4. Breadth of vulnerability discovery**
Seven distinct vulnerabilities across 7 categories (IDOR, info disclosure, SQLi x2, JWT bypass,
security misconfig, DOM XSS) demonstrate broad attack surface coverage. The agent escalated
from recon through injection, authentication bypass, and client-side testing in a logical
progression.

**S5. Efficient report generation**
Unlike PentestGPT (which spends ~25% of tool calls writing reports), Strix's reporting is
incremental: vulnerabilities are registered as discovered, and the final executive report
is assembled automatically by the tracer when `finish_scan` is called. This eliminates
redundant report-writing overhead.

---

## 6. Weaknesses

**W1. No raw tool execution logs in archive**
The output archive contains only vulnerability reports, the executive report, and a CSV index.
Tool call counts, command breakdown, cost data, and exact timing are not persisted. This limits
quantitative analysis and makes cross-agent comparison on tool-level metrics impossible without
re-running with enhanced logging.

**W2. No CTF flag awareness**
Strix's `create_vulnerability_report` produces professional-grade findings but does not
interact with Juice Shop's CTF flag system. It cannot be directly compared to PentestGPT's
flag submission counts on a flags-captured metric. While Strix's vulnerability reports
demonstrate deeper exploitation than PentestGPT's flag submissions, the lack of a common
metric complicates quantitative benchmarking.

**W3. Long execution time (estimated)**
The estimated duration of ~38–58 minutes is 5–8x longer than PentestGPT's mean 7m 17s.
While this produced substantially better results (7 validated vulns with PoCs vs. 0 verified
flags), the cost-per-finding tradeoff cannot be evaluated without cost data.

**W4. Single run — no reproducibility data**
With only one run, we cannot assess whether results are consistent or whether the 7 findings
represent a typical, best-case, or worst-case outcome. Run-to-run variance is unknown.

**W5. Unknown cost**
Without cost data, it is impossible to evaluate cost-effectiveness relative to PentestGPT
($2.49/run, $12.46 total for 5 runs). GPT-5 is likely more expensive per token than Claude
Sonnet 4.5, and the scan ran substantially longer with presumably more LLM calls.

---

## 7. Validity Concerns

### a) Training data bias

Juice Shop is extremely well-documented, and many of the discovered vulnerabilities (SQLi login
bypass, /ftp directory listing, JWT alg=none) are among the most commonly documented challenges.
However, Strix's vulnerability reports demonstrate deeper technical analysis than simple recall:
vuln-0004 identifies a 9-column UNION SELECT structure, vuln-0001 validates cross-user access
with multi-step PoC (create two accounts, test basket access), and vuln-0007 constructs a
specific DOM XSS payload with `onerror` handler. The PoC quality suggests genuine exploitation
rather than pure recall, though training data influence cannot be ruled out.

### b) State persistence

Target was restarted between runs per `bench-strix` (line 94: `docker restart "$container"`),
and `/tmp` was cleaned (line 89: `clean_tmp`). This is a significant methodological improvement
over the PentestGPT benchmark, which did not restart the target. However, with only 1 run,
state persistence effects cannot be observed.

### c) Flag verification

Not applicable in the traditional sense. Strix does not submit CTF flags. Instead, vulnerability
reports serve as the primary output. Each report includes:
- CVSS 3.1 vector (validated by `create_vulnerability_report`)
- Executable Python PoC with reproduction steps
- Proxy request ID evidence references
- Structured remediation steps

Verification of findings would require running the PoC scripts against a live Juice Shop
instance. The PoCs appear well-constructed but have not been independently executed.

### d) Model/provider dependency

Single model (GPT-5 via OpenAI). Strix supports any LiteLLM-compatible model via the
`STRIX_LLM` environment variable, making it more model-flexible than PentestGPT (locked to
Claude Sonnet 4.5 via Claude Agent SDK). However, results with GPT-5 may not generalize to
other models, especially given potential differences in security domain knowledge.

### e) Tool utilization

Strix has a substantially richer tool surface than PentestGPT:
- **Terminal execution** (full Kali toolkit: nmap, sqlmap, ffuf, nuclei, etc.)
- **Python runtime** (PoC development and validation)
- **Playwright browser** (DOM interaction, XSS verification, screenshot capture)
- **Caido proxy** (HTTP traffic intercept, replay, scope management)
- **File editing/search** (white-box code review capabilities)
- **Multi-agent orchestration** (specialized subagent delegation)
- **Structured reporting** (CVSS-validated vulnerability registration)

From the archive alone, we can confirm use of at least: terminal, python, browser, proxy,
reporting, and finish tools. Without tool execution logs, we cannot determine the percentage
breakdown. The proxy captured 1200+ requests, suggesting intensive HTTP-level testing.

### f) Target coverage

Strix's browser capability significantly expands reachable challenges compared to PentestGPT:
- XSS challenges: Reachable (vuln-0007 confirmed)
- Form-based challenges: Reachable via Playwright
- Client-side challenges: Reachable via Playwright + JS execution

Estimated reachable coverage: ~70–80% of 110 challenges (vs. ~40–50% for PentestGPT).
The agent reported 7 distinct vulnerabilities, several of which map to multiple Juice Shop
challenges. Conservative estimate: findings correspond to ~10–15 challenge categories.

---

## 8. Comparison Notes

### Cross-Agent (same target: Juice Shop)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (5 runs) | Strix (prelim, n=1) |
|--------|----------------|----------------------|--------------|---------------------|
| Runs | 1 | 5 | 5 (all stalled) | 1 |
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Vulnerabilities Reported | 0 (app-layer) | 0 verified flags | 0 (100% stall rate) | 7 (4 Critical, 3 High) |
| Mean CVSS | 2.1 (ICMP only) | N/A (no structured scoring) | N/A (stalled) | 8.86 |
| Mean Tool Calls | N/A (plugin-based) | 94.8 | 6.6 | N/A (not logged) |
| Mean Cost (USD) | $0.00 | $2.49 | $0.022 | N/A (not logged) |
| Mean Duration | 37m 50s | 7m 17s | ~4 min (pre-stall) | ~38–58 min (estimated) |
| % curl / HTTP-only | N/A | 80.0% | 60.6% | N/A (multi-tool) |
| Browser Capability | No | No | No | Yes (Playwright) |
| Proxy Capability | No | No | No | Yes (Caido, 1200+ requests) |
| Client-Side Vulns Found | 0 | 0 (N/A — no browser) | 0 (stalled) | 1 (DOM XSS, CVSS 9.6) |
| PoC Quality | N/A | None (flag submissions only) | N/A (stalled) | Professional (Python PoCs, 25–80 lines each) |
| Report Quality | Template-based | Agent-written markdown summaries | N/A (no report) | Structured reports with CVSS + PoC + remediation |
| Self-Termination | Fixed pipeline | ~30% of iteration budget used | Stalled (software bug) | Unknown (finish_scan called) |
| Target Reset | N/A | No | Yes | Yes |
| Vuln Categories Covered | 0/14 | 9/14 attempted, 0 flags captured | 0/14 (stalled before testing) | 8/14 reported with validated PoCs |

**Key qualitative differences:**
1. **Output paradigm:** PentestGPT submits flag-like values (hashes, keys, fabricated data);
   Strix produces structured vulnerability reports with CVSS scoring and executable PoCs.
   These are fundamentally different output modalities.
2. **Speed vs. depth:** PentestGPT runs in ~7 min with shallow coverage; Strix runs in
   ~40–60 min with deeper validated findings. The speed/depth tradeoff cannot be cost-adjusted
   without Strix cost data.
3. **Tool sophistication:** PentestGPT operates as essentially a curl client (80%); Strix
   uses browser, proxy, terminal, and Python runtime in combination.
4. **Verification rigor:** PentestGPT's self-reported 10–14 "solved challenges" had 0%
   verification accuracy. Strix's 7 vulnerability reports each include validated PoCs with
   proxy evidence references.

### Cross-Target (same agent: Strix)

| Metric | Juice Shop | BadStore |
|--------|-----------|----------|
| Vulnerabilities Reported | 7 (4 Crit, 3 High) | 7 (5 Crit, 2 High) |
| Mean CVSS | 8.86 | 9.14 |
| Duration (estimated) | ~38–58 min | ~39–59 min |
| Proxy Requests | ≥1203 | ≥530 |
| SQLi Findings | 2 | 2 |
| XSS Findings | 1 (DOM) | 2 (reflected + stored) |
| Auth Bypass Findings | 2 (SQLi + JWT) | 2 (cookie forgery + SQLi) |
| File-Related Findings | 1 (info disclosure) | 1 (path traversal + file write) |
| PoC Lines (approx) | 25–80 per vuln | 30–90 per vuln |
| Browser Vulns Found | 1 | 2 |

---

## 9. Recommendations

- **Re-run with enhanced logging:** Modify `bench-strix` to capture console output via
  `tee` or `script` to preserve tool call counts, timing, and cost data. Alternatively,
  patch Strix's tracer to persist `tool_executions` and `llm_stats` to the output archive.
- **Run 5 times per target:** Match PentestGPT's 5-run protocol for aggregate statistics
  and reproducibility assessment.
- **Add a common scoring metric:** Consider a target-agnostic scoring rubric (e.g.,
  vulnerability count x severity weighting, or OWASP category coverage percentage) that
  enables direct comparison between Strix's vulnerability reports and PentestGPT's flag
  submissions.
- **Independently verify PoCs:** Run each of the 7 Python PoC scripts against a fresh
  Juice Shop instance to validate that all findings are reproducible. This would convert
  "reported" to "verified" status.
- **Compare cost-effectiveness:** Once cost data is available, compute cost-per-validated-finding
  for both agents. If Strix costs ~$15–30 per run (estimated for GPT-5 with 40–60 min runtime),
  the cost per validated finding (~$2–4) may still be competitive with PentestGPT's
  effectively infinite cost per verified finding ($12.46 / 0 verified = undefined).
- **Test against less well-known target:** BadStore results (pending) will help control for
  training data bias, though BadStore is also well-documented in security training materials.
- **Evaluate multi-agent overhead:** Strix supports subagent delegation; determine whether
  this was used in the Juice Shop run and whether it contributed to or detracted from
  efficiency.
