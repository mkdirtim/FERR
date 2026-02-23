# OpenHack Project Overview

This document covers the OpenHack security-assessment layer integrated into this repository.

## Scope

OpenHack adds:
- pentest-specific agent orchestration and prompts,
- a proposal-first runtime database model per assessment run,
- evidence and report pipelines,
- report templates and build tooling.

OpenCode core runtime/package details are documented in `project-opencode.md`.

## Security Layer Paths

| Path | Purpose |
| --- | --- |
| `.opencode/opencode.jsonc` | Local OpenCode config for provider/MCP/tool permissions |
| `.opencode/tools/pentest.ts` | Pentest tool API surface (`create_run`, `add_proposal`, `build_report`, `finalize_run`, etc.) |
| `.opencode/lib/pentest-db.ts` | Canonical DB runtime logic, readiness gates, artifact linking, report assembly/finalize |
| `.opencode/agents/*.md` | Agent prompts/contracts (`orchestration`, `onboarding`, `exploitation`, `validation`, `reporting`) |
| `.opencode/skills/*/SKILL.md` | Security testing playbooks (SQLi, XSS, IDOR, CSRF, SSRF, JWT, RCE, XXE, and more) |
| `.opencode/skills/agent-report/` | Report templates, marker/proposal references, report build scripts, fixtures |
| `.opencode/scripts/migrate-runtime-artifacts.sh` | Moves stray runtime artifacts into run-scoped locations |

## Runtime Data Paths

| Path | Purpose |
| --- | --- |
| `features/` | Workflow docs (`features/database.md`, `features/onboarding.md`, `features/reporting.md`) |
| `data/pentest/assets/` | Default/custom onboarding profiles and archived templates |
| `data/pentest/running/<run_id>/` | Active run state (`run.db`, `evidence/`, `report/`) |
| `data/pentest/finished/<run_id>/` | Finalized run state and artifacts |

Notes:
- Each run has its own `run.db`.
- Evidence and report outputs are run-scoped by `run_id`.

## Pentest Flow (High Level)

1. Onboarding creates a run and sets engagement metadata.
2. Exploitation agents fan out in parallel and submit proposals.
3. Validation agents fan out in parallel and resolve proposals to `validated` or `rejected`.
4. Reporting rejects duplicates, accepts remaining `validated` proposals, then runs readiness/build/finalize.
5. Finalize moves run from `running` to `finished`.

## Agent Orchestration

```mermaid
flowchart LR
  user["User target input"] --> orch["orchestration"]
  orch --> onb["onboarding"]
  onb --> exp1["exploitation slice A"]
  onb --> exp2["exploitation slice B"]
  exp1 --> val1["validation shard A"]
  exp2 --> val2["validation shard B"]
  val1 --> rep["reporting"]
  val2 --> rep
  rep --> fin["finalize checks"]
```

## Proposal-to-Finding State Flow

```mermaid
flowchart LR
  prop["proposal: proposed"] --> val["proposal: validated"]
  prop --> rej["proposal: rejected"]
  val --> acc["proposal: accepted"]
  acc --> open["finding: open/mitigated/closed"]
  artp["artifact attach (proposal_id)"] -. "evidence staging" .-> prop
  artf["artifact attach (finding_id)"] -. "evidence linkage" .-> open
```

## Run Lifecycle

```mermaid
flowchart LR
  create["create_run"] --> running["running"]
  running --> build["build_report"]
  build --> finalize["finalize_run"]
  finalize --> finished["finished"]
```

## Key Tests

Pentest-focused tests:
- `packages/opencode/test/pentest/pentest-db-runtime.test.ts`
- `packages/opencode/test/pentest/pentest-agent-prompts.test.ts`

## Report Tooling

- DB-driven report script:
  - `.opencode/skills/agent-report/scripts/build-report-db.ts`
- Legacy/debug renderer:
  - `.opencode/skills/agent-report/scripts/build-report.sh`
- Dependency helper:
  - `script/pentest-report-deps.sh`

## Operational Notes

- Pentest artifacts can include sensitive exploit evidence and token/credential-like data.
- Treat `data/pentest/**` as sensitive runtime material.
- For full lab orchestration (targets/containers), see `docker/README.md`.

## Trust and Sensitivity Boundary

```mermaid
flowchart LR
  subgraph code["Code and Config Surface"]
    cfg[".opencode/**"]
    pkg["packages/opencode/**"]
  end

  subgraph sensitive["Sensitive Runtime Artifacts (`data/pentest/**`)"]
    run["run.db"]
    ev["evidence/"]
    rep["report/"]
  end

  exec["Agent and tool runtime"]
  gate["Permissioned pentest tool calls"]

  cfg --> exec
  pkg --> exec
  exec --> gate
  gate --> run
  gate --> ev
  gate --> rep
```
