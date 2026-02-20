# TODO

Consolidated from:
- `.opencode/agents/TODO`
- `.opencode/skill/pentest-report/TODO`

Current active subagents: `recon`, `analysis`, `exploitation`, `reporting`.

## Active TODOs (grouped by topic)

### Runtime, lifecycle, and evidence quality

#### Evidence Path Enforcement

- [ ] [P1] Add regression check/script that fails when new runtime evidence files appear in `packages/opencode/` (or other non-run roots) during a run.
- [ ] [P2] Add evidence relevance checks so attached screenshots/logs must match the claimed exploited state/endpoint (avoid homepage/profile mismatch artifacts).

#### Proposal and Report Quality

- [ ] [P0] Enforce mode-aware per-task quotas in runtime/orchestration: apply strict limits only when task contract explicitly requests constrained output (for example test-mode "exactly 1 SQLi and 1 JWT"), otherwise allow full discovery coverage and only dedupe/quality-filter results.
- [ ] [P1] Add proposal payload preflight validation (`name`, `severity`, `description`, CVSS v4, `assets` shape) before `pentest_add_proposal` to reduce repeated submit-fail-retry loops in subagents.
- [ ] [P1] Redact sensitive exploit material before persistence/rendering (full JWTs, password hashes, secret key material) while preserving reproducible PoC steps.
- [ ] [P1] Add reporting/readiness duplicate guard for auth findings with same root cause/endpoint (for example JWT `none` and RS256→HS256 confusion overlap) to prevent double-counting in one run.

### Agent-related

#### Prompt Contracts and Output Shape

- [ ] [P1] Add canonical `pentest_add_proposal` payload templates to recon/exploitation/JWT task prompts (required fields, CVSS v4 format, and `assets` as array of strings) to reduce retry/error loops.
- [ ] [P1] Standardize subagent output IDs: require `proposal_ids[]` in proposal-producing agents, and only emit `finding_id` after explicit accept step to avoid proposal/finding ID confusion.
- [ ] [P1] Add prompt-contract test for delegation timeliness: after onboarding, root must delegate to the requested specialist tasks within a bounded number of steps (no repeated skill-loading loops).
- [ ] [P1] Condense output sections in `.opencode/agents/recon.md`, `.opencode/agents/analysis.md`, and `.opencode/agents/exploitation.md` to reference the standard root contract and keep only agent-specific outputs.
- [ ] [P1] Remove redundant root prompt content in `.opencode/agents/root.md` (duplicate intake option list, duplicate completion rule) and condense scope decomposition to one concise instruction line.

#### Feature Docs Alignment

- [ ] [P1] Trim `data/features/onboarding.md` to onboarding-owned responsibilities only (workflow steps 1-2, scoped outputs/done criteria) and remove duplicated payload/path implementation details.
- [ ] [P1] Trim `data/features/reporting.md` to workflow spec only and remove embedded skill-layout reference section; update goal sentence accordingly.

#### Permissions and Delegation Policy

- [ ] [P1] Define explicit tool allow/deny policy for root and subagents, including wildcard tool rules.
- [ ] [P1] Define `permission.task` delegation rules for root/orchestrator with ordered allow/ask exceptions and default deny.
- [ ] [P2] Decide policy for explicit permission denies in agent files; if default-deny remains authoritative and no wildcard exceptions require explicit blocks, remove redundant deny lines from `.opencode/agents/onboarding.md`, `.opencode/agents/reporting.md`, `.opencode/agents/recon.md`, `.opencode/agents/analysis.md`, and `.opencode/agents/exploitation.md`.

#### Optional Agent Architecture and Tuning

- [ ] [P2] Add optional `validation` subagent for stricter QA flow.
- [ ] [P2] Add optional `impact` subagent to isolate business-impact demonstration.
- [ ] [P2] Set and document `temperature` defaults for root and subagents.
- [ ] [P2] Set and document `top_p` defaults for root and subagents.
- [ ] [P2] Set and document `steps` (max-steps) defaults for root and subagents.
- [ ] [P2] Evaluate and document provider-specific model options per agent (for example `reasoningEffort`, `textVerbosity`).
- [ ] [P2] Review and document `mode` per agent (`primary`, `subagent`, `all`).
- [ ] [P2] Decide per-agent `hidden: true` usage (Task-only/internal) vs visible in `@` autocomplete.
- [ ] [P2] Assign `color` for root and each subagent for clearer UI differentiation.

### Tooling maintenance

- [ ] [P2] Verify dependency check script still validates: `script/pentest-report-deps.sh`.

## Completed TODOs (grouped by topic)

### Runtime, DB, and API correctness

- [x] [P0] Fix artifact attach ID confusion: support proposal-to-finding resolution in artifact flow (either new `pentest_attach_artifact_by_proposal` or optional `proposal_id` in `pentest_attach_artifact`), and return explicit error when a proposal ID is passed as `finding_id`.
- [x] [P0] Add canonical run-path API for agents (`run_dir`, `evidence_dir`, `report_dir`) and require artifact writes under run directory to prevent `ENOENT` from cwd writes.
- [x] [P0] Eliminate split write roots (`data/pentest/...` vs `packages/opencode/...`): force all runtime outputs (screenshots, logs, yml/json evidence, artifacts) into run-scoped `data/pentest/running/<run_id>/...` and add a one-time cleanup/migration for stray files.
- [x] [P1] Harden tool argument validation for required fields (for example `run_id`) and replace low-level TypeErrors with user-facing validation errors.
- [x] [P1] Improve proposal payload contract enforcement feedback (clear canonical schema errors for `name|severity|description`, CVSS v4 format, and supported asset shape).
- [x] [P0] Extend `addProposal` in `.opencode/lib/pentest-db.ts` with payload normalization.
- [x] [P0] Parse and canonicalize proposal payload JSON (`title -> name`, `severity -> lowercase enum`, `cvss.score/vector -> cvss_score/cvss_vector`, `affected_endpoint(s) -> assets`).
- [x] [P0] Reject invalid proposal payloads with explicit error messages.
- [x] [P0] Change `evaluateReadiness` to always set build-blocking error for open proposals (`proposed > 0`) in all safety modes.
- [x] [P0] Keep `buildReport` guarded by readiness and add tests for test-mode blocking.
- [x] [P1] Add duplicate proposal fingerprint warning (`name+severity+first asset`) in readiness output.
- [x] [P0] Keep `validated` flag itself warning-only (no build blocker solely because `validated=false`).
- [x] [P1] Decide and enforce policy for `validated=true` findings without attached artifacts in production (blocker in production, warning in test).
- [x] [P1] Add runtime test coverage for proposal normalization and validation in `packages/opencode/test/pentest/pentest-db-runtime.test.ts`.
- [x] [P0] Add runtime test: readiness is `ready=false` when proposals remain `proposed` in `test` mode.
- [x] [P0] Add runtime test: `buildReport` fails in `test` mode when proposals remain open.
- [x] [P1] Add runtime test: severity normalization (`High`, `Medium`) to canonical values.
- [x] [P1] Add proposal-evidence staging support in `pentest_attach_artifact` (`proposal_id`-linked staging before acceptance) and auto-link staged evidence on proposal acceptance.
- [x] [P1] Improve unresolved-proposal artifact guidance (clear proposal/finding ID usage and fallback path).
- [x] [P0] Remove legacy artifact auto-import fallback in `pentest_attach_artifact`; missing files outside `run_dir` now fail fast with explicit run-scoped guidance.
- [x] [P0] Add run-aware evidence directory getter (`pentest_get_evidence_directory`) and enforce deterministic browser artifact paths under `evidence_dir` with `rel_path = evidence/<filename>`.
- [x] [P0] Add runtime guard for Playwright browser write tools in pentest flows to reject filenames outside run-scoped `data/pentest/running/<run_id>/evidence`.
- [x] [P1] Prevent non-vulnerability/meta proposals (recon/progress notes) from entering canonical proposal queue.
- [x] [P2] Add test-mode narrative completeness warnings for empty subject/scope/methodology/events.

### Agent-related

- [x] [P0] Update `.opencode/agents/root.md` to retry once on `task` abort/empty `<task_result>`, then mark a coverage gap.
- [x] [P0] Add required subagent output contract in root prompt: `status`, `proposals_submitted`, `errors`, `coverage`.
- [x] [P0] Update root prompt so reporting resolves all proposals explicitly, not only top findings.
- [x] [P0] Update `.opencode/agents/onboarding.md` output contract with mandatory `question_asked=true` and `selected_mode`.
- [x] [P0] Update root prompt with onboarding soft-retry if question evidence is missing.
- [x] [P1] Add prompt-contract test for root retry/gap behavior in `packages/opencode/test/pentest/pentest-agent-prompts.test.ts`.
- [x] [P0] Update `.opencode/agents/reporting.md`: require `proposed=0` before build; otherwise return blockers only.
- [x] [P1] Update `.opencode/agents/reporting.md` narrative rule to verification-only: use readiness blocker feedback and return blockers to root instead of direct narrative writes.
- [x] [P1] Clarify exploitation wording in `.opencode/agents/exploitation.md` to avoid proposal lifecycle ambiguity.
- [x] [P1] Update `.opencode/skill/pentest-report/SKILL.md` quality-gate wording so pending proposals block build in all safety modes.
- [x] [P1] Update reporting prompt to merge overlapping findings (same root cause/endpoint scope).
- [x] [P1] Update reporting prompt to fill narrative fields before build: `summary_text`, `subject_description`, `scope_targets_markdown`, `methodology_details`, `events`.
- [x] [P0] Enforce onboarding-first root behavior as hard gate before valid `run_id` and add prompt-contract coverage.
- [x] [P0] Enforce root safeguard to avoid run-scoped DB calls before valid `run_id` and add prompt-contract coverage.
- [x] [P0] Enforce reporting-only build path from root (no direct script/skill build execution) and add prompt-contract coverage.
- [x] [P0] Enforce finalize verification contract (`pentest_finalize_run` + `pentest_get_report_paths` with finalized status) in root/reporting prompts.
- [x] [P1] Add prompt-contract test that root cannot take direct report-build actions (no direct reporting skill/script execution; must delegate to reporting task flow).
