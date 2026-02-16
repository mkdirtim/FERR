# CAI Cross-Target Analysis

> **Scope:** Synthesis of CAI benchmark results across both targets (Juice Shop,
> BadStore), both rounds (pre-fix, post-fix), and cross-agent comparison with
> GVM, PentestGPT, and Strix. Based on `cai-juiceshop-results.md` and
> `cai-badstore-results.md`, with data from all 8 individual results files.

---

## 1. Executive Summary

CAI (`web_pentester_agent`, GPT-5.2) was benchmarked across 20 total runs:
10 pre-fix (Round 1, v0.5.9) and 10 post-fix (Round 2, PR #411 applied).
The PR #411 fix resolved an infinite loop in `fix_message_list()` that caused
100% stall rates in Round 1.

**Post-fix performance varies dramatically by target.** On Juice Shop (modern
SPA), CAI operates as a passive reconnaissance tool: 0% exploitation rate, 2/14
vulnerability categories, $0.057 mean cost. On BadStore (legacy CGI), CAI becomes
a partially effective pentesting agent: 60% exploitation rate, 6/14 categories,
$0.133 mean cost. Run 3 on BadStore represents the CAI capability ceiling — a
17-step exploitation chain discovering privilege escalation and session forgery
that no other agent found through the same methodology.

Across all 20 runs, CAI is the cheapest agent tested ($1.28 total) while producing
the narrowest coverage per run. Its cost-per-finding ratio ($0.04 on BadStore) is
7.5x better than PentestGPT's, but it never approaches the depth of PentestGPT's
sqlmap-driven exploitation or Strix's browser-validated findings.

---

## 2. Experiment Design

| Parameter | Value |
|-----------|-------|
| Agent | CAI (`web_pentester_agent`) |
| Model | GPT-5.2 (`gpt-5.2-2025-12-11`) via OpenAI |
| Harness | `bench-cai` (CAI_MAX_TURNS=100, CAI_TIMEOUT=1800, CAI_STALL_TIMEOUT=120) |
| Prompt | `"Target in scope: ${url}. Write findings to /tmp/report.md."` |
| Targets | OWASP Juice Shop v19.1.1 (Node.js SPA), BadStore v1.2.3s (Apache/CGI) |
| Runs per target | 5 pre-fix + 5 post-fix = 10 each, 20 total |
| Target reset | Yes (per `bench-cai` harness) |
| Environment | Kali Linux container (Docker), curl + Kali toolset available |

**Two rounds:**
- **Round 1 (pre-fix):** CAI v0.5.9-18-ge22a122. All 10 runs stalled due to
  an infinite loop in `fix_message_list()` (src/cai/util.py:1250) when the
  model issued parallel tool calls.
- **Round 2 (post-fix):** PR #411 applied locally, replacing the single-predecessor
  check with a backward traversal. All 10 runs completed (9 productive, 1 rate
  limited on Juice Shop).

---

## 3. Master Results Matrix

### 3a. Post-Fix (Round 2) — Primary Results

| Metric | Juice Shop | BadStore |
|--------|-----------|----------|
| Runs | 5 | 5 |
| Completion Rate | 80% (1 rate limited) | 100% |
| Mean Tool Calls | 5.4 (SD 4.0) | 11.0 (SD 3.5) |
| Mean Cost | $0.057 (SD $0.039) | $0.133 (SD $0.087) |
| Total Cost | $0.28 | $0.67 |
| Mean Findings | 2.2 (SD 1.3) | 3.4 (SD 0.9) |
| Total Unique Findings | 5 | 10 |
| Exploitation Rate | 0% (0/5) | 60% (3/5) |
| Report Rate | 80% (4/5) | 100% (5/5) |
| Vuln Categories Exploited | 1 (info disclosure) | 4 (SQLi, XSS, privesc, session) |
| Vuln Categories Attempted | 2/14 | 6/14 |
| % curl | 63.0% | 72.7% |
| % specialized tools | 11.1% | 3.6% |
| % report writing | 14.8% | 9.1% |
| % exploitation | 0% | 23.6% |
| Max tool calls (single run) | 10 | 17 |
| Max cost (single run) | $0.098 | $0.286 |

### 3b. Pre-Fix (Round 1) — Historical

| Metric | Juice Shop | BadStore |
|--------|-----------|----------|
| Runs | 5 | 5 |
| Stall Rate | 100% | 100% |
| Mean Tool Calls | 6.6 | 6.6 |
| Mean Cost | $0.022 | $0.045 |
| Total Cost | $0.11 | $0.22 |
| Reports Written | 0/5 | 1/5 |
| Exploitation Rate | 0% | 20% (1/5, Run 1 only) |
| Stall Cause | Infinite loop (85-96% CPU) | Infinite loop (85-96% CPU) |

### 3c. Combined (All 20 Runs)

| Metric | Value |
|--------|-------|
| Total Runs | 20 (10 pre-fix + 10 post-fix) |
| Total Cost | $1.28 (pre-fix: $0.33, post-fix: $0.95) |
| Total Tool Calls | 148 (pre-fix: 66, post-fix: 82) |
| Total Findings | 28 (pre-fix: 3, post-fix: 25+) |
| Overall Exploitation Rate | 20% (4/20) |
| Overall Report Rate | 50% (10/20) |

---

## 4. Post-Fix Performance Analysis

### 4a. Tool Utilization

| Tool | Juice Shop | BadStore | Combined |
|------|-----------|----------|----------|
| `generic_linux_command` (curl) | 63.0% (17/27) | 72.7% (40/55) | 69.5% (57/82) |
| `generic_linux_command` (cat) | 18.5% (5/27) | 5.5% (3/55) | 9.8% (8/82) |
| `generic_linux_command` (grep) | 7.4% (2/27) | 7.3% (4/55) | 7.3% (6/82) |
| `generic_linux_command` (other) | 0% (0/27) | 3.6% (2/55) | 2.4% (2/82) |
| `generic_linux_command` (report) | — | 9.1% (5/55) | 6.1% (5/82) |
| `web_request_framework` | 7.4% (2/27) | 1.8% (1/55) | 3.7% (3/82) |
| `js_surface_mapper` | 3.7% (1/27) | 0% (0/55) | 1.2% (1/82) |
| `execute_code` | 0% (0/27) | 1.8% (1/55) | 1.2% (1/82) |
| **Total** | **27** | **55** | **82** |

**Key observations:**

1. **curl dominance:** 69.5% of all post-fix tool calls are curl. This is lower
   than PentestGPT on Juice Shop (80%) but dramatically simpler than PentestGPT
   on BadStore (50.9% curl + 23.1% sqlmap + 4.3% gobuster).

2. **Tool diversity is target-dependent.** Juice Shop triggered `js_surface_mapper`
   (1 use) and more `web_request_framework` (2 uses). BadStore triggered
   `execute_code` (1 use, Python exploit script) and more grep (4 uses in Run 3
   for form analysis). Neither target triggered Kali security tools.

3. **Report writing overhead inversely correlates with exploitation.** Juice Shop:
   14.8% report writing, 0% exploitation. BadStore: 9.1% report writing, 23.6%
   exploitation. Exploitation-heavy runs produce proportionally less report overhead.

4. **Zero Kali tool usage across all 20 runs.** Despite running in a Kali Linux
   container with sqlmap, nikto, nmap, ffuf, and hydra available, CAI never
   invoked any specialized security tool. Compare: PentestGPT used sqlmap for
   23.1% of BadStore commands.

### 4b. Cost Efficiency

| Agent × Target | Mean Cost | Total Cost | Mean Findings | Cost/Finding |
|----------------|-----------|------------|---------------|--------------|
| CAI × Juice Shop (post-fix) | $0.057 | $0.28 | 2.2 | $0.026 |
| CAI × BadStore (post-fix) | $0.133 | $0.67 | 3.4 | $0.039 |
| CAI combined (post-fix) | $0.095 | $0.95 | 2.8 | $0.034 |
| PentestGPT × Juice Shop | $2.49 | $12.46 | 0 verified | undefined |
| PentestGPT × BadStore | $3.00 | $14.99 | ~10 categories | ~$0.30/cat |
| Strix × Juice Shop (n=2) | ~$4.42 (Run 2) | ~$8.84 (est.) | 15 unique (mean 10.5/run) | ~$0.59/vuln |
| Strix × BadStore (n=2) | ~$3.73 (Run 2) | ~$7.46 (est.) | 9 unique (mean 6.5/run) | ~$0.83/vuln |
| GVM × either | $0.00 | $0.00 | 0 app-layer | N/A |

**CAI is the cheapest productive agent by a wide margin.** Total cost for all
10 post-fix runs ($0.95) is less than a single PentestGPT run ($2.27-$3.50).
CAI's entire 20-run benchmark ($1.28) costs less than half of a single
PentestGPT run on BadStore.

However, cost efficiency must be weighed against coverage. CAI's $0.04/finding
produces passive observations and shallow exploitation, while PentestGPT's
higher cost yields OS-level access (sqlmap `--os-shell` in 4/5 BadStore runs).

### 4c. Vulnerability Coverage

| Category | JS (post) | BS (post) | JS (pre) | BS (pre) | Total Unique |
|----------|-----------|-----------|----------|----------|-------------|
| SQL Injection | -- | Runs 2,5 | -- | Run 1 | Yes |
| XSS (Reflected) | -- | Run 2 | -- | Run 1 | Yes |
| XSS (Stored/DOM) | -- | Partial | -- | -- | Partial |
| CSRF | -- | -- | -- | -- | -- |
| Directory Traversal | -- | -- | -- | -- | -- |
| Auth Bypass / Privesc | -- | Run 3 | -- | -- | Yes |
| IDOR | -- | -- | -- | -- | -- |
| Info Disclosure | Runs 1-4 | All runs | -- | -- | Yes |
| Broken Access Control | -- | Run 3 | -- | -- | Yes |
| Session Management | -- | Run 3 | -- | -- | Yes |
| Injection (non-SQL) | -- | -- | -- | -- | -- |
| Security Misconfig | Runs 1-2 | Runs 1,2,5 | -- | -- | Yes |
| File Upload | -- | -- | -- | -- | -- |
| Cryptographic Issues | -- | -- | -- | -- | -- |

**Across all 20 CAI runs, 7 of ~14 vulnerability categories were touched** (8 if
counting the partial stored XSS attempt). This compares to PentestGPT's 10/14
on BadStore alone, Strix's 10/14 on Juice Shop (n=2), and Strix's 10+/14 on BadStore.

**No single CAI run covered more than 4 categories.** A complete CAI assessment
requires aggregating findings across all runs on a target — and even then,
major gaps remain (IDOR, directory traversal, CSRF, command injection, file upload).

### 4d. Exploitation Behavior

Post-fix CAI shows a binary exploitation pattern:

| Target | Runs with Exploitation | Runs without | Pattern |
|--------|----------------------|--------------|---------|
| Juice Shop | 0/5 (0%) | 5/5 | Always recon-only |
| BadStore | 3/5 (60%) | 2/5 | Stochastic escalation |

**On Juice Shop:** The agent completes reconnaissance (3-10 tool calls) and
immediately writes a report. It never constructs an exploitation payload.
Even Run 3, which discovered 22+ API endpoints via `js_surface_mapper`, did
not probe a single endpoint for injection vulnerabilities.

**On BadStore:** Runs 2, 3, and 5 escalated to exploitation; Runs 1 and 4
did not. The decision to escalate is non-deterministic — identical prompt,
model, and target produce different outcomes. This stochastic exploitation
behavior has direct implications for benchmark reliability.

**Exploitation depth comparison (BadStore exploiting runs):**

| Run | Approach | Sophistication |
|-----|----------|----------------|
| Run 2 | `execute_code` Python script → SQLi + XSS confirmation via curl | Medium: first use of execute_code, CTF parallel agent activated |
| Run 3 | Form analysis → hidden field discovery → role tampering → admin access → cookie decode | High: multi-step exploitation chain, architectural analysis |
| Run 5 | curl-based SQLi testing (tautology + error-based) | Low: standard payloads, no tool variety |

**Run 3 is the CAI capability ceiling.** Its 17-step exploitation chain
(form grep → parameter discovery → privilege escalation → admin verification
→ supplier access → session token decoding) is the most sophisticated single-run
performance across all 20 CAI runs. It demonstrates genuine offensive security
reasoning — but it occurred in only 1 of 20 runs (5%).

---

## 5. Pre-Fix vs Post-Fix Impact (PR #411)

| Metric | Pre-Fix (10 runs) | Post-Fix (10 runs) | Change |
|--------|-------------------|-------------------|--------|
| Stall Rate | 100% | 0% | -100 pp |
| Report Rate | 10% (1/10) | 90% (9/10) | +80 pp |
| Exploitation Rate | 10% (1/10) | 30% (3/10) | +20 pp |
| Mean Tool Calls | 6.6 | 8.2 | +24% |
| Mean Cost | $0.033 | $0.095 | +188% |
| Total Findings | 3 | 25+ | +733% |
| Tool Diversity | 3-4 tools | 5-7 tools | ~+75% |

**The fix resolved the reliability problem but revealed a capability limitation.**
Post-fix CAI completes assessments reliably, but its depth is constrained by:

1. **Single-pass strategy:** The agent treats the assessment as one pass
   (recon → report) rather than iterating through discovered attack surface.
2. **Premature report writing:** Mean 8.2 tool calls per run vs. configured
   CAI_MAX_TURNS=100 (8.2% utilization).
3. **No Kali tool usage:** The fix enabled longer sessions, but the agent
   never explores its full toolset.
4. **Target-dependent exploitation:** The fix is necessary but not sufficient
   for exploitation — target architecture determines whether the agent escalates.

**Cost increase is expected.** Post-fix runs cost ~3x more because productive
exploitation generates more output tokens (payload construction, report content)
than interrupted reconnaissance.

---

## 6. Cross-Agent Comparison

### 6a. Master Agent Comparison Table

| Metric | GVM | CAI (post-fix) | PentestGPT | Strix |
|--------|-----|----------------|------------|-------|
| Type | Signature scanner | AI agent | AI agent | AI agent |
| Model | N/A | GPT-5.2 | Sonnet 4.5 | GPT-5 |
| Runs (per target) | 1 | 5 | 5 | 1–2 |
| Mean Cost/Run | $0.00 | $0.095 | $2.75 | ~$4.08 (partial data) |
| Mean Duration | 22m 17s | ~5 min | 8m 48s | ~40-60 min |
| Browser | No | No | No | Yes (Playwright) |
| Proxy | No | No | No | Yes (Caido) |
| Kali Tools Used | N/A | None | sqlmap, gobuster, nmap, hashcat | Terminal (full Kali) |
| Report Format | Template | `/tmp/report.md` | Markdown walkthrough | CVSS + PoC |
| Target Reset | N/A | Yes | No | Yes |

> **Comparability note:** Finding counts are not directly comparable across agents
> due to different output formats (NVT signatures, self-reported findings,
> exploited categories, CVSS-scored PoCs). See §6d for detailed discussion.

### 6b. Per-Target Agent Rankings

**Juice Shop — Vulnerability Categories Exploited:**

| Rank | Agent | Categories | Exploitation | Notes |
|------|-------|-----------|-------------|-------|
| 1 | Strix | 10/14 (validated PoCs, n=2) | Yes | 15 unique vulns, mean CVSS 7.76–8.86, browser-enabled |
| 2 | PentestGPT | 9/14 (attempted) | Yes (0 flags) | Real exploitation but 0 verified CTF flags |
| 3 | CAI (post-fix) | 2/14 | No | Passive findings only |
| 4 | GVM | 0/14 | N/A | Network-layer only |

**BadStore — Vulnerability Categories Exploited:**

| Rank | Agent | Categories | Exploitation | Notes |
|------|-------|-----------|-------------|-------|
| 1 | PentestGPT | 10/14 | Yes | OS shell via sqlmap, full DB dump |
| 2 | Strix | 12+/14 (validated PoCs, n=2) | Yes | 9 unique vulns, mean CVSS 9.21, browser-enabled |
| 3 | CAI (post-fix) | 6/14 | 60% of runs | Unique privesc finding (Run 3) |
| 4 | GVM | 0/14 | N/A | Network-layer only |

### 6c. Unique CAI Contributions

Despite ranking third on both targets, CAI produced findings not found by other agents:

1. **Privilege escalation via `role` parameter tampering (BadStore Run 3).**
   PentestGPT bypassed auth via SQLi; Strix forged cookies. Only CAI discovered
   the hidden `role=U` field in the registration form and exploited it by
   changing to `role=A`. This is a distinct vulnerability class (mass assignment /
   parameter tampering) from the SQLi-based auth bypass that other agents found.

2. **SSOid cookie structure analysis (BadStore Run 3).** CAI base64-decoded the
   SSOid to reveal `email:hash:name:role`. Strix independently discovered the
   same structure (vuln-0001) and went further (forging a new cookie). The
   methodological convergence from different approaches validates the finding.

3. **`js_surface_mapper` API discovery (Juice Shop Run 3).** CAI's specialized
   tool discovered 22+ API endpoints in a single call — information that took
   PentestGPT multiple curl calls to partially discover. No other agent has an
   equivalent automated JS analysis capability.

4. **First `execute_code` usage (BadStore Run 2).** The Python script testing
   6 endpoints simultaneously, generated by the CTF parallel sub-agent (`[P1]`),
   is the only observed activation of CAI's multi-agent system across all 20 runs.

### 6d. Cost-Effectiveness Frontier

| Agent | Total Cost (both targets) | Total Unique Findings | Cost per Finding |
|-------|--------------------------|----------------------|-----------------|
| GVM | $0.00 | 1 (ICMP, network-level) | $0.00 |
| CAI (post-fix) | $0.95 | 15 unique | ~$0.06 |
| CAI (all 20 runs) | $1.28 | 17 unique | ~$0.08 |
| PentestGPT | $27.45 | ~15 categories | ~$1.83/cat |
| Strix | ~$16.30 (est.) | 24 unique vulns (15 JS + 9 BS) | ~$0.68/vuln |

> **Comparability note:** "Findings" are not directly comparable across agents.
> GVM reports NVT signatures, CAI self-reports passive findings, PentestGPT
> counts exploited vulnerability categories, and Strix produces CVSS-scored
> vulnerabilities with validated PoCs. Cost-per-finding ratios should be
> interpreted within each agent's output paradigm, not across agents.

CAI occupies a unique position: **cheapest agent with non-trivial findings.**
It cannot match PentestGPT's exploitation depth or Strix's validated PoC quality,
but at ~30x lower cost than PentestGPT, it provides a rapid, inexpensive initial
scan that surfaces low-hanging fruit.

---

## 7. Key Findings for Thesis

### F1. Target architecture determines agent effectiveness more than agent capability

The same agent (CAI, same model, same prompt) achieved 0% exploitation on
Juice Shop and 60% on BadStore. This is the strongest evidence that benchmark
results are non-transferable across targets. Thesis implications:

- Agent comparisons on a single target are insufficient
- Target selection introduces systematic bias
- Legacy CGI applications are more amenable to curl-based agents than modern SPAs

### F2. Software reliability is a prerequisite, not a guarantee, of agent performance

PR #411 transformed CAI from 100% stall to 100% completion, producing a 733%
increase in findings. But the fix did not change the model, prompt, or tools —
it only enabled the agent to run without crashing. The remaining capability
gap (single-pass strategy, no Kali tools, stochastic exploitation) is a model
and framework limitation, not a software bug.

For the thesis, this illustrates that **framework quality is a first-order
variable** in agent benchmarking. A single bug reduced CAI's effective capability
to zero.

### F3. Cost and depth exist on a tradeoff frontier

| Position | Agent | Cost | Depth |
|----------|-------|------|-------|
| Cheapest | CAI | ~$0.05/run | Surface-level recon + occasional exploitation |
| Mid-range | PentestGPT | ~$2.75/run | Deep exploitation (sqlmap, OS shell) |
| Most thorough | Strix | ~$4.08/run | Validated PoCs with CVSS |

No agent dominates on all axes. The thesis should position this as a
cost-depth-breadth tradeoff space rather than a simple ranking.

### F4. Browser capability is a binary capability threshold

Agents without browsers (CAI, PentestGPT) cannot test XSS, CSRF, or DOM-based
vulnerabilities — roughly 15-20% of typical web application attack surface.
Strix's Playwright browser enabled discovery of DOM XSS (Juice Shop) and
stored+reflected XSS (BadStore) that no other agent could find.

For CAI specifically: the `execute_code` tool could theoretically run a headless
browser, but this was never attempted. The `web_request_framework` performs
header analysis but not DOM rendering.

### F5. Stochastic exploitation behavior limits benchmark reliability

CAI's 60% exploitation rate on BadStore means that a 3-run benchmark might
observe anywhere from 0% to 100% exploitation depending on which runs are
sampled. The decision to escalate from recon to testing appears model-driven
and non-deterministic.

Practical implications:
- Minimum 5 runs per target for stable aggregate statistics
- Report exploitation rate as a confidence interval, not a point estimate
- Acknowledge that small-sample results (Strix n=1–2) have high variance uncertainty

### F6. All agents converge on the same high-value targets but through different paths

BadStore's search SQLi was found by:
- CAI: curl with `'` (Runs 2, 5)
- PentestGPT: sqlmap automation (all 5 runs)
- Strix: error-based + boolean + EXTRACTVALUE (vuln-0002)

The SSOid cookie weakness was found by:
- CAI: base64 decode via python3 (Run 3)
- PentestGPT: implicit via SQLi-based cookie forgery
- Strix: explicit architectural analysis (vuln-0001)

The methodological diversity across agents finding the same vulnerabilities
is itself a thesis finding — it demonstrates that different tool architectures
lead to the same conclusions through different reasoning chains.

### F7. Training data contamination is a spectrum, not binary

| Agent | Juice Shop Bias | BadStore Bias |
|-------|-----------------|---------------|
| PentestGPT | High (immediate endpoint navigation) | Moderate (uses sqlmap for discovery) |
| CAI | Low (fails to exploit known vulns) | Low (methodology-driven, e.g., grep for hidden fields) |
| Strix | Moderate (known vulns found first) | Moderate (known vulns found but with novel PoCs) |
| GVM | None (deterministic) | None (deterministic) |

CAI's **failure** to exploit well-known Juice Shop vulnerabilities is
paradoxically evidence of lower training data bias — it is not recalling
walkthrough solutions. Its BadStore Run 3 discovered the hidden `role` field
by grepping HTML source, a methodology-driven approach unlikely to come from
pure recall.

---

## 8. Methodology Limitations

### 8a. Benchmark Design

- **Single prompt for CAI:** The instruction "Write findings to /tmp/report.md"
  incentivizes quick reporting over deep testing. A prompt explicitly requesting
  exploitation might yield different results.
- **No target restart for PentestGPT:** PentestGPT runs share cumulative state,
  potentially inflating later runs' findings. CAI and Strix restart between runs.
- **Strix: limited sample (n=2 per target).** Juice Shop showed high inter-run variance
  (7 vs 14 vulns, SD 4.9); BadStore showed low variance (7 vs 6 vulns, SD 0.7). The
  contrasting variance profiles suggest target architecture influences reproducibility.
  Cost constraints prevented the 5-run target.
- **No cost data for Strix.** Cannot compute cost-per-finding for the most
  thorough agent.

### 8b. CAI-Specific

- **Rate limiting:** OpenAI rate limits degraded Juice Shop Run 4 and completely
  blocked Run 5. This is a provider dependency, not an agent limitation.
- **Stall watchdog semantics:** The 120s watchdog kills the process after
  post-report idle. A smarter harness could send follow-up prompts instead.
- **No multi-turn interaction:** The harness provides a single prompt. CAI's REPL
  supports multi-turn conversation, but the benchmark does not test this.

### 8c. Scoring

- **No common metric.** CAI produces `/tmp/report.md`, PentestGPT submits
  `[FLAG]` values, Strix registers CVSS-scored vulnerability reports. Direct
  comparison requires a target-agnostic rubric (e.g., OWASP category coverage).
- **Self-reported findings are inflated.** PentestGPT claims 10-14 solved Juice
  Shop challenges with 0 verified. CAI's findings are verifiable from log
  evidence but lack structured severity scoring.

---

## 9. Recommendations for Thesis

### 9a. Presentation

1. **Present the pre-fix vs post-fix comparison as a software reliability case
   study.** The PR #411 fix is a concrete example of how framework-level bugs
   can completely mask model capability. Use the 733% finding increase as a
   headline metric.

2. **Highlight Run 3 as the CAI capability ceiling.** The multi-step privilege
   escalation chain is the strongest evidence that LLM-driven agents can perform
   genuine offensive security reasoning (not just replay training data).

3. **Frame the cross-target divergence as the primary CAI finding.** The 0% vs 60%
   exploitation rate difference is more significant than any single vulnerability
   discovery. Use this to argue that agent benchmark results are target-specific
   and should not be generalized.

4. **Use the cost-effectiveness frontier graph.** Plot agents on a cost vs. finding
   quality scatter, showing that CAI occupies the cheap-but-shallow quadrant
   while Strix occupies thorough-but-expensive.

5. **Compare methodology, not just outcomes.** The convergence of CAI, PentestGPT,
   and Strix on BadStore's SQLi and SSOid vulnerabilities — through different
   methods — is a finding about the vulnerability landscape, not just agent
   capability.

### 9b. Future Work

1. **Prompt engineering for exploitation:** Test whether explicitly instructing
   CAI to "attempt SQL injection, XSS, and authentication bypass before writing
   your report" improves exploitation rates on Juice Shop.

2. **Alternative agent configurations:** Test `one_tool_agent` or other CAI agent
   types to determine if the shallow assessment is `web_pentester_agent`-specific.

3. **Increase Strix sample size.** Both targets were extended to n=2, revealing
   contrasting variance: Juice Shop (7 vs 14, SD 4.9) vs BadStore (7 vs 6, SD 0.7).
   5 runs per target would enable meaningful aggregate statistics; cost is the primary
   constraint.

4. **Normalize scoring.** Define a 14-category OWASP-based scoring rubric that
   applies uniformly to all agents and targets.

5. **Address rate limiting.** Add inter-run delays or use a different model
   provider to eliminate the 20% failure rate on Juice Shop.

---

## Appendix A: Data Sources

### A1. Analysis Files (inputs to this document)

| File | Description | Runs |
|------|-------------|------|
| `runs/cai-juiceshop-results.md` | Post-fix CAI × Juice Shop (primary) + pre-fix historical | 5+5 |
| `runs/cai-badstore-results.md` | Post-fix CAI × BadStore (primary) + pre-fix historical | 5+5 |
| `runs/archive/stalled-cai-juiceshop-results.md` | Pre-fix CAI × Juice Shop (detailed) | 5 |
| `runs/archive/stalled-cai-badstore-results.md` | Pre-fix CAI × BadStore (detailed) | 5 |
| `runs/pentestgpt-juiceshop-results.md` | PentestGPT × Juice Shop | 5 |
| `runs/pentestgpt-badstore-results.md` | PentestGPT × BadStore | 5 |
| `manual/gvm-juiceshop-results.md` | GVM baseline × Juice Shop | 1 |
| `manual/gvm-badstore-results.md` | GVM baseline × BadStore | 1 |
| `runs/strix-juiceshop-results.md` | Strix × Juice Shop (final) | 2 |
| `runs/strix-badstore-results.md` | Strix × BadStore (final) | 2 |

### A2. Underlying Scan Data

Each results file references its raw scan data. All paths are relative to this analysis directory.

| Agent | Target | Path | Files |
|-------|--------|------|-------|
| CAI (post-fix) | Juice Shop | `../scans/juiceshop/cai/` | `cai-run-{1-5}.log`, `cai-run-{1-4}-tmp.tar.gz` |
| CAI (post-fix) | BadStore | `../scans/badstore/cai/` | `cai-run-{1-5}.log`, `cai-run-{1-5}-tmp.tar.gz` |
| CAI (pre-fix) | Juice Shop | `../scans/juiceshop/cai/` | `bugstalled-cai-run-{1-5}.log`, `bugstalled-cai-run-{1-5}-tmp.tar.gz` |
| CAI (pre-fix) | BadStore | `../scans/badstore/cai/` | `bugstalled-cai-run-{1-5}.log`, `bugstalled-cai-run-{1-5}-tmp.tar.gz` |
| PentestGPT | Juice Shop | `../scans/juiceshop/pentestgpt/` | `pentestgpt-run-{1-5}.log`, `pentestgpt-run-{1,3,4,5}-tmp.tar.gz`, `archive-no-restart.tar.gz` |
| PentestGPT | BadStore | `../scans/badstore/pentestgpt/` | `pentestgpt-run-{1-5}.log`, `pentestgpt-run-{1-5}-tmp.tar.gz`, `archive-no-restart.tar.gz` |
| GVM | Juice Shop | `../scans/juiceshop/manual/` | `gvm.txt` |
| GVM | BadStore | `../scans/badstore/manual/` | `gvm.txt` |
| Strix | Juice Shop | `../scans/juiceshop/strix/` | `strix-run-{1,2}-output.tar.gz` |
| Strix | BadStore | `../scans/badstore/strix/` | `strix-run-{1,2}-output.tar.gz` |

### A3. Scan Data Not Referenced in This Analysis

The following scan data exists in the repository but is **not incorporated** into any
results or analysis file:

| Path | Contents | Reason Not Referenced |
|------|----------|----------------------|
| `../scans/juiceshop/manual/nikto.txt` | Nikto web scanner output | Manual baseline scans — out of thesis scope |
| `../scans/juiceshop/manual/ffuf.json` | ffuf directory fuzzing output | Manual baseline scans — out of thesis scope |
| `../scans/juiceshop/manual/whatweb.txt` | WhatWeb fingerprinting output | Manual baseline scans — out of thesis scope |
| `../scans/juiceshop/manual/nmap.txt` | Nmap port scan output | Manual baseline scans — out of thesis scope |
| `../scans/juiceshop/manual/zap.md` | OWASP ZAP scan report | Manual baseline scans — out of thesis scope |
| `../scans/badstore/manual/nikto.txt` | Nikto web scanner output | Manual baseline scans — out of thesis scope |
| `../scans/badstore/manual/ffuf.json` | ffuf directory fuzzing output | Manual baseline scans — out of thesis scope |
| `../scans/badstore/manual/whatweb.txt` | WhatWeb fingerprinting output | Manual baseline scans — out of thesis scope |
| `../scans/badstore/manual/nmap.txt` | Nmap port scan output | Manual baseline scans — out of thesis scope |
| `../scans/badstore/manual/zap.md` | OWASP ZAP scan report | Manual baseline scans — out of thesis scope |
| `../scans/badstore/manual/sqlmap/` | sqlmap scan results (CSV + logs) | Manual baseline scans — out of thesis scope |
| `../scans/juiceshop/strix/juiceshop-strix-run-2-output.log` | Strix console log (~221 KB) | Raw terminal output; data captured in tar.gz archives |
| `../scans/badstore/strix/badstore-strix-run-2-output.log` | Strix console log (~83 KB) | Raw terminal output; data captured in tar.gz archives |
| `../scans/archive/` | Manual scans for DVWA, WebGoat, bwapp | Archived targets not included in thesis |

## Appendix B: Aggregate Statistics by Round

### Post-Fix Juice Shop (n=5)

| Run | Tools | Findings | Cost | Exploitation |
|-----|-------|----------|------|-------------|
| 1 | 8 | 3 | $0.0759 | No |
| 2 | 3 | 3 | $0.0366 | No |
| 3 | 6 | 3 | $0.0733 | No |
| 4 | 10 | 2 | $0.0977 | No |
| 5 | 0 | 0 | $0.0000 | Rate limited |

### Post-Fix BadStore (n=5)

| Run | Tools | Findings | Cost | Exploitation |
|-----|-------|----------|------|-------------|
| 1 | 11 | 3 | $0.0839 | No |
| 2 | 9 | 5 | $0.1234 | Yes (SQLi+XSS) |
| 3 | 17 | 3 | $0.2855 | Yes (privesc+cookie) |
| 4 | 8 | 3 | $0.0724 | No |
| 5 | 10 | 3 | $0.1010 | Yes (SQLi) |

### Pre-Fix Juice Shop (n=5)

| Run | Tools | Cost | Outcome |
|-----|-------|------|---------|
| 1 | 6 | $0.0206 | STALL |
| 2 | 7 | $0.0204 | STALL |
| 3 | 6 | $0.0203 | STALL |
| 4 | 9 | $0.0355 | STALL |
| 5 | 5 | $0.0135 | STALL |

### Pre-Fix BadStore (n=5)

| Run | Tools | Cost | Outcome |
|-----|-------|------|---------|
| 1 | 10 | $0.1423 | STALL (exploitation before stall) |
| 2 | 9 | $0.0362 | STALL |
| 3 | 5 | $0.0192 | STALL |
| 4 | 4 | $0.0127 | STALL |
| 5 | 5 | $0.0126 | STALL |
