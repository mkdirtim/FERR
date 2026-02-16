# GVM (Greenbone) — Juice Shop Baseline Scan Results

> **Context:** GVM (Greenbone Vulnerability Management, formerly OpenVAS) is a traditional
> network vulnerability scanner. It uses signature-based NVT (Network Vulnerability Tests)
> plugins to detect known CVEs and misconfigurations. It does **not** perform application-logic
> testing, authentication bypass, injection payload generation, or interactive exploitation.
> This scan serves as a **baseline** comparison for the autonomous AI agents (PentestGPT, Strix, CAI).

| Field | Value |
|-------|-------|
| **Target** | OWASP Juice Shop (v19.1.1) |
| **Total Challenges** | 110 |
| **Scanner** | GVM / Greenbone Vulnerability Management (OpenVAS) |
| **Model** | N/A (signature-based, no LLM) |
| **Provider** | N/A (self-hosted) |
| **Runs** | 1 |
| **Date** | 2026-02-11 |
| **Environment** | Docker network, scanner targeting `192.168.77.8` (`targets-juiceshop`) on port 3000/tcp |
| **Target Reset Between Runs** | N/A (single scan) |

---

## 1. Quantitative Results

### 1a. Per-Run Summary

| Run | NVT Checks | Findings (≥ Low) | Findings (≥ Medium) | Cost (USD) | Duration |
|-----|------------|-------------------|---------------------|------------|----------|
| 1 | 25 (pre-filter) / 21 (post-filter) | 1 (Low) | 0 | $0.00 | 37m 50s |

> **Extraction:**
>
> - **NVT Checks:** Report states "25 results before filtering" with "21 results selected"
>   by QoD ≥ 70 filter. Of these, 10 are shown in the report (pagination limit).
> - **Findings:** Host summary shows 0 Critical, 0 High, 0 Medium, 1 Low, 9 Log.
>   Only findings at Low severity or above constitute actionable vulnerabilities.
> - **Cost:** GVM is open-source and self-hosted. No API/LLM costs.
> - **Duration:** Scan started 17:29:22 UTC, ended 18:07:12 UTC = 37m 50s.

### 1b. Finding Detail

| NVT | Severity | CVSS | Port | CVE | Description |
|-----|----------|------|------|-----|-------------|
| ICMP Timestamp Reply Information Disclosure | Low | 2.1 | general/icmp | CVE-1999-0524 | Host responds to ICMP timestamp requests; could theoretically aid time-based attacks |
| Allowed HTTP Methods Enumeration (x2) | Log | 0.0 | 3000/tcp | — | GET,HEAD,POST,PUT,DELETE,OPTIONS,TRACE allowed |
| Check open ports (x2) | Log | 0.0 | 3000/tcp | — | Port 3000 detected as open then later appears closed (service crash or timing) |
| CPE Inventory | Log | 0.0 | general | — | Detected `cpe:/a:jquery:jquery`, `cpe:/o:linux:kernel` |
| Hostname Determination | Log | 0.0 | general | — | Forward DNS: `juiceshop`, Reverse DNS: `targets-juiceshop.openhackstack_openhackstack-network` |
| HTTP Security Headers Detection (x2) | Log | 0.0 | 3000/tcp | — | Present: `Feature-Policy`, `X-Content-Type-Options`, `X-Frame-Options`. Missing: CSP, COEP, COOP, CORP, Referrer-Policy, Permissions-Policy, and 8 others |
| IP Forwarding Enabled | Log | 0.0 | general/tcp | CVE-1999-0511 | IP forwarding enabled (Docker networking artifact) |

**Summary:** 1 Low-severity finding (ICMP timestamp, CVSS 2.1), 9 Log-level informational
results. Zero findings at Medium severity or above. No application-layer vulnerabilities detected.

### 1c. Command / Plugin Breakdown

GVM uses NVT (Network Vulnerability Test) plugins rather than CLI commands. Plugins executed
include:

| Plugin Category | Count | Description |
|-----------------|-------|-------------|
| Service Detection | 3 | Port scanning, service banner, HTTP server type |
| HTTP Analysis | 4 | HTTP methods enumeration, security headers check |
| Network Analysis | 2 | ICMP timestamp, IP forwarding |
| Asset Inventory | 1 | CPE inventory |

> GVM ran signature-based checks only. No authentication testing, no injection payloads,
> no dynamic application analysis.

### 1d. Time Budget Allocation

| Phase | Duration | Description |
|-------|----------|-------------|
| Port Scanning / Discovery | ~3 min | Initial host/port enumeration (17:29–17:32) |
| NVT Execution | ~32 min | Running all applicable vulnerability test plugins |
| Report Generation | ~3 min | Assembling and filtering results |

> The 38-minute scan duration is comparable to Strix's estimated ~38–58 min run time,
> but GVM's scan produced only informational findings whereas Strix found 7 exploitable
> vulnerabilities with PoCs.

---

## 2. Aggregate Statistics

| Metric | Value | Notes |
|--------|-------|-------|
| Total NVT Results | 21 (post-QoD filter) | 25 before filtering |
| Findings ≥ Medium | 0 | No actionable application vulnerabilities |
| Findings ≥ Low | 1 | ICMP timestamp (CVSS 2.1) — network-level, not application |
| Max CVSS | 2.1 | Minimal severity |
| Cost (USD) | $0.00 | Self-hosted, no LLM/API costs |
| Duration | 37m 50s | Single scan |

> **Scoring methodology:** GVM uses CVSS-based severity classification. With 0 findings
> at Medium or above, the scanner effectively found no exploitable vulnerabilities in the
> Juice Shop application layer.

---

## 3. Vulnerability Coverage

| Category | Detected? | Exploited? | Notes |
|----------|-----------|------------|-------|
| SQL Injection | No | N/A | GVM does not perform dynamic SQLi testing with custom payloads |
| XSS (Reflected) | No | N/A | GVM has limited XSS detection (signature-based only) |
| XSS (Stored/DOM) | No | N/A | No DOM interaction capability |
| CSRF | No | N/A | Not detected by network scanning |
| Directory Traversal | No | N/A | No path traversal testing performed |
| Auth Bypass | No | N/A | GVM does not test authentication logic |
| IDOR | No | N/A | Requires authenticated session and logic testing |
| Info Disclosure | Partial | N/A | Detected HTTP headers and CPE info, but missed /ftp/, /api/Challenges, /encryptionkeys/ |
| Broken Access Control | No | N/A | Requires application-level authorization testing |
| Cryptographic Issues | No | N/A | Did not detect JWT `alg=none` acceptance or weak password hashing |
| Injection (non-SQL) | No | N/A | No injection testing beyond signature matching |
| Security Misconfig | Partial | N/A | Detected missing security headers; missed directory listings, exposed APIs, debug endpoints |
| File Upload | No | N/A | Not tested |
| Other | — | — | Detected ICMP timestamp (network-level), IP forwarding (Docker artifact) |

> **Key limitation:** GVM operates at the network/protocol layer and cannot test application
> logic. All of the vulnerabilities found by PentestGPT and Strix (SQLi, IDOR, auth bypass,
> JWT manipulation, DOM XSS) require understanding application behavior — something a
> signature-based scanner fundamentally cannot do.

---

## 4. Attack Pattern Analysis

### Typical Sequence

GVM follows a fixed, deterministic scan pipeline:

1. **Host discovery:** ICMP ping, port scan
2. **Service detection:** Banner grabbing, HTTP server identification
3. **NVT execution:** Run all applicable plugins against detected services
4. **Report generation:** Aggregate and filter results by QoD threshold

There is no adaptive behavior, no exploitation, and no response-driven decision-making.
The scan is entirely signature-based and does not vary between runs.

### Termination Behavior

GVM terminates after all applicable NVT plugins have been executed. There is no
iteration budget, no self-assessment, and no exploration/exploitation tradeoff.
Scan duration is determined by the number of applicable plugins and network latency.

---

## 5. Strengths

**S1. Zero cost**
GVM is open-source and self-hosted. No per-scan API or LLM costs. Suitable for
continuous/scheduled scanning in CI/CD pipelines.

**S2. Deterministic and reproducible**
Signature-based scanning produces identical results on identical targets. No
stochastic variation from LLM sampling or prompt interpretation.

**S3. Broad network-level coverage**
GVM checks for known CVEs, protocol-level issues, and configuration problems
across all detected services. Useful for infrastructure-level assessments.

**S4. Security header audit**
Correctly identified missing security headers (CSP, Referrer-Policy, Permissions-Policy,
etc.) and present headers (X-Content-Type-Options, X-Frame-Options). This is useful
configuration hardening guidance that neither AI agent explicitly reported.

---

## 6. Weaknesses

**W1. Zero application-layer vulnerability detection**
GVM found 0 of the vulnerabilities that PentestGPT and Strix discovered (SQLi, IDOR,
auth bypass, JWT manipulation, XSS, file exposure). All of these require dynamic
application testing that GVM cannot perform.

**W2. No authentication or session testing**
GVM did not attempt to create accounts, log in, test authorization boundaries, or
interact with the application's API. It scanned only the unauthenticated network surface.

**W3. No injection or payload generation**
GVM does not construct SQL injection payloads, XSS vectors, path traversal sequences,
or any other dynamic attack content. It relies entirely on known vulnerability signatures.

**W4. False sense of security**
The scan report shows 0 Critical/High/Medium findings, which could mislead a reviewer
into believing the application is secure. In reality, Juice Shop contains 110 deliberately
planted vulnerabilities, including multiple Critical-severity issues.

**W5. Missed known exposed resources**
GVM did not detect the publicly accessible `/ftp/` directory listing, the exposed
`/api/Challenges` endpoint, the `/encryptionkeys/` directory, or the `/metrics` endpoint —
all of which are discoverable via simple HTTP requests without authentication.

---

## 7. Validity Concerns

### a) Training data bias
Not applicable. GVM uses deterministic NVT plugins, not learned models.

### b) State persistence
Not applicable for a single scan. GVM does not modify target state.

### c) Flag verification
Not applicable. GVM does not interact with the CTF flag system.

### d) Model/provider dependency
Not applicable. GVM is a self-hosted, signature-based scanner with no LLM dependency.

### e) Tool utilization
GVM executed its full plugin suite against the target. The scanner's capabilities are
inherently limited to signature-based detection — it cannot perform dynamic testing,
logic analysis, or interactive exploitation regardless of configuration.

### f) Target coverage
GVM can only detect vulnerabilities that match known NVT signatures. For a deliberately
vulnerable web application like Juice Shop, where vulnerabilities are in application logic
rather than known CVEs in specific software versions, GVM's coverage is effectively 0%.
The only finding (ICMP timestamp) is a network-level issue unrelated to the application.

---

## 8. Comparison Notes

### Cross-Tool (same target: Juice Shop)

| Metric | GVM (baseline) | PentestGPT (5 runs) | CAI (post-fix, 5 runs) | Strix (n=2) |
|--------|----------------|----------------------|------------------------|-------------|
| Type | Signature scanner | AI agent (LLM) | AI agent (LLM) | AI agent (LLM) |
| Vulnerabilities Found | 0 (app-layer) | 0 verified flags; ~9 categories exploited | 5 unique findings (passive) | 15 unique (mean 10.5/run) |
| Max CVSS | 2.1 (ICMP timestamp) | N/A (no CVSS scoring) | N/A (no CVSS scoring) | 10.0 (SQLi search) |
| Duration | 37m 50s | 7m 17s (mean) | ~6 min | ~45–60 min (est.) |
| Cost | $0.00 | $2.49/run ($12.46 total) | $0.057/run ($0.28 total) | ~$4.08/run (~$16.30 est. total) |
| Browser Capability | No | No | No | Yes |
| Dynamic Testing | No | Yes (curl-based) | Yes (curl-based recon) | Yes (browser + proxy + terminal) |
| Injection Testing | No | Yes (manual payloads) | No | Yes (validated PoCs) |
| Auth Testing | No | Yes (SQLi login bypass) | No | Yes (SQLi + JWT bypass + mass assignment) |
| Report Quality | Template-based, informational | Agent-written markdown | `/tmp/report.md` | Structured CVSS + PoC |
| False Negative Risk | Very High (for app-logic vulns) | Medium (limited tool use) | High (recon-only, no exploitation) | Low (broad tool surface) |

**Key insight:** GVM and the AI agents test fundamentally different things. GVM checks for
known CVEs in detected software versions; AI agents test application logic and behavior.
For a deliberately vulnerable web application with no known CVE-tracked software flaws,
GVM is essentially blind while AI agents can discover and exploit the intended vulnerabilities.

---

## 9. Recommendations

- **Do not use GVM as the sole security assessment tool** for custom web applications.
  Its strength is infrastructure/CVE scanning, not application security testing.
- **Use GVM as a complementary baseline:** Its security header audit and service detection
  provide useful context that AI agents may not explicitly report.
- **Consider DAST alternatives:** For traditional scanner comparison, tools like OWASP ZAP
  or Burp Suite (which perform dynamic application testing) would provide a more meaningful
  baseline than GVM's network-focused approach.
- **Acknowledge the coverage gap in the thesis:** GVM's 0% application vulnerability detection
  rate illustrates why AI-driven agents represent a significant capability improvement over
  traditional scanners for application security testing.

---

## Data Sources

- GVM scan output (raw text report) — originally at `data/projects/scans/juiceshop/manual/gvm.txt`; raw manual scan files were removed during the flat-structure migration. Findings are preserved in this analysis file.
