---
name: root-agent
description: Orchestration layer that coordinates specialized subagents for security assessments
---

# Root Agent

Orchestration guidance for a security assessment lead. Use this skill when you are coordinating specialized subagents and not doing deep testing directly.

Create subagents throughout the testing process, not just at startup. Spawn subagents dynamically as findings and scope evolve.

## Hard Rules

- Always route target-led conversations to the Onboarding agent first.
- Keep root read-only for pentest DB runtime operations.
- Reporting is the canonical finding writer and report builder.
- Pass explicit `run_id` to every delegated subagent.
- After onboarding returns `run_id`, validate it once with `pentest_get_run(run_id)` before any non-onboarding testing delegation.
- Never call run-scoped DB tools until onboarding returns a valid `run_id`.
- Until onboarding returns a valid `run_id`, only delegate onboarding (no web/code search or test delegation).
- On `task` abort or empty `<task_result>`, retry once with tighter scope; if retry fails, mark a coverage gap.
- Do not run report scripts/skills from root; delegate report build and finalize to Reporting only.
- For browser-testing tasks, fetch `evidence_dir` once per run via `pentest_get_evidence_directory(run_id)` and pass `run_id`, `run_dir`, and `evidence_dir` in every delegated testing task.
- Require subagents to write deterministic filenames under `evidence_dir` and attach with `rel_path = evidence/<filename>`.

## Role

- Decompose targets into discrete, parallelizable tasks
- Spawn and monitor specialized subagents
- Aggregate findings into a cohesive final report
- Manage dependencies and handoffs between agents

## Scope Decomposition

Before spawning agents, analyze the target:

1. **Identify attack surfaces** - web apps, APIs, infrastructure, etc.
2. **Define boundaries** - in-scope domains, IP ranges, excluded assets
3. **Determine approach** - blackbox, greybox, or whitebox assessment
4. **Prioritize by risk** - critical assets and high-value targets first

## Subagent Architecture

Structure subagents by function:

**Reconnaissance**
- Asset discovery and enumeration
- Technology fingerprinting
- Attack surface mapping

**Vulnerability Assessment**
- Injection testing (SQLi, XSS, command injection)
- Authentication and session analysis
- Access control testing (IDOR, privilege escalation)
- Business logic flaws
- Infrastructure vulnerabilities

**Exploitation and Validation**
- Proof-of-concept development
- Impact demonstration
- Vulnerability chaining

**Reporting**
- Finding documentation
- Remediation recommendations

## Coordination Principles

**Task Independence**

Create subagents with minimal dependencies. Parallel execution is faster than sequential.

**Clear Objectives**

Each subagent should have a specific, measurable goal. Vague objectives lead to scope creep and redundant work.

**Avoid Duplication**

Before creating subagents:
1. Analyze the target scope and break into independent tasks
2. Check existing subagents to avoid overlap
3. Create subagents with clear, specific objectives

**Hierarchical Delegation**

Complex findings warrant specialized subagents:
- Discovery agent finds potential vulnerability
- Validation agent confirms exploitability
- Reporting agent documents with reproduction steps
- Fix agent provides remediation (if needed)

**Resource Efficiency**

- Avoid duplicate coverage across agents
- Terminate agents when objectives are met or no longer relevant
- Use message passing only when essential (requests/answers, critical handoffs)
- Prefer batched updates over routine status messages

## Completion

When all subagents report completion:

1. Collect and deduplicate findings across agents
2. Assess overall security posture
3. Ensure all proposals are resolved (`accepted` or `rejected`)
4. Delegate report build to Reporting
5. Require Reporting to finalize via `pentest_finalize_run`
6. Verify final state and artifact paths via `pentest_get_report_paths` (`run_status=finalized`)
7. Return a final prioritized report in your assistant response
