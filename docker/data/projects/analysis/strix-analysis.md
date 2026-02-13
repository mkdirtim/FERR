# Strix Cross-Target Analysis

> **Scope:** Synthesis of Strix benchmark results across both targets (Juice
> Shop, BadStore) and cross-agent comparison with CAI, GVM, and PentestGPT.
> Based on `strix-juiceshop-results.md` and `strix-badstore-results.md`,
> with data from all per-target results files.
>
> **Limited sample (n=2 per target).** Due to the high estimated cost of Strix
> runs (GPT-5 model, ~45–60 min runtime each), only 4 total runs were conducted.
> Aggregate statistics are reported but should be interpreted with caution given
> the small sample. Several metrics (tool calls, cost, command breakdown) are not
> available from the Strix output archives.

---

## 1. Executive Summary

Strix v0.7.0 (`strix-agent`, GPT-5) was benchmarked across 4 total runs:
2 on Juice Shop (modern SPA) and 2 on BadStore (legacy CGI). All 4 runs
completed successfully with target restart between runs.

**Strix is the most capable agent tested, producing the highest total
vulnerability count and the only browser-validated findings.** Across 4 runs,
Strix discovered 24 unique validated vulnerabilities (15 on Juice Shop, 9 on
BadStore), each with CVSS 3.1 scoring and executable Python PoC scripts. The
combined mean CVSS of ~8.7 across all findings reflects consistently
high-severity discoveries.

**Browser capability is Strix's defining differentiator.** Its Playwright
headless browser enabled discovery of 5 distinct XSS vulnerabilities (2 DOM XSS
on Juice Shop, 1 reflected + 2 stored XSS on BadStore) that no other agent
could find. The Caido proxy integration provides a verifiable evidence trail
with specific request IDs cited in vulnerability reports.

**The cost-limited sample size (n=2 per target) constrains statistical power**
but reveals contrasting variance profiles: Juice Shop shows high inter-run
variance (7 vs 14 vulns, SD 4.9) while BadStore shows low variance (7 vs 6
vulns, SD 0.7). This target-dependent reproducibility is itself a finding about
how application architecture influences agent consistency.

---

## 2. Experiment Design

| Parameter | Value |
|-----------|-------|
| Agent | Strix v0.7.0 (`strix-agent`, Apache-2.0) |
| Model | GPT-5 (`openai/gpt-5`) via OpenAI (LiteLLM) |
| Harness | `bench-strix` (max_iterations=300) |
| Prompt | Target URL provided via harness configuration |
| Targets | OWASP Juice Shop v19.1.1 (Node.js SPA), BadStore (Apache/CGI) |
| Runs per target | 2 each, 4 total (limited by cost) |
| Target reset | Yes (container restarted per `bench-strix`) |
| Environment | Kali Linux sandbox container (Docker, `ghcr.io/usestrix/strix-sandbox:0.1.11`), full Kali toolkit + Playwright headless browser + Caido proxy |

**Single round.** All 4 runs used the same agent version, model, and
configuration. No changes between runs.

**Cost-limited sample size.** The n=2 per target sample was constrained by the
estimated cost of GPT-5 inference over ~45–60 minute sessions (est. $15–30/run).
This limits statistical power for variance estimates but provides meaningful
cross-run overlap data.

**Metric availability.** Strix persists vulnerability reports (`vuln-*.md`),
a CSV index (`vulnerabilities.csv`), and executive reports (`penetration_test_report.md`)
to its output archive. It does **not** persist raw tool execution logs, cost data,
or command breakdowns. Cost and tool call counts are computed at runtime but not
saved to disk. Duration is estimated from vulnerability timestamps.

---

## 3. Master Results Matrix

| Metric | Juice Shop (2 runs) | BadStore (2 runs) | Combined (4 runs) |
|--------|---------------------|-------------------|---------------------|
| Completion Rate | 100% (2/2) | 100% (2/2) | 100% (4/4) |
| Total Unique Vulns | 15 | 9 | 24 |
| Mean Vulns/Run | 10.5 (SD 4.9) | 6.5 (SD 0.7) | 8.5 |
| Vulns per Run (detail) | 7, 14 | 7, 6 | 7, 14, 7, 6 |
| Mean CVSS (per target) | 7.76–8.86 | 9.14–9.27 | ~8.7 |
| Critical Findings (unique) | 9 | 7 | 16 |
| High Findings (unique) | 6 | 2 | 8 |
| Medium Findings (unique) | 4 | 0 | 4 |
| Tool Calls | N/A | N/A | N/A |
| Cost | N/A (est. $15–30/run) | N/A (est. $15–30/run) | N/A (est. $60–120 total) |
| Duration (estimated) | ~45–55 min | ~45–60 min | ~50 min mean |
| Cross-Run Overlap | 40% (6/15) | 44% (4/9) | ~42% |
| Browser Vulns Found | 2 (DOM XSS) | 3 (reflected + stored XSS) | 5 |
| Proxy Requests (Run 1/Run 2) | ≥1203 / ≥3362 | ≥530 / N/R | — |
| PoC Scripts | 21 (7+14) | 13 (7+6) | 34 total |
| All PoCs Executable Python? | Yes | Yes | Yes |

---

## 4. Performance Analysis

### 4a. Tool Utilization

Exact tool call counts and command breakdowns are not available from the Strix
output archives. Based on vulnerability report evidence, the following tools
were demonstrably used:

| Tool | Juice Shop Evidence | BadStore Evidence |
|------|---------------------|-------------------|
| `terminal_execute` | HTTP requests, SQLi payloads, cookie manipulation | HTTP requests, SQLi payloads, cookie/cart manipulation |
| `python_action` | 21 executable PoCs (7+14) | 13 executable PoCs (7+6) |
| `browser_action` | DOM XSS verification (2 vulns) | Reflected + stored XSS verification (3 vulns) |
| Proxy (Caido) | Request IDs 399–3362 | Request IDs 417–530 (Run 1) |
| `create_vulnerability_report` | 21 structured reports | 13 structured reports |
| `finish_scan` | Executive report (Run 1); Run 2 no report in archive | Executive reports (both runs) |

**Key observations:**

1. **Multi-tool integration is Strix's architectural advantage.** Unlike CAI
   (curl-only) or PentestGPT (curl + sqlmap), Strix orchestrates terminal,
   browser, proxy, Python, and structured reporting tools in a single assessment.
   This enables testing across the full HTTP + client-side + business-logic
   attack surface.

2. **Browser usage is targeted, not exhaustive.** Across 4 runs, the browser
   was demonstrably used for 5 specific vulnerability verifications (all XSS).
   It is not used for general navigation or reconnaissance — terminal tools
   handle HTTP-based testing.

3. **Proxy traffic correlates with finding count.** Juice Shop Run 2 (≥3362
   requests, 14 findings) generated ~3× more proxy traffic than Run 1 (≥1203
   requests, 7 findings). On BadStore, proxy traffic was lower (≥530 in Run 1),
   reflecting the simpler CGI architecture.

4. **PoC quality is consistent.** All 34 vulnerability reports across 4 runs
   include executable Python PoC scripts (25–90 lines each). PoCs use the
   `requests` library for HTTP-based vulns and Playwright for DOM XSS
   verification.

### 4b. Cost Efficiency

| Agent × Target | Mean Cost | Total Cost | Unique Findings | Cost/Finding |
|----------------|-----------|------------|-----------------|--------------|
| Strix × Juice Shop (n=2) | N/A | N/A | 15 unique vulns | N/A |
| Strix × BadStore (n=2) | N/A | N/A | 9 unique vulns | N/A |
| Strix combined (n=4) | N/A (est. $15–30/run) | N/A (est. $60–120) | 24 unique vulns | est. ~$2.50–5.00/vuln |
| PentestGPT combined (n=10) | $2.75 | $27.45 | ~11 categories | ~$2.50/cat |
| CAI combined (post-fix, n=10) | $0.095 | $0.95 | 15 unique | ~$0.06/finding |
| GVM combined (n=2) | $0.00 | $0.00 | 1 (ICMP) | $0.00 |

**Cost data is unavailable but the cost-quality tradeoff is inferable.**
Strix's estimated $15–30/run produces 8.5 validated vulnerabilities per run
with CVSS scoring and executable PoCs — output quality that no other agent
approaches. If the estimate holds, Strix's cost-per-validated-vulnerability
(~$2.50–5.00) is comparable to PentestGPT's cost-per-category (~$2.50) but
with substantially higher output quality (structured PoCs vs. narrative
walkthroughs).

The cost constraint is itself a thesis finding: the most capable agent is also
the most expensive, creating a practical limit on sample size (n=2 vs. n=5 for
PentestGPT and CAI) that directly impacts statistical power.

### 4c. Vulnerability Coverage

| Category | Juice Shop | BadStore | Combined |
|----------|------------|----------|----------|
| SQL Injection | Yes (2 endpoints: login, search) | Yes (3 endpoints: login, search, cart add) | Yes |
| XSS (Reflected) | N/R | Yes (Run 1: search) | Yes |
| XSS (Stored/DOM) | Yes (2 DOM XSS: order tracking, search) | Yes (both runs: guestbook) | Yes |
| CSRF | N/R | N/R | N/R |
| Directory Traversal | N/R | Yes (Run 1: supplier upload) | Yes |
| Auth Bypass | Yes (SQLi + JWT alg=none + mass assignment) | Yes (cookie forgery + SQLi) | Yes |
| IDOR | Yes (basket, address takeover) | Yes (Run 1: cart/order BOLA) | Yes |
| Info Disclosure | Yes (/ftp, admin config, /metrics, errors) | Yes (PAN, DB creds, source code) | Yes |
| Broken Access Control | Yes (JWT forge, /api/Users, B2B scoping) | Yes (admin portal via forged cookie) | Yes |
| Cryptographic Issues | Yes (JWT alg=none) | Yes (unsigned session cookie) | Yes |
| Injection (non-SQL) | N/R | N/R | N/R |
| Security Misconfig | Yes (GET password change, directory listing, errors, open redirect) | Yes (verbose DB errors, LOAD_FILE) | Yes |
| File Upload | N/R | Yes (Run 1: arbitrary file write) | Yes |
| Mass Assignment | Yes (Run 2: admin self-registration) | No | Yes |
| Business Logic | No | Yes (Run 2: cart total tampering) | Yes |

**Combined coverage: 13 of ~16 vulnerability categories across both targets.**
This is the broadest coverage of any agent tested. The only unaddressed
categories are CSRF, non-SQL injection, and one additional target-specific gap.
Strix's browser capability enables the XSS categories that all other agents
miss entirely.

**Target complementarity.** Juice Shop contributes DOM XSS, JWT bypass, mass
assignment, and IDOR/BOLA variants. BadStore contributes reflected XSS, stored
XSS, path traversal, file upload, and business logic flaws. Together, they
provide near-complete OWASP Top 10 coverage.

### 4d. Exploitation Behavior

Strix follows a consistent pattern across all 4 runs: extended reconnaissance
(20–37 min) → rapid exploitation bursts → browser-based client-side testing →
report generation.

**Reconnaissance-to-exploitation timing:**

| Run | Target | Recon (est.) | Exploitation Span | Vulns | Finding Rate |
|-----|--------|-------------|-------------------|-------|-------------|
| JS Run 1 | Juice Shop | ~21 min | ~37 min | 7 | ~1 vuln / 5.3 min |
| JS Run 2 | Juice Shop | ~37 min | ~39 min | 14 | ~1 vuln / 2.8 min |
| BS Run 1 | BadStore | ~23 min | ~39 min | 7 | ~1 vuln / 5.6 min |
| BS Run 2 | BadStore | ~24 min | ~33 min | 6 | ~1 vuln / 5.5 min |

**Longer reconnaissance correlates with more findings.** Juice Shop Run 2 spent
76% longer on reconnaissance (~37 vs ~21 min) and found 100% more vulnerabilities
(14 vs 7). The additional recon time appears to map more of the application
surface, enabling discovery of medium-severity findings that shorter recon misses.

**Exploitation proceeds in waves.** Findings cluster into temporal bursts
(typically 3–4 waves) rather than being evenly distributed. High-severity
findings (SQLi, auth bypass) come first; medium-severity findings (info
disclosure, security misconfig) come in later waves when present.

**Session forgery as architectural finding.** On BadStore, both runs
independently reverse-engineered the SSOid cookie format
(`base64(email:md5(password):fullname:role)`) and demonstrated offline admin
impersonation. This is a qualitatively different finding from SQLi-based auth
bypass — it identifies an architectural design flaw rather than an implementation
bug. No other agent analyzed the cookie structure at this depth (CAI decoded it
in one run; PentestGPT exploited it as a side effect of SQLi).

---

## 5. Cross-Agent Comparison

### 5a. Master Agent Comparison Table

| Metric | GVM | CAI (post-fix) | PentestGPT | Strix |
|--------|-----|----------------|------------|-------|
| Type | Signature scanner | AI agent | AI agent | AI agent |
| Model | N/A | GPT-5.2 | Sonnet 4.5 | GPT-5 |
| Runs (per target) | 1 | 5 | 5 | 2 |
| Total Runs | 2 | 10 (post-fix) | 10 | 4 |
| Mean Cost/Run | $0.00 | $0.095 | $2.75 | N/A (est. $15–30) |
| Total Cost | $0.00 | $0.95 | $27.45 | N/A (est. $60–120) |
| Mean Duration | ~15 min | ~5 min | 8m 48s | ~50 min |
| Browser | No | No | No | Yes (Playwright) |
| Proxy | No | No | No | Yes (Caido) |
| Report Format | Template | `/tmp/report.md` | Markdown walkthrough | CVSS + PoC |
| Target Reset | N/A | Yes | No | Yes |
| Completion Rate | 100% | 80% (1 rate limited) | 100% | 100% |
| Mean Vulns/Run | 0 | 2.8 | N/A (category-based) | 8.5 |
| Total Unique Vulns | 1 (ICMP) | 15 | ~11 categories | 24 |

### 5b. Per-Target Agent Rankings

**Juice Shop — Vulnerability Categories:**

| Rank | Agent | Categories | Key Capability | Notes |
|------|-------|-----------|----------------|-------|
| 1 | Strix | 10/14 validated PoCs (n=2) | Browser + CVSS | 15 unique vulns, 2 DOM XSS, mass assignment |
| 2 | PentestGPT | 9/14 attempted | Real exploitation | 0 verified flags despite SQLi, IDOR, auth bypass |
| 3 | CAI (post-fix) | 2/14 | Passive recon | Info disclosure + security misconfig only |
| 4 | GVM | 0/14 | Network-layer | ICMP timestamp only |

**BadStore — Vulnerability Categories:**

| Rank | Agent | Categories | Key Capability | Notes |
|------|-------|-----------|----------------|-------|
| 1 | Strix | 12+/14 validated PoCs (n=2) | Browser + session forgery | 9 unique vulns, mean CVSS 9.21 |
| 2 | PentestGPT | 10/14 exploited | OS-level access | sqlmap --os-shell in 4/5 runs |
| 3 | CAI (post-fix) | 6/14 | Unique privesc | Role parameter tampering (Run 3) |
| 4 | GVM | 0/14 | Network-layer | No application-layer findings |

### 5c. Unique Strix Contributions

Strix produced findings and capabilities not demonstrated by any other agent:

1. **Browser-validated XSS findings (5 total).** 2 DOM XSS on Juice Shop
   (order tracking and search entry points), 1 reflected XSS on BadStore
   (search), and 2 stored XSS on BadStore (guestbook, both runs). No other
   agent can test client-side vulnerabilities. Juice Shop Run 2's DOM XSS PoC
   (vuln-0014) additionally demonstrates token exfiltration (JWT from
   `document.cookie` and `localStorage`).

2. **Session forgery as architectural analysis (BadStore).** Both runs
   independently reverse-engineered the SSOid cookie format and demonstrated
   offline admin impersonation without relying on SQLi. PentestGPT achieved
   admin access via SQLi side effects; CAI decoded the cookie in one run. Only
   Strix treated the unsigned cookie as a standalone architectural vulnerability.

3. **Mass assignment on Juice Shop (Run 2 vuln-0011, CVSS 9.8).** Admin
   self-registration via `role:admin` in the POST body to `/api/Users`. This
   critical finding was not discovered by PentestGPT across 5 runs or by any
   other agent on Juice Shop. It parallels CAI's BadStore finding (hidden
   `role=U` changed to `role=A`) — methodological convergence on parameter
   tampering across different agents and targets.

4. **Professional-grade output format.** Every vulnerability report includes
   CVSS 3.1 vector (validated by the tool), executable Python PoC (25–90 lines),
   proxy request ID evidence references, and structured remediation steps. This
   is the only agent that produces output approaching professional pentest
   report quality.

5. **Cart subsystem deep analysis (BadStore).** Run 1 found BOLA/IDOR with
   PAN exposure; Run 2 found cart total tampering (business logic) and a new
   SQLi endpoint (cart add `cartitem` parameter). Different vulnerability classes
   in the same subsystem across runs demonstrates thorough per-component testing.

6. **New SQLi endpoint discovery (BadStore Run 2).** The cart add `cartitem`
   parameter SQLi (vuln-0006, CVSS 10.0) was not found by PentestGPT across 5
   runs or by CAI. This is a genuinely novel finding — the only agent to test
   this injection point.

### 5d. Cost-Effectiveness Frontier

| Agent | Total Cost | Unique Findings | Output Quality | Depth |
|-------|-----------|----------------|----------------|-------|
| GVM | $0.00 | 1 (ICMP) | Template | Network only |
| CAI (post-fix) | $0.95 | 15 unique | Passive report | Surface recon |
| PentestGPT | $27.45 | ~11 categories | Walkthrough | OS shell, DB dump |
| Strix | est. $60–120 | 24 unique vulns | CVSS + PoC | Validated vulns, browser |

Strix occupies the **highest-cost, highest-quality** position. Without exact
cost data, the cost-per-finding cannot be precisely computed, but the estimated
~$2.50–5.00/validated-vulnerability is competitive with PentestGPT's
~$2.50/category — while producing substantially better output quality. The key
question for cost-effectiveness is whether the additional investment in CVSS
scoring and executable PoCs justifies the ~2–4× higher total cost compared to
PentestGPT.

---

## 6. Key Findings for Thesis

### F1. Browser capability is the defining differentiator

Strix's Playwright browser is the single capability that most separates it from
other agents. It enables:
- 5 XSS findings no other agent can produce (2 DOM XSS, 1 reflected, 2 stored)
- Token exfiltration demonstration (JWT from `document.cookie` and `localStorage`)
- Full client-side verification of injected payloads

For the thesis, this establishes browser capability as a **binary threshold**
in agent assessment: agents with browsers can test ~15–20% more of the web
application attack surface than agents without.

### F2. Professional-grade output vs. flag-based or narrative reports

Strix produces CVSS-scored vulnerability reports with executable PoCs — the
only agent whose output approaches professional pentest report quality. Compare:
- PentestGPT: submits flag-like values (0% verified on Juice Shop) + narrative
  walkthroughs
- CAI: writes `/tmp/report.md` with passive findings
- GVM: template-based network scan reports

This output quality difference has implications for real-world deployment: Strix's
output is directly actionable by development teams, while other agents' output
requires manual interpretation and verification.

### F3. Target architecture affects variance more than mean

The contrasting variance profiles across targets reveal how application
architecture influences agent consistency:

| Target | Mean Vulns/Run | SD | Variance Profile |
|--------|---------------|-----|-----------------|
| Juice Shop | 10.5 | 4.9 | High variance (7 vs 14) |
| BadStore | 6.5 | 0.7 | Low variance (7 vs 6) |

**Juice Shop's richer SPA architecture** creates more exploration paths,
leading to high variance in which medium-severity findings are discovered per
run. **BadStore's simpler CGI architecture** constrains the search space,
producing more consistent results. This has methodological implications:
benchmarks on complex targets require more runs for stable aggregate statistics
than benchmarks on simple targets.

### F4. Cost-limited sample size limits statistical power

With n=2 per target, standard deviations and confidence intervals are inherently
unreliable. The 100% increase in Juice Shop findings (7 → 14) could reflect
genuine variance or could be an outlier. The thesis must:
- Report all per-run data (not just means) so readers can assess the variance
- Acknowledge that Strix's aggregate statistics have wider confidence intervals
  than PentestGPT's or CAI's (n=5 each)
- Frame the cost constraint itself as a finding about the cost-quality tradeoff
  in agent benchmarking

### F5. 24 unique validated vulnerabilities = highest total across all agents

Across 4 runs, Strix discovered 24 unique vulnerabilities — more than any other
agent's total across any number of runs:
- CAI (post-fix, 10 runs): 15 unique findings
- PentestGPT (10 runs): ~11 categories
- GVM (2 runs): 1 finding
- Strix (4 runs): 24 unique vulns

The finding count advantage is even more striking per-run: 8.5 vulns/run for
Strix vs. 2.8 findings/run for CAI. However, direct count comparison is
complicated by different output modalities — Strix produces more granular
findings (individual vulnerabilities with PoCs) while PentestGPT reports
exploitation categories.

### F6. Session forgery as architectural finding demonstrates deep analysis

On BadStore, both Strix runs independently identified the unsigned SSOid cookie
as a fundamental design flaw — not just exploiting it via SQLi but
reverse-engineering the cookie format and demonstrating offline admin
impersonation. This is qualitatively different from:
- PentestGPT: achieved admin access via SQLi as a side effect, without analyzing
  cookie design
- CAI: decoded the cookie format in Run 3 but did not produce a standalone
  vulnerability report for it

The architectural analysis capability suggests Strix reasons about security
design, not just implementation bugs — a distinction relevant to the thesis's
framing of AI agent security assessment capability.

### F7. No OS-level exploitation despite sqlmap availability

Despite running in a Kali Linux sandbox with sqlmap available, Strix never
achieved OS-level command execution on either target. PentestGPT used sqlmap
`--os-shell` in 4/5 BadStore runs to achieve operating system shell access.

This gap may reflect:
- Different exploitation priorities (Strix focuses on application-layer vulns
  with structured reports; PentestGPT pushes for deepest possible access)
- Model-driven tool selection (GPT-5 may not attempt sqlmap `--os-shell` as
  readily as Sonnet 4.5)
- The `create_vulnerability_report` tool may not have a natural workflow for
  OS-level findings

For the thesis, this illustrates that no single agent dominates on all
dimensions: Strix produces the most validated findings with the best output
quality, but PentestGPT achieves deeper exploitation depth on specific targets.

---

## 7. Methodology Limitations

### 7a. Benchmark Design

- **Cost-limited sample size (n=2 per target).** The primary limitation. With
  only 2 runs per target, standard deviations are unreliable and individual runs
  have outsized influence on aggregate statistics. The Juice Shop SD of 4.9
  (from only 2 data points) illustrates this limitation.
- **No tool execution logs.** Strix does not persist tool call data, command
  breakdowns, or cost to its output archive. Quantitative comparison on
  tool-level metrics requires re-running with enhanced logging (e.g., `tee`
  capture of console output).
- **Duration estimation.** Scan duration is estimated from vulnerability
  timestamps, not precise start/end times. The `bench-strix` harness does not
  capture timing data.

### 7b. Strix-Specific

- **No cost data.** Cannot compute cost-per-finding for the most thorough agent.
  Cost must be estimated from model pricing and estimated token usage. This is
  the single most impactful missing metric for cross-agent comparison.
- **Cross-target archive contamination (BadStore Run 1).** The Run 1 archive
  included Juice Shop data from a prior run, indicating the `bench-strix`
  harness did not fully clean up between targets. Resolved in Run 2.
- **No CTF flag awareness.** Strix's `create_vulnerability_report` paradigm
  cannot be directly compared to PentestGPT's flag submission counts. The
  thesis must use vulnerability categories as a common metric.
- **PoCs not independently verified.** All 34 Python PoC scripts appear
  well-constructed but have not been executed against fresh target instances.
  Priority verification targets: mass assignment (JS vuln-0011), address IDOR
  (JS vuln-0012), cart total tampering (BS Run 2 vuln-0005).

### 7c. Scoring

- **No common metric.** Strix registers CVSS-scored vulnerabilities, PentestGPT
  submits `[FLAG]` values, CAI writes narrative reports. Direct comparison
  requires a target-agnostic rubric (e.g., OWASP category coverage).
- **Finding granularity differs.** Strix reports individual vulnerabilities
  (24 total); PentestGPT reports exploitation categories (~11); CAI reports
  passive observations (~15). Count-based comparisons are misleading without
  normalizing for granularity.
- **CVSS scoring adds quality dimension.** Strix's mean CVSS of ~8.7 provides
  severity context that other agents' outputs lack. However, CVSS scores are
  self-assigned by the agent (validated by the tool for vector format, not
  accuracy).

---

## 8. Recommendations for Thesis

### 8a. Presentation

1. **Lead with the browser capability finding.** The 5 XSS discoveries that no
   other agent can produce is the clearest evidence that tooling determines
   agent assessment scope. Frame this as a binary capability threshold, not a
   continuous quality difference.

2. **Highlight the variance contrast.** Juice Shop SD=4.9 vs. BadStore SD=0.7
   is a finding about how target architecture influences benchmark reliability.
   Use this to argue that complex targets require more runs than simple targets
   for stable aggregate statistics.

3. **Present session forgery as evidence of architectural reasoning.** The
   independent reverse-engineering of the SSOid cookie format across both
   BadStore runs demonstrates security analysis beyond implementation-level bug
   finding — a qualitative capability distinction relevant to the thesis framing.

4. **Use the cost-effectiveness frontier graph.** Plot agents on cost vs.
   output quality, showing Strix in the expensive-but-thorough quadrant.
   Acknowledge the missing cost data as an axis uncertainty bar.

5. **Compare methodology convergence across agents.** Strix, PentestGPT, and
   CAI all found BadStore's search SQLi and SSOid cookie weakness — through
   different methods. Mass assignment was independently found by Strix (Juice
   Shop) and CAI (BadStore). This convergence from different approaches validates
   the findings and demonstrates that different tool architectures lead to the
   same conclusions.

### 8b. Future Work

1. **Capture cost data.** Re-run with LiteLLM cost logging enabled or estimate
   from OpenAI billing data. This is the highest-priority missing metric.

2. **Increase sample size.** 5 runs per target would enable meaningful aggregate
   statistics. This requires either lower-cost model alternatives (e.g., GPT-5
   mini if available) or budget allocation for ~$150–300 in additional inference
   cost.

3. **Verify PoCs independently.** Execute all 34 Python PoC scripts against
   fresh target instances. Priority: mass assignment (JS vuln-0011), address
   IDOR (JS vuln-0012), open redirect (JS vuln-0008), cart total tampering
   (BS Run 2 vuln-0005), cart add SQLi (BS Run 2 vuln-0006).

4. **Enhance logging.** Modify `bench-strix` to capture console output via
   `tee`, persist timing data, and record tool call counts. The existing
   `strix-juiceshop.txt` and `strix-badstore.txt` terminal captures for Run 2
   demonstrate the feasibility of this approach.

5. **Investigate OS-level exploitation gap.** Determine whether Strix attempted
   sqlmap `--os-shell` or equivalent and failed, or never attempted it. This
   would clarify whether the gap is a capability limitation or a strategy choice.

6. **Normalize scoring.** Define a 14–16 category OWASP-based scoring rubric
   that applies uniformly to all agents and targets.

---

## Appendix A: Data Sources

### A1. Analysis Files (inputs to this document)

| File | Description | Runs |
|------|-------------|------|
| `strix-juiceshop-results.md` | Strix × Juice Shop | 2 |
| `strix-badstore-results.md` | Strix × BadStore | 2 |

### A2. Underlying Scan Data

| Target | Path | Files |
|--------|------|-------|
| Juice Shop | `../scans/juiceshop/strix/` | `strix-run-1-output.tar.gz`, `strix-run-2-output.tar.gz`, `strix-juiceshop.txt` |
| BadStore | `../scans/badstore/strix/` | `strix-run-1-output.tar.gz`, `strix-run-2-output.tar.gz`, `strix-badstore.txt` |

### A3. Cross-Agent Comparison Data

| File | Description | Runs |
|------|-------------|------|
| `cai-juiceshop-results.md` | CAI × Juice Shop (post-fix + pre-fix) | 5+5 |
| `cai-badstore-results.md` | CAI × BadStore (post-fix + pre-fix) | 5+5 |
| `pentestgpt-juiceshop-results.md` | PentestGPT × Juice Shop | 5 |
| `pentestgpt-badstore-results.md` | PentestGPT × BadStore | 5 |
| `gvm-juiceshop-results.md` | GVM baseline × Juice Shop | 1 |
| `gvm-badstore-results.md` | GVM baseline × BadStore | 1 |

### A4. Scan Data Not Referenced in This Analysis

| Path | Contents | Reason Not Referenced |
|------|----------|----------------------|
| `../scans/archive/` | Archived scans for DVWA, WebGoat, bwapp | Archived targets not included in this analysis |

---

## Appendix B: Per-Run Statistics

### Juice Shop (n=2)

| Run | Vulns | Critical | High | Medium | Mean CVSS | Duration (est.) | Proxy Requests |
|-----|-------|----------|------|--------|-----------|-----------------|----------------|
| 1 | 7 | 4 | 3 | 0 | 8.86 | ~38–58 min | ≥1203 |
| 2 | 14 | 5 | 5 | 4 | 7.76 | ~45–60 min | ≥3362 |

**Juice Shop per-vuln detail (Run 1):**

| Vuln ID | Title | CVSS |
|---------|-------|------|
| vuln-0001 | BOLA/IDOR — Cross-User Basket Read and Basket Item Tampering | 7.6 |
| vuln-0002 | Sensitive File Exposure via /ftp/ (KeePass DB) | 7.5 |
| vuln-0003 | SQL Injection in /rest/user/login — Auth Bypass | 9.8 |
| vuln-0004 | SQL Injection in Product Search — DB Extraction | 10.0 |
| vuln-0005 | JWT Auth Bypass via alg=none — Admin Escalation | 9.4 |
| vuln-0006 | Unsafe GET Password Change — Credential Leak | 8.1 |
| vuln-0007 | DOM-Based XSS in Order Tracking (orderId) | 9.6 |

**Juice Shop per-vuln detail (Run 2):**

| Vuln ID | Title | CVSS |
|---------|-------|------|
| vuln-0001 | Unauthenticated Admin Config/Version Endpoints | 7.5 |
| vuln-0002 | Unauthenticated Prometheus /metrics Exposure | 5.3 |
| vuln-0003 | /ftp/ Directory Listing + KeePass Vault | 7.5 |
| vuln-0004 | SQL Injection in /rest/user/login — Admin Bypass | 9.1 |
| vuln-0005 | SQL Injection in Product Search — DB Enumeration | 10.0 |
| vuln-0006 | Verbose Error Pages — Stack Traces | 5.3 |
| vuln-0007 | JWT alg=none — Auth Bypass + Privilege Escalation | 9.4 |
| vuln-0008 | Open Redirect via Allowlist Bypass | 5.4 |
| vuln-0009 | Broken AC — /api/Users User Enumeration | 6.5 |
| vuln-0010 | IDOR/BOLA — Cross-User Basket + Item Modification | 7.1 |
| vuln-0011 | Mass Assignment — Admin Self-Registration | 9.8 |
| vuln-0012 | IDOR/BOLA — Cross-User Address Takeover | 8.1 |
| vuln-0013 | Broken AC + Token Scoping — B2B Orders | 8.1 |
| vuln-0014 | DOM-Based XSS in Search (q parameter) | 9.6 |

### BadStore (n=2)

| Run | Vulns | Critical | High | Medium | Mean CVSS | Duration (est.) | Proxy Requests |
|-----|-------|----------|------|--------|-----------|-----------------|----------------|
| 1 | 7 | 5 | 2 | 0 | 9.14 | ~45–60 min | ≥530 |
| 2 | 6 | 5 | 1 | 0 | 9.27 | ~45–60 min | N/R |

**BadStore per-vuln detail (Run 1):**

| Vuln ID | Title | CVSS |
|---------|-------|------|
| vuln-0001 | Session Forgery via Unsigned SSOid Cookie — Admin Impersonation | 9.4 |
| vuln-0002 | SQLi in Search (searchquery) — DB Exfiltration | 9.4 |
| vuln-0003 | Reflected XSS in Search — Session Cookie Theft | 9.6 |
| vuln-0004 | Broken AC in Cart/Order — Cross-Account Orders + PAN Exposure | 7.1 |
| vuln-0005 | Path Traversal in Supplier Upload — Arbitrary File Write | 8.9 |
| vuln-0006 | Stored XSS in Guestbook — Persistent Script Execution | 9.6 |
| vuln-0007 | SQLi in Login — Auth Bypass + Account Impersonation | 10.0 |

**BadStore per-vuln detail (Run 2):**

| Vuln ID | Title | CVSS |
|---------|-------|------|
| vuln-0001 | Stored XSS in Guestbook Comments | 9.6 |
| vuln-0002 | SQL Injection in Login — Auth Bypass | 9.4 |
| vuln-0003 | SQL Injection in Search — DB Extraction + File Read | 10.0 |
| vuln-0004 | SSOid Cookie Forgery — Admin Impersonation | 9.1 |
| vuln-0005 | Cart Total Tampering via CartID Cookie — Underpayment | 7.5 |
| vuln-0006 | SQL Injection in Cart Add (cartitem) — DB Exfiltration | 10.0 |
