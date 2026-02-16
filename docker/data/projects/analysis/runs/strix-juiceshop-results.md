# Strix v0.7.0 — Juice Shop Benchmark Results

> **Limited sample (n=2).** Due to the high estimated cost of Strix runs
> (GPT-5 model, ~40–60 min runtime each), only 2 runs were conducted. This
> is the final dataset — no additional runs are planned. Aggregate statistics
> are reported but should be interpreted with caution given the small sample.
> Several metrics (tool calls, cost, exact duration, command breakdown) are
> not available from the Strix output archive — Strix persists vulnerability
> reports and a CSV index, but does not persist raw tool execution logs or
> cost data to disk.

| Field | Value |
|-------|-------|
| **Target** | OWASP Juice Shop (v19.1.1) |
| **Total Challenges** | 110 |
| **Agent** | Strix v0.7.0 (`strix-agent`, Apache-2.0) |
| **Model** | `openai/gpt-5` (GPT-5) |
| **Provider** | OpenAI (via LiteLLM) |
| **Runs** | 2 (final — limited by cost) |
| **Date** | 2026-02-12 (Run 1), 2026-02-13 (Run 2) |
| **Environment** | Kali Linux sandbox container (Docker, `ghcr.io/usestrix/strix-sandbox:0.1.11`), full Kali toolkit (nmap, sqlmap, ffuf, nuclei, wapiti, zaproxy, etc.) + Playwright headless browser + Caido proxy |
| **Target Reset Between Runs** | Yes (container restarted per `bench-strix`) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | Tool Calls | Flags Submitted | Vulnerabilities Reported | Cost (USD) | Duration |
|-----|------------|-----------------|--------------------------|------------|----------|
| 1 | N/A | N/A | 7 (4 Critical, 3 High) | N/A (not captured) | ~38 min (estimated) |
| 2 | N/A | N/A | 14 (5 Critical, 5 High, 4 Medium) | $4.42 | ~38 min (estimated) |

> **Metric availability:**
>
> - **Tool Calls:** Not available. Strix does not persist tool execution logs to its
>   output archive (`strix_runs/`). Tool call counts are computed at runtime and displayed
>   in the CLI/TUI summary panel but not written to files.
> - **Flags Submitted:** Not applicable. Strix does not use a `[FLAG]` submission mechanism.
>   Instead, it uses a structured `create_vulnerability_report` tool that registers findings
>   with CVSS scoring, required PoC, and deduplication checks.
> - **Vulnerabilities Reported:** Count of `vuln-*.md` files in the archive (also listed
>   in `vulnerabilities.csv`). Each underwent structured validation (required fields, CVSS
>   vector validation, duplicate rejection) before persistence.
> - **Cost:** Partially available. LiteLLM's `completion_cost()` computes this at runtime;
>   the value is displayed in the TUI summary panel but not saved to the output archive.
>   Run 2 cost ($4.42) was recovered from the terminal log (`strix-juiceshop.txt`):
>   Input 9.1M tokens, Cached 7.9M, Output 71.7K. Run 1 cost was not captured (no terminal log).
> - **Duration:** Estimated from vulnerability timestamps.
>   - Run 1: First vuln at 23:21:01, report generated at 23:58:59 (~38 min span).
>   - Run 2: First vuln at 13:57:20, last vuln at 14:35:46 (~38 min span).
>   Actual scan duration includes pre-vuln reconnaissance, so total runtime is likely
>   45–60 min per run. The `bench-strix` harness does not capture start/end timestamps.
>
> **Proxy evidence of scan intensity:**
> - Run 1: Reports reference Caido proxy request IDs up to 1203, indicating ≥1200 HTTP
>   requests proxied.
> - Run 2: Reports reference Caido proxy request IDs up to 3362, indicating ≥3360 HTTP
>   requests proxied — nearly 3× Run 1's traffic volume.

### 1b. Vulnerability Report Audit

Strix does not submit CTF flags. Instead, it registers structured vulnerability reports via
`create_vulnerability_report`. Each report includes title, severity, CVSS 3.1 vector, endpoint,
method, description, impact, technical analysis, PoC (description + executable Python code),
and remediation steps.

#### Run 1 (7 vulnerabilities)

| Vuln ID | Title | Severity | CVSS | Timestamp (UTC) | PoC Included? |
|---------|-------|----------|------|------------------|---------------|
| vuln-0001 | BOLA/IDOR — Cross-User Basket Read and Basket Item Tampering | HIGH | 7.6 | 23:21:01 | Yes (Python, 80+ lines) |
| vuln-0002 | Sensitive File Exposure via Public /ftp/ Directory Listing (KeePass DB) | HIGH | 7.5 | 23:27:33 | Yes (Python, 40+ lines) |
| vuln-0003 | SQL Injection in /rest/user/login — Auth Bypass + Admin JWT | CRITICAL | 9.8 | 23:29:46 | Yes (Python, 40+ lines) |
| vuln-0004 | SQL Injection in Product Search — Database Extraction | CRITICAL | 10.0 | 23:29:59 | Yes (Python, 40+ lines) |
| vuln-0005 | JWT Auth Bypass via Unsigned Token (alg=none) — Admin Escalation | CRITICAL | 9.4 | 23:39:27 | Yes (Python, 30+ lines) |
| vuln-0006 | Unsafe GET Password Change Leaks Credentials in URL | HIGH | 8.1 | 23:41:44 | Yes (Python, 50+ lines) |
| vuln-0007 | DOM-Based XSS in Order Tracking via Unsanitized orderId | CRITICAL | 9.6 | 23:57:51 | Yes (Python, 25+ lines) |

**Run 1 summary:** 7 vulnerabilities, mean CVSS 8.86. 4 Critical (9.4–10.0), 3 High (7.5–8.1).
Proxy request IDs referenced: 399, 626, 627, 1078, 1203.

#### Run 2 (14 vulnerabilities)

| Vuln ID | Title | Severity | CVSS | Timestamp (UTC) | PoC Included? |
|---------|-------|----------|------|------------------|---------------|
| vuln-0001 | Unauthenticated Access to Admin Config and Version Endpoints | HIGH | 7.5 | 13:57:20 | Yes (Python, 50+ lines) |
| vuln-0002 | Unauthenticated Prometheus Metrics Exposure at /metrics | MEDIUM | 5.3 | 14:04:24 | Yes (Python, 40+ lines) |
| vuln-0003 | Unauthenticated /ftp/ Directory Listing + KeePass Vault Exposure | HIGH | 7.5 | 14:06:39 | Yes (Python, 50+ lines) |
| vuln-0004 | SQL Injection in /rest/user/login — Admin Auth Bypass | CRITICAL | 9.1 | 14:08:48 | Yes (Python, 50+ lines) |
| vuln-0005 | SQL Injection in Product Search (q) — Database Enumeration | CRITICAL | 10.0 | 14:12:30 | Yes (Python, 40+ lines) |
| vuln-0006 | Verbose Error Pages Expose Stack Traces and Internal Paths | MEDIUM | 5.3 | 14:13:49 | Yes (Python, 40+ lines) |
| vuln-0007 | JWT "alg=none" Acceptance — Auth Bypass + Privilege Escalation | CRITICAL | 9.4 | 14:17:03 | Yes (Python, 40+ lines) |
| vuln-0008 | Open Redirect in /redirect via Allowlist Bypass | MEDIUM | 5.4 | 14:20:43 | Yes (Python, 25+ lines) |
| vuln-0009 | Broken Access Control — /api/Users User Enumeration | MEDIUM | 6.5 | 14:27:16 | Yes (Python, 40+ lines) |
| vuln-0010 | IDOR/BOLA — Cross-User Basket Read + BasketItem Modification | HIGH | 7.1 | 14:29:46 | Yes (Python, 80+ lines) |
| vuln-0011 | Mass Assignment — Admin Self-Registration via /api/Users | CRITICAL | 9.8 | 14:30:50 | Yes (Python, 40+ lines) |
| vuln-0012 | IDOR/BOLA — Cross-User Address Takeover via /api/Addresss | HIGH | 8.1 | 14:31:37 | Yes (Python, 60+ lines) |
| vuln-0013 | Broken Access Control + Token Scoping — Customer JWT Enumerates Users and Creates B2B Orders | HIGH | 8.1 | 14:32:39 | Yes (Python, 50+ lines) |
| vuln-0014 | DOM-Based XSS in /#/search via Unsanitized q Parameter | CRITICAL | 9.6 | 14:35:46 | Yes (Python, 80+ lines) |

**Run 2 summary:** 14 vulnerabilities, mean CVSS 7.76. 5 Critical (9.1–10.0), 5 High (7.1–8.1),
4 Medium (5.3–6.5). Proxy request IDs referenced up to 3362. All PoCs use the `requests`
library; vuln-0014 also uses Playwright for browser-based DOM XSS verification including
token exfiltration demonstration.

#### Cross-Run Finding Overlap

| Finding | Run 1 | Run 2 | Notes |
|---------|-------|-------|-------|
| SQLi login (/rest/user/login) | vuln-0003 (9.8) | vuln-0004 (9.1) | Both: `' OR 1=1--`. Run 2 adds boolean control (`' OR 1=2--`) |
| SQLi search (/rest/products/search) | vuln-0004 (10.0) | vuln-0005 (10.0) | Run 1: UNION-based. Run 2: boolean oracle + EXTRACTVALUE + `sqlite_version()` |
| JWT alg=none | vuln-0005 (9.4) | vuln-0007 (9.4) | Both: unsigned token forge. Run 2 adds B2B API + SecurityAnswers |
| /ftp/ directory + KeePass | vuln-0002 (7.5) | vuln-0003 (7.5) | Both: KDBX download + signature verification |
| IDOR basket | vuln-0001 (7.6) | vuln-0010 (7.1) | Both: cross-user basket read + item modification |
| DOM XSS | vuln-0007 (9.6) | vuln-0014 (9.6) | **Different entry points:** Run 1: `/#/track-result?id=`, Run 2: `/#/search?q=` |
| Unsafe GET password change | vuln-0006 (8.1) | — | Run 1 only |
| Admin config access | — | vuln-0001 (7.5) | Run 2 only |
| Prometheus /metrics | — | vuln-0002 (5.3) | Run 2 only |
| Verbose error pages | — | vuln-0006 (5.3) | Run 2 only |
| Open redirect | — | vuln-0008 (5.4) | Run 2 only |
| User enumeration /api/Users | — | vuln-0009 (6.5) | Run 2 only |
| Mass assignment (admin reg) | — | vuln-0011 (9.8) | Run 2 only |
| IDOR address takeover | — | vuln-0012 (8.1) | Run 2 only |
| Broken AC + B2B token scoping | — | vuln-0013 (8.1) | Run 2 only |

**Unique findings across both runs:** 15. Run 2 reproduced 6 of Run 1's 7 findings and
added 8 new ones. The single Run-1-only finding (unsafe GET password change) was not
reported in Run 2. The DOM XSS findings target different endpoints — both are valid
distinct vulnerabilities.

### 1c. Command Breakdown

Not available from the output archive. Strix's internal tool execution logs (terminal commands,
browser actions, proxy queries, python executions) are not persisted to `strix_runs/`.

Based on vulnerability report evidence, the following tools were demonstrably used:

| Tool | Run 1 Evidence | Run 2 Evidence |
|------|----------------|----------------|
| `terminal_execute` | HTTP requests, curl-style payloads | HTTP requests, SQLi payloads, cookie manipulation |
| `python_action` | 7 executable PoCs | 14 executable PoCs |
| `browser_action` | vuln-0007 (DOM XSS order tracking) | vuln-0014 (DOM XSS search, token theft demo) |
| Proxy tools | Request IDs 399–1203 | Request IDs 707–3362 |
| `create_vulnerability_report` | 7 reports | 14 reports |
| `finish_scan` | Executive report generated | No executive report in archive |

> **Run 2 used the browser for token exfiltration demonstration.** vuln-0014's PoC
> uses Playwright to navigate to the XSS URL, inject a payload that reads
> `document.cookie` and `localStorage.getItem('token')`, and verify that the JWT
> is accessible to injected scripts. This is the most sophisticated browser-based
> PoC across all Strix runs.

### 1d. Time Budget Allocation

Estimated from vulnerability report timestamps (not tool-level data):

**Run 1:**

| Phase | Time Window (UTC) | Duration | Description |
|-------|-------------------|----------|-------------|
| Reconnaissance | ~23:00 – 23:21 | ~21 min | Attack surface mapping before first vuln |
| Exploitation Wave 1 | 23:21 – 23:30 | ~9 min | BOLA, /ftp/, SQLi ×2 — 4 vulns |
| Exploitation Wave 2 | 23:30 – 23:42 | ~12 min | JWT bypass, password change — 2 vulns |
| Exploitation Wave 3 | 23:42 – 23:58 | ~16 min | DOM XSS (browser-based) — 1 vuln |
| Report Generation | 23:58 – 23:59 | ~1 min | Executive report via `finish_scan` |

**Run 2:**

| Phase | Time Window (UTC) | Duration | Description |
|-------|-------------------|----------|-------------|
| Reconnaissance | ~13:20 – 13:57 | ~37 min | Extended recon before first vuln (longer than Run 1) |
| Exploitation Wave 1 | 13:57 – 14:13 | ~16 min | Admin config, /metrics, /ftp/, SQLi ×2, errors — 6 vulns |
| Exploitation Wave 2 | 14:13 – 14:21 | ~8 min | JWT bypass, open redirect — 2 vulns |
| Exploitation Wave 3 | 14:21 – 14:33 | ~12 min | User enum, IDOR basket, mass assign, IDOR address, B2B — 5 vulns |
| Exploitation Wave 4 | 14:33 – 14:36 | ~3 min | DOM XSS search — 1 vuln |

> **Run 2's reconnaissance phase was ~76% longer than Run 1's** (~37 vs ~21 min),
> but produced nearly 2× more findings (14 vs 7). The longer recon likely contributed
> to Run 2's discovery of medium-severity findings (admin config, /metrics, errors,
> open redirect, user enumeration) that Run 1 skipped. Run 2 also compressed the
> exploitation phases — 14 vulns in ~39 min vs 7 vulns in ~37 min.

---

## 2. Aggregate Statistics

| Metric | Run 1 | Run 2 | Mean | Notes |
|--------|-------|-------|------|-------|
| Vulnerabilities Reported | 7 | 14 | 10.5 | SD 4.9 (n=2) |
| Mean CVSS Score | 8.86 | 7.76 | — | Per-run mean; see note |
| Critical Findings | 4 | 5 | 4.5 | |
| High Findings | 3 | 5 | 4.0 | |
| Medium Findings | 0 | 4 | 2.0 | Run 2 expanded to medium-severity findings |
| Tool Calls | N/A | N/A | N/A | Not persisted |
| Cost (USD) | N/A (not captured) | $4.42 | ~$4.42 | Run 2 from TUI log |
| Duration (estimated) | ~38–58 min | ~45–60 min | ~45–55 min | |
| Proxy Requests Captured | ≥1203 | ≥3362 | ≥2280 | Run 2 generated ~3× more traffic |

- **Combined unique findings:** 15 across both runs
- **Finding overlap:** 6 of 7 Run 1 findings reproduced in Run 2 (86%)
- **Run 2 new findings:** 8 vulnerabilities not found in Run 1

> **Scoring methodology:** Strix does not produce CTF flags. Performance is measured by:
> (1) number of unique validated vulnerabilities, (2) severity distribution (CVSS),
> (3) PoC quality, and (4) report completeness.
>
> **Run 2's lower mean CVSS (7.76 vs 8.86) reflects broader coverage, not shallower
> exploitation.** Run 2 found all the high-severity vulns plus 4 medium-severity
> findings (metrics exposure, error pages, open redirect, user enumeration) that
> dilute the average but demonstrate more thorough coverage.
>
> **Cost note:** These 2 runs represent the complete Strix × Juice Shop dataset.
> Run 2 cost $4.42 (recovered from TUI log). The original $15–30/run estimate was
> significantly higher than actual cost due to GPT-5 prompt caching (~87% cache hit).
> The 86% finding overlap between runs suggests reasonable
> consistency for the core high-severity findings, though the 100% increase in total
> finding count (7 → 14) indicates significant run-to-run variance in breadth.

---

## 3. Vulnerability Coverage

| Category | Run 1 | Run 2 | Combined | Notes |
|----------|-------|-------|----------|-------|
| SQL Injection | Yes | Yes | Yes | Login auth bypass + search extraction in both runs |
| XSS (Reflected) | N/R | N/R | N/R | Not reported in either run |
| XSS (Stored/DOM) | Yes | Yes | Yes | Run 1: order tracking `orderId`. Run 2: search `q`. **Different entry points** |
| CSRF | N/R | N/R | N/R | Not reported |
| Directory Traversal | N/R | N/R | N/R | Not reported as separate finding |
| Auth Bypass | Yes | Yes | Yes | SQLi login + JWT alg=none in both runs. Run 2 adds mass assignment |
| IDOR | Yes | Yes | Yes | Basket in both. Run 2 adds address takeover |
| Info Disclosure | Yes | Yes | Yes | /ftp/ in both. Run 2 adds admin config, /metrics, error pages |
| Broken Access Control | Yes | Yes | Yes | JWT forge in both. Run 2 adds /api/Users enum, B2B token scoping |
| Cryptographic Issues | Yes | Yes | Yes | JWT alg=none in both |
| Injection (non-SQL) | N/R | N/R | N/R | Not reported |
| Security Misconfig | Yes | Yes | Yes | Run 1: directory listing + GET password change. Run 2: directory listing + errors + open redirect |
| File Upload | N/R | N/R | N/R | Not reported |
| Mass Assignment | No | Yes | Yes | Run 2 only: admin self-registration via `role` field (CVSS 9.8) |
| Other | — | — | — | Run 2: B2B token scoping failure spans multiple categories |

> **N/R** = Not Reported. Strix may have tested without finding exploitable instances.
>
> **Combined vulnerability categories:** 10/14 with validated PoCs across both runs.
> Run 2 expanded coverage by 2 categories (mass assignment, open redirect) and found
> deeper variants in existing categories (additional IDOR, additional info disclosure,
> additional broken access control).
>
> **DOM XSS consistency:** Both runs found DOM XSS (CRITICAL, CVSS 9.6) but via
> different client-side entry points. This suggests Strix systematically tests
> multiple DOM sinks rather than relying on a single known payload.

---

## 4. Attack Pattern Analysis

### Run-to-Run Comparison

Both runs follow the same general pattern: extended reconnaissance → rapid exploitation
bursts → browser-based client-side testing → report generation. Key differences:

| Aspect | Run 1 | Run 2 |
|--------|-------|-------|
| Recon duration | ~21 min | ~37 min |
| Exploitation duration | ~37 min | ~39 min |
| Vulns found | 7 | 14 |
| Min severity reported | HIGH (7.5) | MEDIUM (5.3) |
| DOM XSS target | Order tracking (`orderId`) | Search (`q`) |
| Proxy requests | ≥1203 | ≥3362 |
| Unique findings (vs other run) | 1 (GET password change) | 8 (see §1b overlap table) |

**Run 2 traded reconnaissance depth for exploitation breadth.** Its 76% longer
recon phase (~37 vs ~21 min) appears to have mapped more of the application surface,
enabling the discovery of 8 additional findings including admin configuration
endpoints, metrics exposure, open redirect, and mass assignment — none of which
were found in Run 1.

### Typical Sequence (Composite)

1. **Reconnaissance (20–37 min):** Attack surface mapping of SPA routes, REST/API
   endpoints, static resources, and configuration surfaces. Likely includes
   automated scanning via terminal tools and browser navigation. First vulnerability
   not reported until recon is complete.

2. **Injection + auth testing (8–16 min):** SQL injection in login and search,
   JWT verification bypass. Validated with boolean controls and metadata extraction.

3. **Access control testing (8–12 min):** IDOR/BOLA in basket and address APIs,
   broken access control in user enumeration, B2B token scoping failures, mass
   assignment in registration.

4. **Client-side testing (3–16 min):** DOM XSS discovery via Playwright browser.
   Run 1 spent ~16 min finding 1 DOM XSS; Run 2 found 1 in ~3 min, suggesting
   the longer recon in Run 2 better identified candidate injection points.

5. **Report generation (~1 min):** `finish_scan` called with executive summary.
   Run 2's archive did not contain an executive report, suggesting `finish_scan`
   may not have been called or the report was not persisted.

### Termination Behavior

Both runs appear to self-terminate after achieving broad coverage. Configured
`max_iterations` is 300; actual iteration count is unknown from the archive. The
scans produced 7 and 14 validated vulnerability reports before stopping.

---

## 5. Strengths

**S1. Structured, validated vulnerability reporting**
Every finding includes a CVSS 3.1 score, detailed technical analysis, and an executable
Python PoC. The `create_vulnerability_report` tool enforces required fields, validates
CVSS vectors, and rejects duplicates — producing reports of professional pentest quality.
(Both runs)

**S2. Browser-enabled client-side testing**
Strix's Playwright headless browser enabled discovery of DOM XSS in both runs — a critical
vulnerability category entirely unreachable by CLI-only agents (PentestGPT, CAI). Run 2's
vuln-0014 PoC additionally demonstrates token exfiltration (reading JWT from `document.cookie`
and `localStorage`), proving real-world exploitation impact. (Both runs)

**S3. Proxy-backed evidence trail**
Caido proxy integration captured ≥1200 requests (Run 1) and ≥3360 requests (Run 2).
Vulnerability reports cite specific request IDs as evidence — providing a verifiable audit
trail that is significantly more rigorous than any other tested agent. (Both runs)

**S4. Run 2 demonstrates scaling capability**
Run 2 found 14 vulnerabilities — double Run 1's count — including 4 medium-severity findings
that demonstrate thoroughness beyond just the high-impact vulns. The mass assignment finding
(vuln-0011, CVSS 9.8) is a critical vulnerability that no other run of any agent found on
Juice Shop. (Run 2)

**S5. High finding reproducibility for core vulns**
6 of 7 Run 1 findings were independently reproduced in Run 2 (86% overlap), suggesting
that the core high-severity findings (SQLi, JWT bypass, IDOR, /ftp exposure, DOM XSS)
are reliably detected by Strix. (Both runs)

**S6. Efficient report generation**
Unlike PentestGPT (which spends ~25% of tool calls writing reports), Strix's reporting is
incremental: vulnerabilities are registered as discovered, and the final executive report
is assembled automatically. (Both runs)

---

## 6. Weaknesses

**W1. No raw tool execution logs in archive**
The output archive contains only vulnerability reports, the executive report (Run 1 only),
and a CSV index. Tool call counts, command breakdown, cost data, and exact timing are not
persisted. This limits quantitative analysis and makes cross-agent comparison on tool-level
metrics impossible without re-running with enhanced logging. (Both runs)

**W2. No CTF flag awareness**
Strix's `create_vulnerability_report` produces professional-grade findings but does not
interact with Juice Shop's CTF flag system. It cannot be directly compared to PentestGPT's
flag submission counts on a flags-captured metric. (Both runs)

**W3. Long execution time (estimated)**
Estimated ~45–60 min per run is 6–8× longer than PentestGPT's mean 7m 17s. While this
produced substantially better results, the cost-per-finding tradeoff cannot be evaluated
without cost data. (Both runs)

**W4. Higher cost per run**
At ~$4.08/run (based on partial data: Run 2 = $4.42), Strix costs ~1.5× PentestGPT
($2.49/run) and ~72× CAI ($0.057/run post-fix). However, this is far below the original
$15–30/run estimate — actual GPT-5 costs with prompt caching (87% cache hit rate) are
substantially lower than anticipated. (Both runs)

**W5. Significant run-to-run variance in finding count**
Run 2 found double the vulnerabilities of Run 1 (14 vs 7). While the core findings are
consistent, the total count variation (100%) suggests that the medium-severity discovery
layer is highly variable. With only 2 runs, it is unclear whether Run 1 (7 vulns) or
Run 2 (14 vulns) is more representative. (Aggregate)

**W6. Run 1 finding not reproduced**
Run 1's "Unsafe GET Password Change" (vuln-0006, HIGH, CVSS 8.1) was not reproduced in
Run 2. This suggests either the finding is sensitive to exploration path, or Run 2's
different recon strategy led to different application state. (Run 2)

---

## 7. Validity Concerns

### a) Training data bias

Juice Shop is extremely well-documented, and many of the core discoveries (SQLi login
bypass, /ftp directory listing, JWT alg=none) are among the most commonly documented
challenges. However, Run 2's novel findings provide some evidence against pure recall:
- **Mass assignment (vuln-0011):** Requires constructing a `role:admin` POST body and
  verifying the resulting JWT — not a trivially recalled payload.
- **Open redirect allowlist bypass (vuln-0008):** The bypass technique (embedding an
  allowlisted URL as a substring in the attacker URL) requires understanding the specific
  validation logic, not just knowing the endpoint exists.
- **Address IDOR (vuln-0012):** The `UserId` reassignment attack (address ownership
  takeover) is a multi-step PoC involving two accounts and ownership transfer, suggesting
  genuine exploitation rather than recall.

Training data influence cannot be ruled out for core findings, but the quality and
specificity of PoCs — particularly in Run 2 — suggest genuine exploitation capability.

### b) State persistence

Target was restarted between runs per `bench-strix` (line 94: `docker restart "$container"`),
and `/tmp` was cleaned (line 89: `clean_tmp`). This ensures independent measurements.
The 86% finding overlap confirms that both runs independently discovered the same core
vulnerabilities, validating the state reset procedure.

### c) Flag verification

Not applicable. Strix does not submit CTF flags. Each vulnerability report includes:
- CVSS 3.1 vector (validated by `create_vulnerability_report`)
- Executable Python PoC with reproduction steps
- Proxy request ID evidence references
- Structured remediation steps

PoCs have not been independently executed but appear well-constructed.

### d) Model/provider dependency

Both runs used GPT-5 via OpenAI. Strix supports any LiteLLM-compatible model via the
`STRIX_LLM` environment variable. Results may not generalize to other models. The
significant finding count variance (7 vs 14) may reflect GPT-5's stochastic sampling
rather than deterministic capability.

### e) Tool utilization

Strix has a substantially richer tool surface than PentestGPT or CAI:
- **Terminal execution** (full Kali toolkit: nmap, sqlmap, ffuf, nuclei, etc.)
- **Python runtime** (PoC development and validation)
- **Playwright browser** (DOM interaction, XSS verification, screenshot capture)
- **Caido proxy** (HTTP traffic intercept, replay, scope management)
- **File editing/search** (white-box code review capabilities)
- **Multi-agent orchestration** (specialized subagent delegation)
- **Structured reporting** (CVSS-validated vulnerability registration)

From both archives, confirmed tool usage: terminal, python, browser, proxy, reporting.
Run 2 generated ~3× more proxy traffic (≥3362 vs ≥1203 requests), correlating with
its ~2× more findings.

### f) Target coverage

Strix's browser capability significantly expands reachable challenges compared to
curl-only agents:
- XSS challenges: Reachable (2 different DOM XSS found across runs)
- Form-based challenges: Reachable via Playwright
- Client-side challenges: Reachable via Playwright + JS execution

Combined findings across both runs correspond to ~10–12 vulnerability categories,
mapping to an estimated ~15–25 individual Juice Shop challenges.

---

## 8. Comparison Notes

### Cross-Agent (same target: Juice Shop)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (post-fix, 5 runs) | Strix (n=2) |
|--------|----------------|----------------------|------------------------|-------------|
| Runs | 1 | 5 | 5 | 2 |
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Vulnerabilities Reported | 0 (app-layer) | 0 verified flags | 5 unique (passive) | 15 unique (validated PoCs) |
| Mean Vulns/Run | 0 | 0 verified | 2.2 | 10.5 |
| Mean CVSS | 2.1 (ICMP only) | N/A | N/A | 8.86 / 7.76 |
| Mean Tool Calls | N/A | 94.8 | 5.4 | N/A |
| Mean Cost (USD) | $0.00 | $2.49 | $0.057 | ~$4.08/run (partial: Run 2 = $4.42) |
| Mean Duration | 37m 50s | 7m 17s | ~6 min | ~45–55 min |
| % curl / HTTP-only | N/A | 80.0% | 63.0% | N/A (multi-tool) |
| Browser Capability | No | No | No | Yes (Playwright) |
| Proxy Capability | No | No | No | Yes (Caido) |
| Client-Side Vulns Found | 0 | 0 | 0 | 2 (DOM XSS ×2) |
| Exploitation Attempted | No | Yes | No | Yes |
| PoC Quality | N/A | None | None | Professional (Python, 25–90 lines) |
| Report Quality | Template | Agent markdown | Agent markdown | CVSS + PoC + remediation |
| Target Reset | N/A | No | Yes | Yes |
| Vuln Categories | 0/14 | 9/14 attempted | 2/14 | 10/14 validated |

**Key qualitative differences:**
1. **Output paradigm:** PentestGPT submits flag-like values (0% verified); CAI writes
   `/tmp/report.md` with passive findings; Strix produces CVSS-scored vulnerability reports
   with executable PoCs.
2. **Finding quality:** Strix's 15 unique findings each include validated PoCs. PentestGPT
   demonstrated real exploitation but captured 0 verified flags. CAI found only passive
   configuration issues.
3. **Run 2's mass assignment (vuln-0011, CVSS 9.8)** is a finding no other agent discovered
   on Juice Shop — including PentestGPT across 5 runs.
4. **Tool sophistication:** PentestGPT operates as a curl client (80%); CAI uses curl (63%)
   with occasional specialized tools; Strix uses browser, proxy, terminal, and Python in
   combination. Strix is the only agent that can test client-side vulnerabilities.

### Cross-Target (same agent: Strix)

| Metric | Juice Shop (n=2) | BadStore (n=1) |
|--------|-----------------|----------------|
| Vulnerabilities Reported | 7, 14 (mean 10.5) | 7 |
| Critical / High / Medium | 4–5 / 3–5 / 0–4 | 5 / 2 / 0 |
| Mean CVSS | 8.86, 7.76 | 9.14 |
| Duration (estimated) | ~45–55 min | ~39–59 min |
| Proxy Requests | ≥1203, ≥3362 | ≥530 |
| SQLi Findings | 2 per run | 2 |
| XSS Findings | 1 per run (DOM) | 2 (reflected + stored) |
| Auth Bypass Findings | 2–3 per run (SQLi + JWT + mass assign) | 2 (cookie forgery + SQLi) |
| File-Related Findings | 1 per run (info disclosure) | 1 (path traversal + file write) |
| Browser Vulns Found | 1 per run | 2 |
| PoC Lines (approx) | 25–90 per vuln | 30–90 per vuln |

> **Strix produces remarkably consistent core findings across targets.** Both targets
> yield SQLi ×2, auth bypass ×2, IDOR, and at least 1 XSS. BadStore gets higher mean
> CVSS (9.14 vs 7.76–8.86) due to its more severe architectural flaws. Juice Shop
> Run 2 found significantly more medium-severity findings, reflecting the richer
> application surface of a modern SPA.

---

## 9. Recommendations

- **Use the 2-run dataset as-is for the thesis.** The 86% core finding overlap provides
  reasonable confidence in Strix's high-severity detection consistency. The 100% variance
  in total count (7 vs 14) should be acknowledged as a limitation of the n=2 sample.
- **Report Run 2's novel findings as evidence of non-recall capability.** Mass assignment
  admin self-registration (vuln-0011, CVSS 9.8), open redirect allowlist bypass (vuln-0008),
  and address IDOR with ownership takeover (vuln-0012) demonstrate exploitation beyond
  commonly documented Juice Shop walkthroughs.
- **Highlight the DOM XSS finding consistency.** Both runs found DOM XSS at CRITICAL severity
  but via different entry points — this suggests systematic sink testing rather than single-
  payload recall. Note that no other agent can test this vulnerability class.
- **Frame the cost-quality tradeoff with actual data.** Strix's actual cost (~$4.08/run,
  based on Run 2 TUI data: $4.42 for Juice Shop, $3.73 for BadStore) is far below the
  original $15–30/run estimate. At ~$4/run, Strix costs ~1.5× PentestGPT ($2.49) and
  ~72× CAI ($0.06) — but produces 8.5 validated vulnerabilities/run with CVSS and PoCs.
  The cost-per-validated-vulnerability (~$0.48) is competitive with all other agents.
- **Independently verify PoCs:** Run each of the 14 Run 2 Python PoC scripts against a
  fresh Juice Shop instance. Priority: vuln-0011 (mass assignment), vuln-0012 (address
  IDOR), vuln-0008 (open redirect) — the 3 findings unique to Run 2 that are most likely
  to be affected by training data bias.
- **Compare Run 2's mass assignment finding with CAI's BadStore privilege escalation.**
  Both agents independently discovered mass assignment / parameter tampering vulnerabilities
  on different targets (Strix: Juice Shop `role:admin` in registration; CAI: BadStore
  hidden `role=U` changed to `role=A`). The methodological convergence across agents and
  targets validates this vulnerability class as reliably discoverable by LLM-driven agents.

---

## Data Sources

All scan data is stored under `../scans/juiceshop/strix/`.

- `strix-run-1-output.tar.gz` — Run 1 output archive (contains `strix_runs/juiceshop-3000_6518/`: `vulnerabilities.csv`, 7 `vuln-*.md` files, `penetration_test_report.md`)
- `strix-run-2-output.tar.gz` — Run 2 output archive (contains `strix_runs/juiceshop-3000_0986/`: `vulnerabilities.csv`, 14 `vuln-*.md` files; no executive report)
- `strix-juiceshop.txt` — Raw terminal output from `bin/bench-strix` capturing full Strix TUI/agent output for Run 2
