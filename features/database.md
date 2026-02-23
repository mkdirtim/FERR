# Pentest Runtime Database (DB-First)

## Purpose

This document specifies the pentest runtime database used by the proposal-first workflow.

Goals:
- Store canonical run state in one place
- Let multiple agents collaborate safely on a shared run
- Keep reporting deterministic and auditable
- Enforce production safety gates before report build/finalize

Implementation source:
- `.opencode/lib/pentest-db.ts`
- `.opencode/tools/pentest.ts`

## Runtime Topology

```mermaid
flowchart LR
    A[Onboarding Agent] -->|create/set onboarding| DB[(run.db)]
    B[Recon Agent] -->|add proposal| DB
    C[Analysis Agent] -->|add proposal| DB
    D[Exploitation Agent] -->|add proposal| DB
    E[Reporting Agent] -->|accept/reject proposals + findings + build| DB
    F[Root Agent] -->|orchestrate + read state| DB
    DB --> G[Report Artifacts in run/report]
    DB --> H[Finished Runs data/pentest/finished]
```

## Filesystem Layout

Each run has its own SQLite DB file:

- Running DB: `data/pentest/running/<run_id>/run.db`
- Finished DB: `data/pentest/finished/<run_id>/run.db`

Per-run artifact folders:

- `data/pentest/running/<run_id>/report`
- `data/pentest/running/<run_id>/evidence`

After finalize, the entire run directory (including `report/` and `evidence/`) moves to:
- `data/pentest/finished/<run_id>/...`

## SQLite Settings and Concurrency

Configured at DB open:
- `PRAGMA journal_mode = WAL`
- `PRAGMA synchronous = NORMAL`
- `PRAGMA foreign_keys = ON`
- `PRAGMA busy_timeout = 5000`

Writes use `BEGIN IMMEDIATE` transactions (`withTx`) to prevent partial state updates.
Schema migrations also use explicit transactions for table rebuilds.

## Schema Versioning and Migrations

Migration tracking table:
- `schema_migrations(version, applied_at, applied_by)`

Current schema version:
- `4`

Version 2 migration adds:
- `proposal.resolved_by`
- `proposal.resolution_reason`
- Unique index `uq_finding_run_proposal` on `(run_id, proposal_id)`

Version 3 migration changes:
- `executive_summary` keeps only narrative fields (`information_base`, `summary_text`)
- Severity counters are no longer persisted in DB
- Counters are computed from `finding` at read/build time
- Migration is transactional and recovery-aware for interrupted v3 states (for example leftover `executive_summary_new`)

Version 4 migration changes:
- `artifact.proposal_id` added for proposal-stage evidence
- staged artifacts can be attached before proposal acceptance and auto-linked to finding on accept
- index `idx_artifact_run_proposal` added on `(run_id, proposal_id)`

Migration precheck:
- Migration fails if duplicate non-null `(run_id, proposal_id)` links already exist in `finding`.

## ER Diagram

```mermaid
erDiagram
    RUN ||--o{ CONTACT : has
    RUN ||--|| EXECUTIVE_SUMMARY : has
    RUN ||--|| EXECUTION_CONTEXT : has
    RUN ||--|| APPENDIX : has
    RUN ||--o{ FINDING : has
    RUN ||--o{ PROPOSAL : receives
    RUN ||--o{ ARTIFACT : stores
    RUN ||--o{ AUDIT_LOG : records
    RUN ||--|| REPORT_BUILD : tracks
    FINDING ||--o{ ARTIFACT : links
    PROPOSAL o|--o| FINDING : optional_source

    RUN {
      text id PK
      text engagement_mode
      text safety_mode
      text status
      text target_url
      text target_name
      text assessment_type
      text test_environment
      text assessor_org
      text assessor_name
      text assessor_email
      text client_name
      text report_date
      text template_version
      int time_created
      int time_updated
    }

    PROPOSAL {
      text id PK
      text run_id FK
      text agent_name
      text tool_name
      text payload_json
      text status
      text accepted_by
      text resolved_by
      text resolution_reason
      int time_created
      int time_updated
    }

    FINDING {
      text id PK
      text run_id FK
      int seq
      text slug
      text name
      text severity
      real cvss_score
      text cvss_vector
      text assets_json
      text status
      int validated
      text description
      text proof_of_concept
      text remediation
      text proposal_id
      int time_created
      int time_updated
    }

    REPORT_BUILD {
      text run_id PK
      text template_version
      text filled_md_rel_path
      text pdf_rel_path
      text html_rel_path
      text docx_rel_path
      text last_status
      text last_error
      text built_by
      int time_built
    }
```

## Table-by-Table Reference

### `run`

Primary run metadata and lifecycle.

Key constraints:
- `engagement_mode IN ('manual','defaults','juiceshop-defaults')`
- `safety_mode IN ('test','production')`
- `status IN ('running','finalize_in_progress','finalized','failed_finalize')`

### `contact`

Assessor/client contacts.

Key constraints:
- `side IN ('assessor','client')`
- FK `run_id -> run(id)` with `ON DELETE CASCADE`

### `executive_summary`

Run summary narrative fields only.

Key relationship:
- One-to-one with run (`run_id` as PK and FK)

### `execution_context`

Execution narrative: subject, scope, methodology, events.

### `appendix`

Appendix content blocks.

### `proposal`

Subagent proposal queue and resolution state.

Key constraints:
- `status IN ('proposed','accepted','rejected')`
- FK `run_id -> run(id)` with `ON DELETE CASCADE`

Resolution fields:
- `accepted_by`
- `resolved_by`
- `resolution_reason`

### `finding`

Canonical finding records (reporting-owned writes).

Key constraints:
- `severity IN ('critical','high','medium','low','info')`
- `status IN ('draft','open','mitigated','closed','wontfix')`
- `validated IN (0,1)`
- `cvss_score` numeric range `[0,10]` when provided
- `UNIQUE(run_id, slug)`
- `UNIQUE(run_id, seq)`
- `UNIQUE(run_id, proposal_id)` via `uq_finding_run_proposal` (NULL allowed)
- `proposal_id` is a logical/unique link to `proposal.id` (currently no DB FK constraint)

### `artifact`

Evidence attachments and checksums.

Key relationships:
- `run_id -> run(id)` cascade
- optional `finding_id -> finding(id)` set null on finding delete
- optional `proposal_id -> proposal(id)` for staged evidence before canonical finding exists

### `audit_log`

Audit trail of tool operations.

Columns include:
- agent name, tool name, args hash, result code, timestamp

### `report_build`

Last build/materialization status and artifact paths for each run.

## Indexes

- `idx_finding_run_seq` on `finding(run_id, seq)`
- `idx_finding_run_validated` on `finding(run_id, validated)`
- `idx_artifact_finding` on `artifact(finding_id)`
- `idx_artifact_run_proposal` on `artifact(run_id, proposal_id)`
- `idx_proposal_run_status` on `proposal(run_id, status)`
- `idx_audit_run_time` on `audit_log(run_id, time_created)`
- `idx_run_status` on `run(status)`
- `uq_finding_run_proposal` unique index on `finding(run_id, proposal_id)`

## Run Lifecycle State Machine

```mermaid
stateDiagram-v2
    [*] --> running
    running --> finalize_in_progress: pentest_finalize_run
    finalize_in_progress --> finalized: move running to finished succeeds
    finalize_in_progress --> failed_finalize: move fails
    failed_finalize --> running: manual recovery (not automatic)
```

## Proposal Lifecycle State Machine

```mermaid
stateDiagram-v2
    [*] --> proposed
    proposed --> accepted: pentest_accept_proposal
    proposed --> rejected: pentest_reject_proposal
    accepted --> [*]
    rejected --> [*]
```

## Canonical Workflow (Proposal-First)

```mermaid
sequenceDiagram
    participant Root
    participant Onboarding
    participant Recon
    participant Analysis
    participant Exploit
    participant Reporting
    participant DB as run.db

    Root->>Onboarding: create run
    Onboarding->>DB: pentest_create_run / pentest_set_onboarding
    Root->>Recon: delegate with explicit run_id
    Root->>Analysis: delegate with explicit run_id
    Root->>Exploit: delegate with explicit run_id
    Recon->>DB: pentest_add_proposal
    Analysis->>DB: pentest_add_proposal
    Exploit->>DB: pentest_add_proposal
    Root->>Reporting: resolve proposals
    Reporting->>DB: pentest_accept_proposal (accept)
    Reporting->>DB: pentest_reject_proposal (reject)
    Reporting->>DB: pentest_check_readiness
    alt ready
      Reporting->>DB: pentest_build_report
      Root->>DB: pentest_finalize_run
    else blockers
      Reporting-->>Root: blocker list
    end
```

## Production Readiness Guards

`check_readiness` computes:
- `ready` (bool)
- `errors[]`
- `blocker_codes[]` (stable machine-readable blocker identifiers)
- `warnings[]`
- proposal/finding counts
- `missing_required_fields[]`
- `default_placeholder_fields[]`

In `production` safety mode, build is blocked when:
- required run fields are missing
- default placeholders are still present
- no findings exist
- `executive_summary.summary_text` is empty
- `execution_context.subject_description` is empty
- `execution_context.scope_targets_markdown` is empty
- `execution_context.methodology_details` is empty
- one or more findings are in `draft`
- one or more findings are missing CVSS (`cvss_vector` missing, or `cvss_score` missing for non-`N/A [failed to compute]` vectors)
- one or more findings have empty assets (`assets_json` as empty array)
- one or more validated findings have no attached artifacts

In all safety modes, build is blocked when:
- one or more proposals remain in `proposed`

Validation note:
- unvalidated findings generate warnings but do not hard-block build.
- duplicate proposal fingerprints generate warnings only (no hard block).
- validated findings without attached artifacts always generate warnings and are production blockers.
- findings with `cvss_vector = "N/A [failed to compute]"` generate warnings and do not hard-block build.
- in `test` mode, missing narrative fields (`subject_description`, `scope_targets_markdown`, `methodology_details`, `events`) are warning-level signals.

`pentest_build_report` runs readiness internally and fails fast if not ready.

## Tool API to Data Mapping

### Run and onboarding
- `pentest_create_run` -> inserts run + summary + context + appendix + contacts
  - returns `run_id`, `db_path`, `run_dir`, `evidence_dir`, `report_dir`
- `pentest_set_onboarding` -> updates run/summary/context/appendix/contacts
- `pentest_add_contact` -> inserts contact row
- `pentest_get_run` -> run + related one-to-one sections + contacts + report_build
  - summary counters are returned as computed fields (`critical_count`, `high_count`, `medium_count`, `low_count`, `info_count`, `total_count`)

### Proposals
- `pentest_add_proposal` -> inserts `proposal(status='proposed')`
  - normalizes payload aliases (`title -> name`, `cvss.score -> cvss_score`, `cvss.vector -> cvss_vector`, `affected_endpoint(s) -> assets`)
  - enforces required fields (`name|title`, `severity`, `description`)
  - validates severity enum, CVSS score range, CVSS v3.1 vector format (or `N/A [failed to compute]`), and asset shapes
  - rejects recon/progress metadata payloads when they look non-vulnerability and lack concrete vulnerability signals
- `pentest_get_proposals` -> list proposals (`status` and `agent_name` filters)
- `pentest_accept_proposal` -> canonical accept path from proposal payload to finding
  - defaults to `status='open'`, `validated=false` unless overridden
- `pentest_reject_proposal` -> sets proposal to rejected with reason

### CVSS utility
- `pentest_calculate_cvss` -> computes CVSS 3.1 vector, score, and derived severity from base metrics
  - input metrics: `attack_vector`, `attack_complexity`, `privileges_required`, `user_interaction`, `scope`, `confidentiality`, `integrity`, `availability`
  - returns deterministic vector format: `CVSS:3.1/AV:.../AC:.../PR:.../UI:.../S:.../C:.../I:.../A:...`
  - on compute failure returns `status='failed'`, `cvss_vector='N/A [failed to compute]'`, `cvss_score=null`, `severity=null`
  - this tool is pure calculation (no DB write); persistence occurs via `pentest_add_proposal` or finding tools

### Findings
- `pentest_add_finding` -> inserts canonical finding, optionally accepts linked proposal
  - defaults to `status='draft'`, `validated=false` unless provided
- `pentest_update_finding` -> patch finding fields (errors if `finding_id` is not found for `run_id`)
- `pentest_delete_finding` -> deletes finding and linked artifacts
- `pentest_get_finding` / `pentest_get_findings` -> read finding views

### Evidence and audit
- `pentest_get_evidence_directory` -> returns run-scoped evidence write location for active run
  - requires `run.status='running'`
  - returns `run_dir`, `evidence_dir`, `evidence_rel_base`
  - intended flow: get once, write deterministic filenames, attach as `rel_path = evidence/<filename>`
- `pentest_attach_artifact` -> verifies path and checksum, inserts artifact
  - accepts either `finding_id` or `proposal_id` (both optional for run-level evidence)
  - with `proposal_id` and no canonical finding yet, evidence is staged on proposal and auto-linked when proposal is accepted
  - with `proposal_id` and existing canonical finding, links directly to that finding
  - returns explicit error if a proposal ID is passed as `finding_id`
  - enforces strict run-scoped paths only; missing files outside run dir are rejected (no legacy auto-import fallback)
- `pentest_get_audit_log` -> paged audit list by run

### Reporting lifecycle
- `pentest_check_readiness` -> readiness snapshot
- `pentest_materialize_report` -> fill markdown only (readiness is enforced only for `production` safety mode)
- `pentest_build_report` -> sync run header from contacts, run readiness, render outputs, persist build metadata
  - header sync is executed before readiness and can update `run.assessor_name`, `run.assessor_email`, `run.client_name` even when build is later blocked
- `pentest_finalize_run` -> guarded move running -> finished with status transitions (requires successful `report_build`)
- `pentest_get_report_paths` -> resolves canonical run paths and report artifact absolute paths using actual run state (`running` or `finished`)
  - includes `run_status`, `run_state`, `run_dir`, `evidence_dir`, `report_dir` for agent-safe report path reads

## Validation Rules

Run-level:
- `target_url` required at creation
- `target_url` rejects path-traversal-like input (`..`)
- `run_id` is required and rejects `/`, `\`, and `..`

Proposal-level:
- payload must be valid JSON object
- required: `name` (or `title`), `severity`, `description`
- severity must be one of `critical|high|medium|low|info`
- `cvss_score` must be in `0.0..10.0` when provided
- `cvss_vector` must match CVSS v3.1 format when provided, or equal `N/A [failed to compute]`
- `assets` / `affected_endpoints` must be arrays of non-empty strings; `affected_endpoint` must be non-empty string

Finding-level:
- `cvss_score` in `0.0..10.0`
- `cvss_vector` accepted values: `CVSS:3.1/<metric>:<value>` or `N/A [failed to compute]`
- `cvss_score` and `cvss_vector` are both allowed; score is not auto-recalculated from vector
- `assets_json` must be JSON array of strings
- `slug` is generated at create time and remains stable on name updates

Path-level:
- artifact paths are validated to remain inside the run directory
- canonical write root is run-scoped: `data/pentest/running/<run_id>/...`
- browser-output creation should use run-scoped absolute filenames under `evidence_dir` (from `pentest_get_evidence_directory`) and attach with `rel_path = evidence/<filename>`
- files outside the run dir are not imported during attach; callers must write evidence to run-scoped paths first

## Atomicity Guarantees

Atomic units (single transaction):
- onboarding updates
- contact insert
- proposal insert/reject
- finding create/update/delete
- artifact attach
- report_build status updates

`pentest_build_report` itself is intentionally multi-step (sync -> readiness -> materialize -> render -> persist status), not one global transaction.

Finalize sequence:
1. DB tx sets `run.status='finalize_in_progress'`
2. Filesystem rename `running/<id>` -> `finished/<id>`
3. On success: DB tx sets `run.status='finalized'`
4. On failure: DB tx sets `run.status='failed_finalize'`

## Reporting Data Flow

1. Read DB state and findings
2. Compute severity counts live from `finding`
  - report mode filter: `status NOT IN ('closed','wontfix')`
3. Map domain fields to template markers
  - includes rendering `TODO_EXECUTIVE_SUMMARY_SEVERITY_TABLE` from live counts
4. Replace markers and inject generated finding blocks
5. Verify unresolved markers = 0
6. Render via pandoc (`pdf|html|docx|all`)
7. Persist outputs and status to `report_build`

## Date and Time Conventions

- `time_*` fields store epoch seconds (UTC-style integer timestamps)
- `report_date` is `YYYY-MM-DD`
- `report_date` is auto-populated during report assembly if missing

## Operational Queries (Examples)

Pending proposals in a run:
```sql
SELECT id, agent_name, tool_name, time_created
FROM proposal
WHERE run_id = ? AND status = 'proposed'
ORDER BY time_created;
```

Validated findings count:
```sql
SELECT COUNT(*) AS validated
FROM finding
WHERE run_id = ? AND validated = 1;
```

Audit trail:
```sql
SELECT time_created, agent_name, tool_name, result_code
FROM audit_log
WHERE run_id = ?
ORDER BY time_created, id;
```

## Troubleshooting

Migration error about duplicate proposal mapping:
- Cause: more than one finding linked to the same `(run_id, proposal_id)`
- Fix: clean duplicates, then reopen DB to apply migration v2

Migration v3 update:
- `executive_summary` counter columns were removed
- if external SQL readers expect `*_count` columns directly from `executive_summary`, migrate them to computed counters from `finding`
- if a previous upgrade was interrupted and `executive_summary_new` is present, reopening the DB will recover and complete migration

Build blocked:
- Run `pentest_check_readiness`
- Resolve `errors[]` first
- note: pending `proposed` proposals block build in all safety modes

Finalize failed:
- Run status becomes `failed_finalize`
- Inspect filesystem and audit log
- Recover manually and re-attempt finalize

## Known Constraints (v1)

- No DB-native phase/checkpoint table yet (root orchestrates phase externally)
- `proposal.payload_json` is stored as JSON text without DB-native JSON schema constraints (validation/normalization is enforced in runtime code)
- Contact parser accepts pipe/semicolon rows and skips malformed rows silently

## Recommended Developer Workflow

1. Use onboarding to create run and baseline metadata
2. Pass explicit `run_id` to every delegated agent/task
3. Let recon/analysis/exploitation submit proposals only
4. Let reporting resolve proposals to canonical findings
5. Run readiness before every build attempt
6. Build and then finalize
7. Use audit log for traceability and debugging
