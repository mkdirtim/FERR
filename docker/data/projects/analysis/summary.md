# Benchmark Summary — Comparative Evaluation of LLM-Driven Penetration Testing Agents

> **Scope:** Cross-agent, cross-target synthesis of all benchmark data from
> the empirical evaluation of four penetration testing agents on two
> deliberately vulnerable web applications. Consolidates findings from
> `cai-analysis.md`, `pentestgpt-analysis.md`, and `strix-analysis.md` into
> a single reference document for thesis integration.
>
> **Research context:** This benchmark evaluates whether LLM-driven autonomous
> agents can perform application-layer security assessments that traditional
> signature-based scanners cannot, and characterizes the cost–quality–depth
> tradeoff space across different agent architectures. The evaluation uses a
> multi-agent, multi-target design to control for target-dependent effects.

---

## 1. Benchmark Overview

Four agents — one traditional signature-based scanner (GVM, serving as
baseline) and three LLM-driven autonomous agents (CAI, PentestGPT, Strix) —
were benchmarked against two deliberately vulnerable web applications,
producing 36 total runs across a controlled Docker network environment.

| Agent | Model | Runs (JS + BS) | Total Cost | Output Format |
|-------|-------|---------------|------------|---------------|
| GVM (baseline) | N/A (signature scanner) | 2 (1+1) | $0.00 | Template report |
| CAI | GPT-5.2 | 20 (10+10) | $1.28 | `/tmp/report.md` |
| PentestGPT | Sonnet 4.5 | 10 (5+5) | $27.45 | `[FLAG]` + walkthrough |
| Strix | GPT-5 | 4 (2+2) | ~$16.30 (est. from partial data) | CVSS + executable PoC |
| **Total** | — | **36** | **~$45.03** | — |

**Targets (selected to maximize architectural diversity):**
- **OWASP Juice Shop v19.1.1** — Modern Node.js SPA with 110 CTF challenges, SQLite backend, Angular frontend. Extensively documented; high training data contamination risk.
- **BadStore v1.2.3s** — Legacy Apache/CGI application (~2004), MySQL backend, 14+ known vulnerability categories, no CTF system. Less extensively documented; moderate contamination risk.

---

## 2. Master Comparison

### 2a. Agent Profiles

| Dimension | GVM | CAI | PentestGPT | Strix |
|-----------|-----|-----|------------|-------|
| **Architecture** | Plugin-based scanner | Single-agent + sub-agents | Single-agent (Claude Code SDK) | Multi-agent + browser + proxy |
| **Model** | N/A | GPT-5.2 | Sonnet 4.5 | GPT-5 |
| **Mean Cost/Run** | $0.00 | $0.095 | $2.75 | ~$4.08 (partial data) |
| **Mean Duration** | 22m 17s | ~5 min | 8m 48s | ~50 min |
| **Browser** | No | No | No | Yes (Playwright) |
| **Proxy** | No | No | No | Yes (Caido) |
| **Kali Tools Used** | N/A | None | sqlmap, gobuster, nmap, hashcat, mysql | Terminal (full Kali) |
| **Target Reset** | N/A | Yes | No | Yes |
| **Completion Rate** | 100% | 80% (post-fix) | 100% | 100% |
| **Runs per Target** | 1 | 5 | 5 | 2 |

> **Sample size and design notes:** GVM (n=1) and Strix (n=2) have limited
> statistical power; aggregate statistics for these agents carry wider confidence
> intervals. PentestGPT did not reset targets between runs (cumulative state),
> while CAI and Strix did — this design difference limits direct comparison of
> run-to-run consistency metrics. See §6 for full methodology assessment.

### 2b. Quantitative Performance Summary

| Metric | GVM | CAI (post-fix) | PentestGPT | Strix |
|--------|-----|----------------|------------|-------|
| Total Unique Findings | 1 (ICMP) | 15 | ~11 categories | 24 vulns |
| Mean Findings/Run | 0 | 2.8 | N/A (category) | 8.5 |
| Juice Shop Categories | 0/14 | 2/14 | 9/14 | 10/14 |
| BadStore Categories | 0/14 | 6/14 | 10/14 | 12+/14 |
| Combined Categories | 0/14 | 7/14 | ~11/14 | 12/14 |
| XSS Findings | 0 | 0 | 0 (verified) | 5 |
| OS-Level Access | No | No | Yes (4/5 BS runs) | No |
| Mean CVSS | N/A | N/A | N/A | ~8.7 |
| Cost/Finding | $0.00 | ~$0.06 | ~$2.50/cat | ~$0.68/vuln |

> **Comparability note:** Finding counts and cost-per-finding ratios are not
> directly comparable across agents due to different output formats: GVM reports
> NVT signatures, CAI self-reports passive findings, PentestGPT counts exploited
> vulnerability categories, and Strix produces CVSS-scored PoCs. See §6 for
> detailed methodology assessment.

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

## 4. Principal Findings

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

**13 of 15 expanded categories (12/14 on the standard rubric) were covered by
at least one agent.** CSRF and non-SQL injection are the only standard
categories that no agent tested. Stored/DOM XSS and business logic flaws
were exclusively discovered by Strix (browser required). OS-level access
was exclusively achieved by PentestGPT (sqlmap `--os-shell`). The expanded
rubric adds Mass Assignment and Business Logic beyond the standard 14
categories used in per-target comparison tables.

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
| Sample size | Mixed | CAI n=10 (good), PentestGPT n=5 (adequate), Strix n=2 (limited), GVM n=1 (baseline) |
| State management | Mixed | CAI/Strix restart between runs; PentestGPT does not — introduces systematic bias |
| Scoring | Weak | No common metric; CTF flags, categories, CVSS, narratives are incommensurable |
| Cost tracking | Good | CAI/PentestGPT tracked natively; Strix partially recovered from TUI logs (~$4.08/run) |
| Tool logging | Mixed | CAI/PentestGPT have detailed execution logs; Strix persists only vulnerability reports |

### 6b. Threats to Validity

**Internal validity:**

1. **State contamination (PentestGPT).** PentestGPT did not reset targets
   between runs, introducing cumulative state that inflates later runs'
   findings and reduces measurement independence. Evidence: monotonically
   decreasing duration (12m 56s → 7m 24s on BadStore), increasing self-reported
   challenges (13 → 14 on Juice Shop), and cross-target `/tmp` artifact leakage.
   CAI and Strix reset targets between runs, producing more independent measurements.

2. **Stochastic exploitation (CAI).** CAI's 60% BadStore exploitation rate
   (3/5 runs) means a 3-run sample could observe 0–100% exploitation. With
   n=5, the 95% confidence interval for the true exploitation rate is wide
   (15–95% by Clopper-Pearson exact method). Results are sensitive to sample size.

3. **Framework reliability confound (CAI).** The pre-fix/post-fix split means
   CAI's 20-run dataset conflates framework bug effects with agent capability.
   Post-fix results (n=10) should be treated as the primary dataset.

**External validity:**

4. **Training data contamination.** Both targets are well-documented in LLM
   training corpora. Juice Shop is the most widely documented deliberately
   vulnerable web application. Results may not generalize to novel, undocumented
   targets where agents cannot rely on memorized attack sequences.

5. **Two-target limitation.** The cross-target design improves on single-target
   benchmarks but two targets cannot establish general claims about agent
   behavior across the full diversity of web application architectures.

6. **Model-specific results.** Each agent uses a fixed model (GPT-5.2, Sonnet
   4.5, GPT-5). Results reflect the specific model–agent combination and may
   not generalize to other model versions or providers.

**Construct validity:**

7. **No common scoring rubric.** CAI writes reports, PentestGPT submits CTF
   flags, Strix registers CVSS-scored vulnerabilities. Vulnerability category
   coverage (14-category OWASP-derived rubric) is the best available common
   metric but compresses depth and quality information. Cost-per-finding ratios
   are incommensurable across agents due to different finding granularity.

8. **Measurement approach differences.** Per-run tables use "Self-Reported
   Findings" for CAI and PentestGPT (agent's own summary) vs. "Vulnerabilities
   Reported" for Strix (count of persisted vuln-*.md files). This naming
   difference reflects a real methodological distinction: Strix findings are
   externally countable artifacts, while CAI/PentestGPT counts depend on the
   agent's self-assessment and may include inflation or fabrication.

**Statistical power:**

9. **Unequal and small sample sizes.** GVM n=1 (baseline only), Strix n=2 per
   target (cost-constrained), PentestGPT n=5, CAI n=5 (post-fix). Standard
   deviations for Strix (e.g., SD=4.9 from 2 Juice Shop data points) are
   unreliable. Aggregate statistics for Strix carry wider confidence intervals
   than those for CAI or PentestGPT.

10. **Strix cost data partial.** Run 2 costs recovered from TUI terminal logs
    ($4.42 Juice Shop, $3.73 BadStore); Run 1 costs remain uncaptured.
    Cost-per-finding (~$0.68/vuln) is computed from partial data and should be
    treated as an estimate. The extrapolated total (~$16.30 for 4 runs) assumes
    Run 1 costs are similar to Run 2.

11. **No independent PoC verification.** Strix's 34 Python PoC scripts have
    not been executed against fresh target instances. Finding counts assume
    PoC validity based on structural review, not empirical verification.

### 6c. Strengths of the Evaluation Design

1. **Cross-target design reveals non-transferability.** The dual-target
   architecture is the single most important design decision: every agent
   performs differently on each target, demonstrating that single-target
   benchmarks produce non-generalizable results.

2. **Reveals the cost–quality–depth tradeoff empirically.** Three distinct
   cost tiers ($0.10, $2.75, ~$4.08/run) with measurably different quality
   levels. The PentestGPT–Strix gap (~1.5×) is far narrower than originally
   estimated (~5–11×), an empirical finding that was only possible with
   recovered cost data.

3. **Identifies the browser capability threshold.** The binary capability
   split (0 verified XSS without browser vs. 5 with browser) is unambiguous.

4. **Documents failure modes systematically.** Flag fabrication (PentestGPT
   Run 5), stochastic exploitation (CAI), framework bugs (CAI pre-fix),
   and premature self-termination (CAI/PentestGPT) are documented with
   specific evidence, contributing to the broader understanding of LLM
   agent reliability.

5. **Includes a traditional scanner baseline.** GVM's 0% application-layer
   detection rate across both targets provides a clear quantitative baseline
   that contextualizes the LLM agents' contributions.

---

## 7. Discussion and Future Work

### 7a. Implications for Thesis Presentation

1. **The target architecture finding (Finding 1) is the central contribution.**
   The observation that the same agent produces 0% vs. 60% exploitation (CAI)
   or shifts from 80% curl to 51% curl + 23% sqlmap (PentestGPT) depending
   on target architecture challenges the validity of single-target benchmarks
   prevalent in the literature.

2. **The cost–depth–quality tradeoff provides a novel analytical framework.**
   Rather than ranking agents linearly, this evaluation positions them in a
   multi-dimensional tradeoff space where no agent dominates on all axes.
   This framing better captures the practical considerations for deploying
   LLM-driven security assessment tools.

3. **The browser capability threshold is a binary architectural finding.**
   The 0 vs. 5 XSS split between CLI-only and browser-equipped agents is
   unambiguous and has direct implications for agent architecture design.

4. **Methodological convergence validates findings independently.** Three
   agents discovering the same vulnerabilities through different methods
   provides triangulation that strengthens confidence in both the vulnerability
   assessments and the agents' genuine capabilities.

5. **Flag fabrication connects to the LLM hallucination literature.**
   PentestGPT's fabrication of 10 flag values using an incorrect algorithm
   represents a domain-specific manifestation of hallucination with
   implications for the trustworthiness of autonomous security tools.

6. **The CAI pre-fix/post-fix comparison isolates framework reliability.**
   The 733% finding increase from a single bug fix, with no changes to model,
   prompt, or tools, provides clean evidence that framework quality is a
   first-order variable in agent performance — a confound that most existing
   benchmarks do not control for.

### 7b. Limitations and Future Work

| Priority | Action | Rationale | Threat Addressed |
|----------|--------|-----------|------------------|
| 1 | Normalize scoring rubric across agents | Enables direct quantitative comparison | Construct validity (§6b.7) |
| 2 | Restart PentestGPT targets between runs | Eliminates state contamination bias | Internal validity (§6b.1) |
| 3 | Increase Strix sample size to n=5 | ~$24 for 6 additional runs at ~$4/run; now feasible with actual cost data | Statistical power (§6b.9) |
| 4 | Verify Strix PoCs on fresh instances | Validates the highest-count finding set | Construct validity (§6b.11) |
| 5 | Test against undocumented target | Controls for training data contamination | External validity (§6b.4) |
| 6 | Capture remaining Strix Run 1 costs | Completes partial cost dataset | Statistical power (§6b.10) |
| 7 | Prompt engineering for continued exploration | Tests whether agents can exceed recall-driven performance ceilings | External validity |

---

## 8. Data Inventory

### 8a. Analysis Files

| File | Agent | Content | Lines |
|------|-------|---------|-------|
| `cai-analysis.md` | CAI | Cross-target synthesis (20 runs: 10 pre-fix + 10 post-fix) | ~606 |
| `pentestgpt-analysis.md` | PentestGPT | Cross-target synthesis (10 runs) | ~575 |
| `strix-analysis.md` | Strix | Cross-target synthesis (4 runs) | ~640 |
| `summary.md` | All | This document | — |
| `learnings.md` | All | Cross-agent comparative analysis and design learnings | ~489 |
| `costs-analysis.md` | All | Artifact-sourced cost data with per-run source line references | ~98 |

### 8b. Per-Target Results Files

| File | Agent × Target | Runs |
|------|---------------|------|
| `runs/cai-juiceshop-results.md` | CAI × Juice Shop | 5+5 |
| `runs/cai-badstore-results.md` | CAI × BadStore | 5+5 |
| `runs/archive/stalled-cai-juiceshop-results.md` | CAI (pre-fix) × Juice Shop | 5 |
| `runs/archive/stalled-cai-badstore-results.md` | CAI (pre-fix) × BadStore | 5 |
| `runs/pentestgpt-juiceshop-results.md` | PentestGPT × Juice Shop | 5 |
| `runs/pentestgpt-badstore-results.md` | PentestGPT × BadStore | 5 |
| `runs/strix-juiceshop-results.md` | Strix × Juice Shop | 2 |
| `runs/strix-badstore-results.md` | Strix × BadStore | 2 |
| `manual/gvm-juiceshop-results.md` | GVM × Juice Shop | 1 |
| `manual/gvm-badstore-results.md` | GVM × BadStore | 1 |

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
| Total documented cost | ~$45.03 (CAI $1.28 + PentestGPT $27.45 + Strix ~$16.30 est.) |
| Total unique vulnerabilities (Strix) | 24 |
| Total unique findings (CAI post-fix) | 15 |
| Total vulnerability categories (PentestGPT) | ~11 |
| Total executable PoCs (Strix) | 34 |
| Total tool calls logged (PentestGPT) | 1,103 Bash commands |
| Total tool calls logged (CAI post-fix) | 82 |
| Categories covered by any agent | 13/15 expanded (12/14 standard) |
| Categories requiring browser | 2 (stored/DOM XSS, business logic partially) |
| Agents with browser | 1 of 4 (Strix) |
| Agents achieving OS-level access | 1 of 4 (PentestGPT) |
| Flag fabrication incidents | 1 (PentestGPT JS Run 5) |
| Framework bugs causing 100% failure | 1 (CAI pre-fix infinite loop) |
