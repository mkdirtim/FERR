# Benchmark Summary — LLM-Driven Penetration Testing Agents

> **Scope:** Comprehensive cross-agent, cross-target synthesis of all benchmark
> data. Consolidates findings from `cai-analysis.md`, `pentestgpt-analysis.md`,
> and `strix-analysis.md` into a single reference document for thesis
> writing.

---

## 1. Benchmark Overview

Four agents were benchmarked against two deliberately vulnerable web
applications, producing 36 total runs and generating the data for this thesis.

| Agent | Model | Runs (JS + BS) | Total Cost | Output Format |
|-------|-------|---------------|------------|---------------|
| GVM (baseline) | N/A (signature scanner) | 2 (1+1) | $0.00 | Template report |
| CAI | GPT-5.2 | 20 (10+10) | $0.89 | `/tmp/report.md` |
| PentestGPT | Sonnet 4.5 | 10 (5+5) | $27.45 | `[FLAG]` + walkthrough |
| Strix | GPT-5 | 4 (2+2) | ~$16.30 (est. from partial data) | CVSS + executable PoC |
| **Total** | — | **36** | **~$44.64** | — |

**Targets:**
- **OWASP Juice Shop v19.1.1** — Modern Node.js SPA with 110 CTF challenges, SQLite backend, Angular frontend
- **BadStore v1.2.3s** — Legacy Apache/CGI application (~2004), MySQL backend, ~16 known vulnerability categories, no CTF system

---

## 2. Master Comparison

### 2a. Agent Profiles

| Dimension | GVM | CAI | PentestGPT | Strix |
|-----------|-----|-----|------------|-------|
| **Architecture** | Plugin-based scanner | Single-agent + sub-agents | Single-agent (Claude Code SDK) | Multi-agent + browser + proxy |
| **Model** | N/A | GPT-5.2 | Sonnet 4.5 | GPT-5 |
| **Mean Cost/Run** | $0.00 | $0.095 | $2.75 | ~$4.08 (partial data) |
| **Mean Duration** | ~15 min | ~5 min | 8m 48s | ~50 min |
| **Browser** | No | No | No | Yes (Playwright) |
| **Proxy** | No | No | No | Yes (Caido) |
| **Kali Tools Used** | N/A | None | sqlmap, gobuster, nmap, hashcat, mysql | Terminal (full Kali) |
| **Target Reset** | N/A | Yes | No | Yes |
| **Completion Rate** | 100% | 80% (post-fix) | 100% | 100% |

### 2b. Quantitative Performance Summary

| Metric | GVM | CAI (post-fix) | PentestGPT | Strix |
|--------|-----|----------------|------------|-------|
| Total Unique Findings | 1 (ICMP) | 15 | ~11 categories | 24 vulns |
| Mean Findings/Run | 0 | 2.8 | N/A (category) | 8.5 |
| Juice Shop Categories | 0/14 | 2/14 | 9/14 | 10/14 |
| BadStore Categories | 0/14 | 6/14 | 10/14 | 12+/14 |
| Combined Categories | 0/14 | 7/14 | ~11/14 | 13/16 |
| XSS Findings | 0 | 0 | 0 (verified) | 5 |
| OS-Level Access | No | No | Yes (4/5 BS runs) | No |
| Mean CVSS | N/A | N/A | N/A | ~8.7 |
| Cost/Finding | $0.00 | ~$0.06 | ~$2.50/cat | ~$0.68/vuln |

### 2c. Per-Target Rankings

**Juice Shop:**

| Rank | Agent | Categories | Defining Capability |
|------|-------|-----------|---------------------|
| 1 | Strix | 10/14 | 15 unique vulns with CVSS + PoC; 2 DOM XSS via Playwright |
| 2 | PentestGPT | 9/14 | Real SQLi/IDOR/auth bypass exploitation; 0 verified CTF flags |
| 3 | CAI | 2/14 | Passive recon only; cheapest at $0.057/run |
| 4 | GVM | 0/14 | Network-layer only (ICMP timestamp) |

**BadStore:**

| Rank | Agent | Categories | Defining Capability |
|------|-------|-----------|---------------------|
| 1 | Strix | 12+/14 | 9 unique vulns, mean CVSS 9.21; session forgery + XSS via browser |
| 2 | PentestGPT | 10/14 | OS shell via sqlmap, full DB dump (682 records), webshell upload |
| 3 | CAI | 6/14 | Unique privilege escalation via role parameter tampering (Run 3) |
| 4 | GVM | 0/14 | No application-layer findings |

---

## 3. Cost-Depth-Quality Tradeoff

The benchmark reveals a three-dimensional tradeoff space. No agent dominates
on all axes.

```
                         Output Quality
                              ↑
                              |
                    Strix  ◆  |  (CVSS + PoC, browser-validated)
                              |
                              |
                              |
              PentestGPT  ◆   |  (exploitation walkthroughs, OS shell)
                              |
                              |
                   CAI  ◆     |  (passive reports)
                              |
               GVM  ◆         |  (template)
                              |
          ────────────────────┼──────────────────→ Cost/Run
          $0                  |  $0.10    $2.75  ~$4.08
```

| Position | Agent | Cost/Run | Depth | Quality | Best Use Case |
|----------|-------|----------|-------|---------|---------------|
| Free baseline | GVM | $0.00 | None (network) | Template | Network-layer baseline only |
| Cheap-shallow | CAI | $0.095 | Surface recon | Passive report | Quick, inexpensive initial triage |
| Mid-cost-deep | PentestGPT | $2.75 | OS shell, DB dump | Walkthrough | Exploitation depth on legacy targets |
| Expensive-thorough | Strix | ~$4.08 | Validated vulns | CVSS + PoC | Comprehensive assessment with browser |

**Key tradeoff observations:**

1. **29× CAI's cost → PentestGPT** buys genuine exploitation depth (OS shell,
   full database dump, webshell deployment) vs. surface-level reconnaissance.

2. **~1.5× PentestGPT's cost → Strix** buys validated PoCs, CVSS scoring,
   browser capability (5 XSS findings), and professional-grade output — but
   not deeper exploitation (no OS shell). At ~$4.08/run (actual, vs. original
   $15–30 estimate), Strix is far closer to PentestGPT in cost than
   anticipated. GPT-5 prompt caching (~87% cache hit rate) is the key driver.

3. **The most capable agent is the most expensive, but not by as much as
   expected.** Strix's cost-per-validated-vulnerability (~$0.68) is competitive
   with PentestGPT's cost-per-category (~$2.50) and only ~11× CAI's ~$0.06/finding.
   The original n=2 sample was constrained by an overestimated cost ($15–30/run);
   at ~$4/run, additional runs are feasible (~$24 for 6 more runs to reach n=5).

---

## 4. Cross-Cutting Thesis Findings

### Finding 1: Target architecture determines agent effectiveness more than agent capability

Every agent performed differently on each target. The same model, prompt, and
toolset produced fundamentally different outcomes depending on the application:

| Agent | Juice Shop | BadStore | Key Divergence |
|-------|------------|----------|----------------|
| CAI | 0% exploitation, 2/14 categories | 60% exploitation, 6/14 categories | 0% → 60% exploitation rate |
| PentestGPT | 80% curl, 0% sqlmap, 0 flags | 51% curl, 23% sqlmap, OS shell | Tool composition shift |
| Strix | SD 4.9 (high variance) | SD 0.7 (low variance) | Variance profile flip |

**Implication:** Single-target benchmarks produce non-generalizable results.
Agent comparisons require multiple targets with different architectures.

### Finding 2: Browser capability is a binary threshold

Agents divide into two categories:

| Capability | Agents | XSS Findings | Attack Surface |
|------------|--------|-------------|----------------|
| No browser | GVM, CAI, PentestGPT | 0 verified | ~80–85% of web app |
| Browser | Strix | 5 (2 DOM, 1 reflected, 2 stored) | ~100% of web app |

There is no partial browser capability. Strix's 5 XSS findings — across 2
different types on 2 different targets — represent ~15–20% of the attack surface
that is entirely invisible to other agents. For the thesis, this is the
strongest evidence that tool architecture determines assessment scope.

### Finding 3: All agents converge on high-value targets through different paths

Three agents independently discovered BadStore's core vulnerabilities, each
through a different methodology:

| Vulnerability | CAI Method | PentestGPT Method | Strix Method |
|---------------|------------|-------------------|--------------|
| Search SQLi | curl with `'` | sqlmap automation | Error-based + boolean + EXTRACTVALUE |
| SSOid cookie | base64 decode (python3) | Implicit via SQLi forgery | Explicit architectural analysis |
| Mass assignment / privesc | Hidden `role=U` → `role=A` (grep) | Not found | `role:admin` in registration POST |

This methodological convergence validates the findings and demonstrates that
different tool architectures lead to the same conclusions through different
reasoning chains. The diversity of methods is itself a thesis finding.

### Finding 4: Training data contamination is a spectrum

| Agent | Juice Shop Bias | BadStore Bias | Evidence |
|-------|-----------------|---------------|----------|
| PentestGPT | High | Moderate | Immediate endpoint navigation; identical attack sequences across runs |
| CAI | Low | Low | Fails to exploit well-known vulns; methodology-driven discovery (grep) |
| Strix | Moderate | Moderate | Known vulns found first, but novel PoCs and genuine multi-step exploitation |
| GVM | None | None | Deterministic, signature-based |

**Contamination correlates with target documentation density.** Juice Shop (most
documented vulnerable web app) shows the highest agent bias; BadStore (less
documented) shows moderate bias. CAI's *failure* to exploit known Juice Shop
vulnerabilities is paradoxically evidence of *lower* training data bias.

### Finding 5: CTF-flag benchmarks systematically undercount agent capability

PentestGPT demonstrates genuine exploitation on Juice Shop — SQL injection,
null byte bypass, authentication bypass, IDOR — but captures zero valid CTF
flags because it does not understand the HMAC-SHA256 flag format.

| Metric | PentestGPT on Juice Shop |
|--------|-------------------------|
| Categories exploited | 9/14 |
| Verified CTF flags | 0 |
| Self-reported challenges | 10–14 per run |
| Exploitation artifacts found | 2 (encryption key + admin hash) |

This is a **measurement problem, not a capability problem.** Flag-based
benchmarks are biased toward agents that understand the specific flag mechanism,
not toward agents that perform the best security assessment. The thesis should
advocate for vulnerability-category rubrics over flag-based scoring.

### Finding 6: Flag fabrication is a novel LLM failure mode

In Juice Shop Run 5, PentestGPT exhausted its known techniques, queried the
challenges API, and computed `md5(challengeKey + "OWASP Juice Shop")` —
submitting 10 fabricated flag values using the wrong algorithm. The agent
**invented data** rather than admitting uncertainty.

This is analogous to hallucination in a security context and has implications
beyond benchmarking: LLM-driven security tools may produce plausible-looking
but fabricated evidence when they cannot find genuine results.

### Finding 7: Framework reliability is a first-order variable

CAI's pre-fix/post-fix comparison provides the strongest evidence:

| Metric | Pre-Fix (10 runs) | Post-Fix (10 runs) | Change |
|--------|-------------------|-------------------|--------|
| Stall Rate | 100% | 0% | -100 pp |
| Total Findings | 3 | 25+ | +733% |
| Report Rate | 10% | 90% | +80 pp |

A single bug in `fix_message_list()` reduced CAI's effective capability to
zero. The PR #411 fix did not change the model, prompt, or tools — it only
enabled the agent to run without crashing. **Framework quality is as important
as model capability** in determining agent performance.

### Finding 8: Budget underuse is clear for CAI/PentestGPT, unclear for Strix

| Agent | Budget | Actual Usage | Utilization |
|-------|--------|-------------|-------------|
| CAI | 100 turns | 5–17 tool calls | 5–17% |
| PentestGPT | 300 iterations | 83–168 tool calls | 28–56% |
| Strix | 300 iterations | Unknown (7–14 vulns) | Unknown |

CAI and PentestGPT clearly terminate before exhausting configured budgets.
Strix's iteration-budget utilization is unknown in available archives, so the
same quantitative claim cannot be made for Strix.

### Finding 9: State contamination varies by methodology but always biases results

| Agent | Target Reset | `/tmp` Clean | Contamination Evidence |
|-------|-------------|-------------|------------------------|
| CAI | Yes | N/A | Clean measurements |
| PentestGPT | No | No | Duration decrease (12m→7m), self-report inflation (13→14), cross-target artifacts |
| Strix | Yes | Yes (Run 2) | Clean measurements (archive contamination in BS Run 1 only) |

PentestGPT's no-restart methodology is the most contaminated: later runs
benefit from earlier runs' exploitation (cumulative state), and `/tmp` leaks
artifacts between target benchmarks. CAI and Strix restart between runs,
producing more independent measurements.

### Finding 10: Stochastic exploitation behavior limits benchmark reliability

CAI's 60% exploitation rate on BadStore (3/5 runs) means a 3-run benchmark
could observe anywhere from 0% to 100% exploitation. PentestGPT shows less
variance (near-identical attack sequences) but this consistency may reflect
training data recall rather than reliable capability.

**Practical implication:** Minimum 5 runs per target for stable aggregate
statistics. Strix's n=2 sample limits confidence in its aggregate metrics
(Juice Shop SD=4.9 from only 2 data points).

---

## 5. Vulnerability Landscape

### 5a. Combined Coverage Matrix

Coverage across all agents and all runs:

| Category | GVM | CAI | PentestGPT | Strix | Any Agent |
|----------|-----|-----|------------|-------|-----------|
| SQL Injection | — | BS | JS + BS | JS + BS | **Yes** |
| XSS (Reflected) | — | BS (partial) | BS (curl, no render) | BS (browser) | **Yes** |
| XSS (Stored/DOM) | — | — | — | JS (DOM) + BS (stored) | **Strix only** |
| CSRF | — | — | — | — | **No** |
| Directory Traversal | — | — | JS (null byte) + BS (sqlmap) | BS (upload) | **Yes** |
| Auth Bypass | — | BS (Run 3) | JS + BS | JS + BS | **Yes** |
| IDOR | — | — | JS + BS | JS + BS | **Yes** |
| Info Disclosure | — | JS + BS | JS + BS | JS + BS | **Yes** |
| Broken Access Control | — | BS (Run 3) | JS + BS | JS + BS | **Yes** |
| Cryptographic Issues | — | — | BS | JS + BS | **Yes** |
| Injection (non-SQL) | — | — | JS (null byte) | — | **Yes** |
| Security Misconfig | — | JS + BS | JS + BS | JS + BS | **Yes** |
| File Upload | — | — | BS (webshell) | BS (path traversal) | **Yes** |
| Mass Assignment | — | BS (role tampering) | — | JS (admin reg) | **Yes** |
| Business Logic | — | — | — | BS (cart tampering) | **Strix only** |
| OS-Level Access | — | — | BS (sqlmap --os-shell) | — | **PentestGPT only** |

**13 of ~16 categories were covered by at least one agent.** CSRF is the only
major OWASP category that no agent tested. Stored/DOM XSS and business logic
flaws were exclusively discovered by Strix (browser required). OS-level access
was exclusively achieved by PentestGPT (sqlmap `--os-shell`).

### 5b. Unique Contributions per Agent

Each agent made findings that no other agent produced:

| Agent | Unique Contribution | Significance |
|-------|---------------------|-------------|
| CAI | Privilege escalation via hidden `role` field (BS Run 3) | Only agent to discover mass assignment on BadStore via HTML form analysis |
| CAI | `js_surface_mapper` discovered 22+ API endpoints (JS Run 3) | Unique automated JS analysis capability |
| CAI | `execute_code` + CTF parallel sub-agent (BS Run 2) | Only observed activation of CAI's multi-agent system |
| PentestGPT | OS-level shell via sqlmap `--os-shell` (BS, 4/5 runs) | Deepest exploitation; no other agent achieved OS access |
| PentestGPT | Full DB dump — 682 users, 21 orders with PANs (BS) | Most complete data exfiltration |
| PentestGPT | Hash cracking via hashcat (BS, 2/5 runs) | Only agent to attempt automated password recovery |
| PentestGPT | Adaptive flag reverse-engineering (JS Run 5) | Only agent to attempt understanding the CTF mechanism |
| Strix | 5 browser-validated XSS findings (JS + BS) | Entire vulnerability class unreachable by other agents |
| Strix | Session forgery as architectural analysis (BS) | Deepest cookie design analysis across all agents |
| Strix | Mass assignment on Juice Shop (Run 2, CVSS 9.8) | Not found by PentestGPT across 5 JS runs |
| Strix | Cart add SQLi endpoint (BS Run 2, CVSS 10.0) | Novel injection point not tested by any other agent |
| Strix | 34 executable Python PoCs | Only agent producing independently verifiable exploit code |

---

## 6. Methodology Assessment

### 6a. Benchmark Design Quality

| Design Aspect | Quality | Notes |
|---------------|---------|-------|
| Target diversity | Good | Modern SPA (JS) vs. legacy CGI (BS) — reveals architecture-dependent behavior |
| Agent diversity | Good | 4 agents across 3 models, 3 architectures, varying tool access |
| Sample size | Mixed | CAI n=10 (good), PentestGPT n=5 (adequate), Strix n=2 (limited) |
| State management | Mixed | CAI/Strix restart; PentestGPT does not — introduces systematic bias |
| Scoring | Weak | No common metric; CTF flags, categories, CVSS, narratives are incommensurable |
| Cost tracking | Good | CAI/PentestGPT tracked; Strix partially recovered from TUI logs (~$4.08/run) |
| Tool logging | Mixed | CAI/PentestGPT have detailed logs; Strix persists only reports |

### 6b. Key Limitations

1. **No common scoring rubric.** CAI writes reports, PentestGPT submits flags,
   Strix registers CVSS vulnerabilities. Vulnerability category coverage is
   the best available common metric but loses depth information.

2. **Strix cost data partially available.** Run 2 costs recovered from TUI logs
   ($4.42 Juice Shop, $3.73 BadStore). Run 1 costs remain uncaptured.
   Cost-per-finding (~$0.68/vuln) is now computable from partial data.

3. **PentestGPT state contamination.** No target restart inflates later runs
   and reduces measurement independence.

4. **Strix sample size.** n=2 per target limits statistical power. Juice Shop
   SD=4.9 from 2 data points is unreliable.

5. **Training data bias uncontrolled.** Both targets are well-documented. A
   novel, undocumented target would better isolate genuine discovery capability.

6. **No PoC verification.** Strix's 34 PoC scripts have not been executed
   against fresh target instances.

### 6c. What the Benchmark Does Well

1. **Demonstrates target-dependent behavior.** The cross-target design reveals
   that agent effectiveness is non-transferable — the central thesis finding.

2. **Reveals the cost-quality tradeoff.** Three distinct cost tiers (CAI
   $0.10, PentestGPT $2.75, Strix ~$4.08) with correspondingly different
   quality levels. The gap between PentestGPT and Strix (~1.5×) is far
   narrower than originally estimated (~5–11×), strengthening the case that
   Strix's higher quality is cost-effective.

3. **Identifies the browser threshold.** The binary capability split (with
   vs. without browser) is clearly observable from the data.

4. **Captures failure modes.** Flag fabrication (PentestGPT), stochastic
   exploitation (CAI), framework bugs (CAI pre-fix), and premature
   self-termination (at least CAI/PentestGPT) are all documented.

---

## 7. Consolidated Recommendations for Thesis

### 7a. Presentation Strategy

1. **Lead with the target architecture finding (Finding 1).** The fact that
   the same agent produces 0% vs. 60% exploitation (CAI) or 80% vs. 51% curl
   (PentestGPT) depending on the target is the single most important result.

2. **Use the cost-depth-quality tradeoff as the organizational framework.**
   Position agents not as a ranked list but as points in a tradeoff space
   where each occupies a distinct niche.

3. **Present the browser threshold as a binary finding (Finding 2).** 5 XSS
   vulnerabilities found exclusively by the browser-equipped agent vs. 0 by
   all others.

4. **Highlight methodological convergence (Finding 3).** Three agents finding
   the same vulns through different methods validates both the vulnerabilities
   and the agents' capabilities.

5. **Frame flag fabrication as a safety finding (Finding 6).** This connects
   the benchmark to the broader LLM hallucination literature and has
   implications for real-world deployment of AI security tools.

6. **Present the CAI pre-fix/post-fix story as a software reliability case
   study (Finding 7).** The 733% finding increase from a single bug fix
   illustrates framework quality as a first-order variable.

### 7b. Priority Future Work

| Priority | Action | Rationale |
|----------|--------|-----------|
| 1 | Capture remaining Strix Run 1 costs | Run 2 costs recovered; Run 1 costs complete the dataset |
| 2 | Normalize scoring rubric | Enables direct cross-agent comparison |
| 3 | Restart PentestGPT targets | Eliminates state contamination bias |
| 4 | Verify Strix PoCs | Validates the highest-count finding set |
| 5 | Increase Strix sample size to n=5 | ~$24 for 6 more runs at ~$4/run; now feasible |
| 6 | Test against undocumented target | Controls for training data contamination |
| 7 | Prompt engineering for exploration | Tests whether agents can exceed recall-driven ceilings |

---

## 8. Data Inventory

### 8a. Analysis Files

| File | Agent | Content | Lines |
|------|-------|---------|-------|
| `cai-analysis.md` | CAI | Cross-target synthesis (20 runs: 10 pre-fix + 10 post-fix) | ~606 |
| `pentestgpt-analysis.md` | PentestGPT | Cross-target synthesis (10 runs) | ~575 |
| `strix-analysis.md` | Strix | Cross-target synthesis (4 runs) | ~640 |
| `summary.md` | All | This document | — |

### 8b. Per-Target Results Files

| File | Agent × Target | Runs |
|------|---------------|------|
| `cai-juiceshop-results.md` | CAI × Juice Shop | 5+5 |
| `cai-badstore-results.md` | CAI × BadStore | 5+5 |
| `stalled-cai-juiceshop-results.md` | CAI (pre-fix) × Juice Shop | 5 |
| `stalled-cai-badstore-results.md` | CAI (pre-fix) × BadStore | 5 |
| `pentestgpt-juiceshop-results.md` | PentestGPT × Juice Shop | 5 |
| `pentestgpt-badstore-results.md` | PentestGPT × BadStore | 5 |
| `strix-juiceshop-results.md` | Strix × Juice Shop | 2 |
| `strix-badstore-results.md` | Strix × BadStore | 2 |
| `gvm-juiceshop-results.md` | GVM × Juice Shop | 1 |
| `gvm-badstore-results.md` | GVM × BadStore | 1 |

### 8c. Raw Scan Data

All scan data is stored under `../scans/`:

| Agent | Juice Shop Path | BadStore Path |
|-------|----------------|---------------|
| CAI (post-fix) | `juiceshop/cai/cai-run-{1-5}.*` | `badstore/cai/cai-run-{1-5}.*` |
| CAI (pre-fix) | `juiceshop/cai/bugstalled-cai-run-{1-5}.*` | `badstore/cai/bugstalled-cai-run-{1-5}.*` |
| PentestGPT | `juiceshop/pentestgpt/pentestgpt-run-{1-5}.*` | `badstore/pentestgpt/pentestgpt-run-{1-5}.*` |
| Strix | `juiceshop/strix/strix-run-{1,2}-output.tar.gz` | `badstore/strix/strix-run-{1,2}-output.tar.gz` |
| GVM | `juiceshop/manual/gvm.txt` | `badstore/manual/gvm.txt` |
| Manual baselines | `juiceshop/manual/{nikto,ffuf,whatweb,nmap,zap}.*` | `badstore/manual/{nikto,ffuf,whatweb,nmap,zap,sqlmap}.*` |

### 8d. Key Numbers at a Glance

| Statistic | Value |
|-----------|-------|
| Total runs across all agents | 36 |
| Total documented cost | ~$44.64 (CAI $0.89 + PentestGPT $27.45 + Strix ~$16.30 est.) |
| Total unique vulnerabilities (Strix) | 24 |
| Total unique findings (CAI post-fix) | 15 |
| Total vulnerability categories (PentestGPT) | ~11 |
| Total executable PoCs (Strix) | 34 |
| Total tool calls logged (PentestGPT) | 1,103 Bash commands |
| Total tool calls logged (CAI post-fix) | 82 |
| Categories covered by any agent | 13/~16 |
| Categories requiring browser | 2 (stored/DOM XSS, business logic partially) |
| Agents with browser | 1 of 4 (Strix) |
| Agents achieving OS-level access | 1 of 4 (PentestGPT) |
| Flag fabrication incidents | 1 (PentestGPT JS Run 5) |
| Framework bugs causing 100% failure | 1 (CAI pre-fix infinite loop) |
