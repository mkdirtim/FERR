# GVM (Greenbone) — BadStore Baseline Scan Results

> **Context:** GVM (Greenbone Vulnerability Management, formerly OpenVAS) is a traditional
> network vulnerability scanner. It uses signature-based NVT (Network Vulnerability Tests)
> plugins to detect known CVEs and misconfigurations. It does **not** perform application-logic
> testing, authentication bypass, injection payload generation, or interactive exploitation.
> This scan serves as a **baseline** comparison for the autonomous AI agents (PentestGPT, Strix, CAI).

| Field | Value |
|-------|-------|
| **Target** | BadStore (v2.1, Apache/2.4.65 Debian) |
| **Total Challenges** | N/A (no CTF flag system) |
| **Scanner** | GVM / Greenbone Vulnerability Management (OpenVAS) |
| **Model** | N/A (signature-based, no LLM) |
| **Provider** | N/A (self-hosted) |
| **Runs** | 1 |
| **Date** | 2026-02-11 |
| **Environment** | Docker network, scanner targeting `192.168.77.7` (`targets-badstore`) on port 80/tcp |
| **Target Reset Between Runs** | N/A (single scan) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | NVT Checks | Findings (≥ Low) | Findings (≥ Medium) | Cost (USD) | Duration |
|-----|------------|-------------------|---------------------|------------|----------|
| 1 | 26 (pre-filter) / 22 (post-filter) | 0 | 0 | $0.00 | 6m 44s |

> **Extraction:**
>
> - **NVT Checks:** Report states "26 results before filtering" with "22 results selected"
>   by QoD ≥ 70 filter. Of these, 10 are shown in the report (pagination limit).
> - **Findings:** Host summary shows 0 Critical, 0 High, 0 Medium, 0 Low, 10 Log.
>   **Zero actionable security findings at any severity level.**
> - **Cost:** GVM is open-source and self-hosted. No API/LLM costs.
> - **Duration:** Scan started 19:01:45 UTC, ended 19:08:29 UTC = 6m 44s.

### 1b. Finding Detail

| NVT | Severity | CVSS | Port | CVE | Description |
|-----|----------|------|------|-----|-------------|
| Allowed HTTP Methods Enumeration (x2) | Log | 0.0 | 80/tcp | — | HEAD,GET,POST,OPTIONS allowed (both hostnames) |
| Apache HTTP Server Detection | Log | 0.0 | general/tcp | — | Apache/2.4.65 (Debian) detected on port 80 |
| CPE Inventory | Log | 0.0 | general | — | `cpe:/a:apache:http_server:2.4.65`, `cpe:/o:debian:debian_linux:13` |
| Hostname Determination | Log | 0.0 | general | — | Forward DNS: `badstore`, Reverse DNS: `targets-badstore.openhackstack_openhackstack-network` |
| HTTP Security Headers Detection (x2) | Log | 0.0 | 80/tcp | — | **All** security headers missing (CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, etc.) |
| HTTP Server Banner Enumeration (x2) | Log | 0.0 | 80/tcp | — | `Apache/2.4.65 (Debian)` confirmed via invalid HTTP request |
| HTTP Server type and version | Log | 0.0 | 80/tcp | — | Server banner: `Apache/2.4.65 (Debian)` |

**Summary:** Zero findings at any actionable severity level (Low, Medium, High, or Critical).
All 10 reported results are Log/informational. GVM identified the web server (Apache 2.4.65)
and noted that all security headers are missing, but found no exploitable vulnerabilities.

### 1c. Command / Plugin Breakdown

| Plugin Category | Count | Description |
|-----------------|-------|-------------|
| Service Detection | 4 | Apache detection, server banner (x2), server type/version |
| HTTP Analysis | 4 | HTTP methods enumeration (x2), security headers (x2) |
| Asset Inventory | 2 | CPE inventory, hostname determination |

> All plugins are informational/fingerprinting only. No injection, authentication,
> or dynamic vulnerability testing was performed.

### 1d. Time Budget Allocation

| Phase | Duration | Description |
|-------|----------|-------------|
| Host Discovery | ~10s | ICMP/port scanning |
| NVT Execution | ~5 min | Running applicable plugins |
| Report Generation | ~1 min | Aggregation and filtering |

> The 6m 44s scan is significantly faster than the Juice Shop scan (37m 50s), likely
> because BadStore's simpler Apache/CGI architecture triggers fewer NVT plugins than
> Juice Shop's Node.js/Express stack.

---

## 2. Aggregate Statistics

| Metric | Value | Notes |
|--------|-------|-------|
| Total NVT Results | 22 (post-QoD filter) | 26 before filtering |
| Findings ≥ Medium | 0 | No application vulnerabilities detected |
| Findings ≥ Low | 0 | Not even a Low-severity finding |
| Max CVSS | 0.0 | All results are Log level |
| Cost (USD) | $0.00 | Self-hosted |
| Duration | 6m 44s | Single scan |

> **Notable:** BadStore is an intentionally vulnerable application with well-documented
> SQL injection, XSS, directory traversal, and authentication vulnerabilities. GVM
> detected **none** of them. Even the complete absence of security headers — while reported
> as informational — was not flagged at any actionable severity level.

---

## 3. Vulnerability Coverage

| Category | Detected? | Exploited? | Notes |
|----------|-----------|------------|-------|
| SQL Injection | No | N/A | BadStore has multiple SQLi vulns (login, search, order); GVM cannot test dynamic injection |
| XSS (Reflected) | No | N/A | BadStore has reflected XSS in search; GVM has limited XSS detection |
| XSS (Stored/DOM) | No | N/A | BadStore has stored XSS in guestbook; no DOM interaction |
| CSRF | No | N/A | Not testable by network scanner |
| Directory Traversal | No | N/A | BadStore has path traversal vulns; GVM did not test |
| Auth Bypass | No | N/A | BadStore has trivially bypassable auth; GVM did not test |
| IDOR | No | N/A | Requires session/authentication context |
| Info Disclosure | Partial | N/A | Detected Apache version and missing headers; missed exposed admin panels, backup files, error messages |
| Broken Access Control | No | N/A | Requires application-level testing |
| Cryptographic Issues | No | N/A | BadStore uses MD5 password hashes; GVM cannot detect this |
| Injection (non-SQL) | No | N/A | BadStore has OS command injection; GVM did not test |
| Security Misconfig | Partial | N/A | Noted all security headers missing; missed CGI misconfiguration, debug info, exposed database |
| File Upload | No | N/A | Not tested |
| Other | — | — | — |

> **PentestGPT found on BadStore:** SQLi (login, search, order forms), XSS, directory
> traversal, admin access, webshell upload via sqlmap `--os-shell`, password hash extraction.
> GVM found none of these. The gap is total.

---

## 4. Attack Pattern Analysis

### Typical Sequence

Identical to Juice Shop scan — fixed deterministic pipeline:

1. **Host discovery:** Port scan (80/tcp detected)
2. **Service fingerprinting:** Apache/2.4.65 (Debian) identified
3. **NVT execution:** HTTP methods, security headers, banner checks
4. **Report generation:** All Log-level, zero actionable findings

### Termination Behavior

GVM terminated after exhausting all applicable NVT plugins (6m 44s). The significantly
shorter scan time vs. Juice Shop (37m 50s) suggests fewer plugins were triggered by
BadStore's simpler Apache/CGI stack compared to Juice Shop's Node.js application.

---

## 5. Strengths

**S1. Fast and free**
6m 44s scan with zero cost. Suitable for quick infrastructure checks and CI/CD integration.

**S2. Accurate server fingerprinting**
Correctly identified Apache 2.4.65 on Debian 13 with full CPE classification. This
version information could be useful for CVE lookups if the server software had known
vulnerabilities.

**S3. Comprehensive header audit**
Correctly identified that BadStore is missing **all** recommended security headers
(CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy,
and 10+ others). This is a legitimate finding — BadStore's complete lack of security
headers is worse than Juice Shop's partial implementation.

---

## 6. Weaknesses

**W1. Zero vulnerability detection on a deliberately vulnerable application**
BadStore is designed to be exploitable, with well-known SQLi, XSS, directory traversal,
and authentication bypass vulnerabilities. GVM found none of them. This is the most
stark illustration of traditional scanners' limitations against application-logic vulnerabilities.

**W2. No web application testing capability**
GVM did not attempt to interact with BadStore's CGI endpoints, forms, or application
logic. It treated the target as a generic HTTP server and performed only network-level checks.

**W3. Not even a Low-severity finding**
Unlike the Juice Shop scan (which found ICMP timestamp at Low severity), the BadStore
scan produced zero findings at any actionable severity level. Every result is Log/informational.

**W4. Missing obvious misconfigurations**
Even without dynamic testing, a more thorough scanner could have detected:
- Directory listing enabled on multiple paths
- CGI scripts accessible without authentication
- Server-status/server-info endpoints potentially exposed
- Backup or configuration files in web root

---

## 7. Validity Concerns

### a) Training data bias
Not applicable. Deterministic signature-based scanning.

### b) State persistence
Not applicable. GVM does not modify target state.

### c) Flag verification
Not applicable. BadStore has no CTF flag system, and GVM does not interact with
application logic.

### d) Model/provider dependency
Not applicable. No LLM dependency.

### e) Tool utilization
GVM executed its full applicable plugin suite. The limitation is inherent to the
scanner's architecture, not its configuration.

### f) Target coverage
GVM's coverage of BadStore's vulnerability surface is effectively 0%. All of BadStore's
vulnerabilities are in application logic (CGI scripts, database queries, session handling)
which GVM cannot test.

---

## 8. Comparison Notes

### Cross-Tool (same target: BadStore)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (post-fix, 5 runs) | Strix (n=2) |
|--------|----------------|----------------------|------------------------|-------------|
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Findings (actionable) | 0 | 10/14 vuln categories exploited | 10 unique findings (mean 2.2/run) | 9 unique (mean 6.5/run) |
| Max CVSS | 0.0 | N/A (no CVSS scoring) | N/A (no CVSS scoring) | 10.0 (SQLi search + cart add) |
| Duration | 6m 44s | 10m 19s (mean) | ~4 min | ~45–60 min (est.) |
| Cost | $0.00 | $3.00/run ($15.00 total) | $0.133/run ($0.67 total) | ~$4.08/run (~$16.30 est. total) |
| SQLi Detected | No | Yes (all 5 runs) | Yes (2/5 runs) | Yes (3: search + login + cart add) |
| Webshell Upload | No | Yes (4/5 runs via sqlmap) | No | Not reported |
| Password Extraction | No | Yes (MD5 hashes via SQLi) | No | No |
| Report Quality | Template informational | Agent-written markdown | `/tmp/report.md` | Structured CVSS + PoC |

### Cross-Target (same scanner: GVM)

| Metric | Juice Shop | BadStore |
|--------|-----------|----------|
| Duration | 37m 50s | 6m 44s |
| NVT Results (post-filter) | 21 | 22 |
| Findings ≥ Low | 1 (ICMP, CVSS 2.1) | 0 |
| Findings ≥ Medium | 0 | 0 |
| Server Detected | Node.js (jQuery, Linux) | Apache/2.4.65 (Debian 13) |
| Security Headers Present | 3 (Feature-Policy, X-Content-Type-Options, X-Frame-Options) | 0 |
| Application Vulns Found | 0 | 0 |

> **Observation:** GVM ran 5.6x longer on Juice Shop than BadStore but found equally
> negligible results on both. The Juice Shop scan triggered more plugins due to its
> richer HTTP surface (more endpoints, Express framework responses) but still failed to
> detect any application-layer vulnerabilities. BadStore's complete absence of security
> headers was reported as informational only — not even flagged as Low severity.

---

## 9. Recommendations

- **Do not rely on GVM for web application security testing.** Both scans demonstrate
  that traditional network vulnerability scanners are fundamentally unsuited for detecting
  application-logic vulnerabilities in custom web applications.
- **Use GVM results to contextualize AI agent findings:** GVM's server fingerprinting
  (Apache 2.4.65, Debian 13, jQuery) and header audits provide infrastructure context
  that complements the application-layer findings from PentestGPT and Strix.
- **Include the GVM baseline in the thesis as a control:** The 0% application vulnerability
  detection rate across both targets provides a clear quantitative baseline that demonstrates
  the gap AI agents are addressing.
- **Consider noting the header audit gap:** Neither PentestGPT nor Strix explicitly reported
  on missing security headers, while GVM did. This suggests a potential complementary role
  for traditional scanners alongside AI agents.
- **For a fairer traditional-scanner comparison**, consider using OWASP ZAP or Burp Suite,
  which perform dynamic application security testing (DAST) and would be more comparable
  to AI agent capabilities.

---

## Data Sources

- `../scans/enhancements/badstore/badstore-gvm.txt` — GVM scan output (raw text report)
