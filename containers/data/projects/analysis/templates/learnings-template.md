# {AGENT_NAME} — Learnings for OpenHack

> **Context:** This template synthesizes findings from the project analysis
> (`agent-project-template.md`) and the benchmark results (`results-template.md`)
> into actionable learnings for OpenHack. It is filled **last**, after both
> the codebase analysis and benchmark runs are complete.

| Field | Value |
|-------|-------|
| **Agent** | {AGENT_NAME} {AGENT_VERSION} |
| **Repository** | {REPO_URL} |
| **Framework** | {AGENT_FRAMEWORK} |
| **License** | {LICENSE} |
| **Date Reviewed** | {DATE} |

> **Inputs required to fill this template:**
>
> | Input | Template | Status |
> |-------|----------|--------|
> | Codebase analysis | `agent-project-template.md` | {done / pending} |
> | Benchmark: {TARGET_1} | `results-template.md` | {done / pending} |
> | Benchmark: {TARGET_2} | `results-template.md` | {done / pending} |
>
> **Workflow:** Read the project analysis for design intent, then compare
> with actual benchmark behavior to identify gaps, surprises, and patterns
> worth adopting.

---

## 1. Design vs. Observed Behavior

> For each aspect below, compare **what the code is designed to do**
> (from `agent-project-template.md`) with **what actually happened**
> in benchmark runs (from `results-template.md`). Focus on discrepancies.

### 1a. Agent Loop

- **Designed:** {summarize from project analysis § 3b–3c}
- **Observed:** {what actually happened in runs — did it follow the designed flow?}
- **Discrepancies:** {where did actual behavior diverge from design?}

### 1b. Tool Usage

- **Available tools:** {from project analysis § 4a}
- **Actually used:** {from results § 1c — which tools were invoked, which were ignored?}
- **Tool selection quality:** {did the agent pick appropriate tools for each phase?}

### 1c. Phase Transitions

- **Designed transitions:** {from project analysis § 3e}
- **Observed transitions:** {from benchmark logs — how did the agent actually move between phases?}
- **Efficiency:** {time wasted in wrong phases, premature transitions, stuck loops?}

### 1d. Termination Behavior

- **Designed stop conditions:** {from project analysis § 3d}
- **Actual stop reason per run:** {from benchmark logs — budget, timeout, self-termination?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 2. Empirical Execution Analysis

### 2a. Observed Execution Trace (representative run)

> Paste or summarize a representative execution trace from a benchmark run.
> Annotate phase boundaries.

```
[T+00:00] INIT    — loaded config, target=http://juiceshop:3000
[T+00:03] RECON   — nmap scan → 1 open port (3000/tcp)
[T+00:15] RECON   — curl homepage, whatweb fingerprint → Express/Node.js
[T+00:30] RECON   — directory brute-force (ffuf) → 12 endpoints
[T+01:00] EXPLOIT — SQLi on /rest/products/search?q= → success
[T+01:30] POST    — extracted user table via SQLi → 15 hashes
[T+02:00] EXPLOIT — XSS on /#/search?q= → reflected XSS confirmed
[T+03:00] REPORT  — wrote /tmp/report.md
[T+03:05] STOP    — all hypotheses exhausted
```

> Replace with actual trace data.

### 2b. Time-per-Phase Distribution

| Phase | % of Tool Calls | % of Duration | Notes |
|-------|-----------------|---------------|-------|
| Initialization | | | |
| Reconnaissance | | | |
| Hypothesis / Planning | | | |
| Exploitation | | | |
| Post-Exploitation | | | |
| Reporting | | | |

> Cross-reference with `results-template.md` § 1d (Time Budget Allocation).

### 2c. Evidence Quality per Finding

| Finding | Evidence (log / output / PoC) | Reproducible? | Severity | Confidence |
|---------|-------------------------------|---------------|----------|------------|
| | | | | |

> Cross-reference with `results-template.md` § 1b (Flag Validity Audit).

---

## 3. Reconnaissance Effectiveness

- **Initial steps observed:** {what did it actually do first?}
- **Endpoint coverage:** {how many endpoints discovered vs. known total?}
- **Technology fingerprinting accuracy:** {correct identifications vs. misses?}
- **Training data dependency:** {evidence of memorized knowledge vs. genuine discovery?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 4. Exploitation Effectiveness

### 4a. Vulnerability Detection Quality

- **Categories attempted:** {from results § 3}
- **Categories successfully exploited:** {from results § 3}
- **False positives observed:** {agent reported but not real?}
- **False negatives observed:** {known vulns the agent missed?}

### 4b. Attack Chaining

- **Multi-step attacks observed:** {did it chain vulns in practice?}
- **Deepest exploitation chain:** {describe the longest successful chain}

### 4c. Browser vs. CLI Impact

- **Vulns found via browser:** {if applicable}
- **Vulns missed due to CLI-only:** {categories that required browser interaction}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 5. Reporting Quality

- **Output quality:** {is the report useful, well-structured, accurate?}
- **Severity accuracy:** {does the agent over- or under-rate findings?}
- **Evidence quality:** {are PoCs reproducible?}
- **Report overhead:** {from results § 1d — what % of budget was spent on reporting?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 6. What Worked Well

List specific techniques, patterns, or design decisions that produced good results.
Cite evidence from both code review and benchmark runs.

**L1. {TITLE}**
{Description. Why it worked. Evidence from code + runs.}

**L2. {TITLE}**
{Description.}

**L3. {TITLE}**
{Description.}

---

## 7. What Didn't Work

List specific failures, limitations, or anti-patterns observed.
Cite evidence from both code review and benchmark runs.

**F1. {TITLE}**
{Description. Why it failed. Evidence from code + runs.}

**F2. {TITLE}**
{Description.}

**F3. {TITLE}**
{Description.}

---

## 8. Code Worth Studying

Reference specific files, functions, or modules from the agent's codebase
that contain patterns worth adopting or learning from.

| File / Module | What It Does | Why It's Interesting |
|---------------|--------------|----------------------|
| `{path}` | {description} | {why OpenHack should look at this} |
| `{path}` | {description} | {why} |

---

## 9. Scorecard Validation

> Compare the code-review scores from `agent-project-template.md` § 9
> with actual benchmark performance. Adjust where empirical evidence
> contradicts the code-review assessment.

| Criterion | Code Review Score | Benchmark-Validated Score | Delta | Notes |
|-----------|-------------------|---------------------------|-------|-------|
| Flow traceability | | | | |
| Tool-use transparency | | | | |
| Reproducibility | | | | |
| Detection coverage | | | | |
| False-positive handling | | | | |
| Level of autonomy | | | | |
| Execution safety | | | | |
| Extensibility | | | | |
| Cost awareness | | | | |
| Adoptability for OpenHack | | | | |

**Validated overall score:** {sum} / 50

---

## 10. Actionable Recommendations for OpenHack

Prioritized list of concrete changes or features to adopt in OpenHack,
synthesized from code analysis (project template) and empirical results
(benchmark template).

### Must Have

- [ ] {Recommendation — high impact, directly addresses a gap}
- [ ] {Recommendation}

### Should Have

- [ ] {Recommendation — moderate impact}
- [ ] {Recommendation}

### Could Have

- [ ] {Recommendation — nice to have, lower priority}
- [ ] {Recommendation}

---

## 11. Comparison with Other Agents

*Fill in after analyzing multiple agents.*

| Aspect | {AGENT_1} | {AGENT_2} | {AGENT_3} | Best for OpenHack |
|--------|-----------|-----------|-----------|-------------------|
| Agent loop design | | | | |
| Tool integration | | | | |
| Recon effectiveness | | | | |
| Exploit effectiveness | | | | |
| Browser support | | | | |
| Reporting quality | | | | |
| Cost efficiency | | | | |
| Code quality | | | | |
| Scorecard (total / 50) | | | | |
