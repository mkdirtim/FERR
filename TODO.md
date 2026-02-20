# TODO

Consolidated from:
- `.opencode/agents/TODO`
- `.opencode/skill/pentest-report/TODO`

## Active TODOs (grouped by topic)

### Runtime, DB, and API correctness

- [ ] [P0] Fix artifact attach ID confusion: support proposal-to-finding resolution in artifact flow (either new `pentest_attach_artifact_by_proposal` or optional `proposal_id` in `pentest_attach_artifact`), and return explicit error when a proposal ID is passed as `finding_id`.
- [ ] [P0] Add canonical run-path API for agents (`run_dir`, `evidence_dir`, `report_dir`) and require artifact writes under run directory to prevent `ENOENT` from cwd writes.
- [ ] [P0] Eliminate split write roots (`data/pentest/...` vs `packages/opencode/...`): force all runtime outputs (screenshots, logs, yml/json evidence, artifacts) into run-scoped `data/pentest/running/<run_id>/...` and add a one-time cleanup/migration for stray files.
- [ ] [P1] Harden tool argument validation for required fields (for example `run_id`) and replace low-level TypeErrors with user-facing validation errors.
- [ ] [P1] Improve proposal payload contract enforcement feedback (clear canonical schema errors for `name|severity|description`, CVSS v4 format, and supported asset shape).

### Reporting quality and evidence integrity

- [ ] [P1] Add readiness guard/warning for `validated=true` findings without attached artifacts, and decide policy for blocking vs warning in production.
- [ ] [P1] Prevent non-vulnerability/meta proposals (recon/progress notes) from entering canonical proposal queue.
- [ ] [P2] Improve narrative completeness checks for test-mode reports (at least strong warnings for empty subject/scope/methodology/events).

### Run lifecycle and operational completion

- [ ] [P0] Enforce finalize step in orchestration contract: after successful build, require `pentest_finalize_run`, then verify via `pentest_get_report_paths` with `run_status=finalized`.
- [ ] [P0] For run `7870c542-9217-4fbb-af41-df4515ec8101`, resolve all remaining open proposals (`accept` or `reject`).
- [ ] [P1] Review current 11 findings for overlap/redundancy and merge if needed.
- [ ] [P0] Fill missing narrative fields, then rebuild report outputs.
- [ ] [P0] Finalize the run after successful rebuild.

### Agent orchestration and contracts

- [ ] [P0] Add root-agent safeguard to never call run-scoped DB tools before onboarding returns a valid `run_id`.

Current active subagents: `recon`, `analysis`, `exploitation`, `reporting`.

### Agent architecture and tuning

- [ ] [P2] Add optional `validation` subagent for stricter QA flow.
- [ ] [P2] Add optional `impact` subagent to isolate business-impact demonstration.
- [ ] [P2] Add optional vulnerability specialists: `idor`, `auth`, `sqli`, `xss`.
- [ ] [P2] Add optional `api` subagent for GraphQL and complex authz patterns.
- [ ] [P2] Add optional `infra-web` subagent for web-reachable infrastructure and misconfiguration checks.
- [ ] [P2] Set and document `temperature` defaults for root and subagents.
- [ ] [P2] Set and document `top_p` defaults for root and subagents.
- [ ] [P2] Set and document `steps` (max-steps) defaults for root and subagents.
- [ ] [P2] Evaluate and document provider-specific model options per agent (for example `reasoningEffort`, `textVerbosity`).
- [ ] [P1] Define explicit tool allow/deny policy for root and subagents, including wildcard tool rules.
- [ ] [P2] Review and document `mode` per agent (`primary`, `subagent`, `all`).
- [ ] [P2] Decide per-agent `hidden: true` usage (Task-only/internal) vs visible in `@` autocomplete.
- [ ] [P1] Define `permission.task` delegation rules for root/orchestrator with ordered allow/ask exceptions and default deny.
- [ ] [P2] Assign `color` for root and each subagent for clearer UI differentiation.

### OpenHack report skill maintenance

- [ ] [P2] Keep OpenHack template in sync with `/Users/mkdirtim/Development/projects/pentest/reporting/markdown/src/openhack-report-template_v1.md`.
- [ ] [P2] Keep Eisvogel in sync with `/Users/mkdirtim/Development/projects/pentest/reporting/markdown/src/eisvogel.latex`.
- [ ] [P2] Keep sample test fixture current: `.opencode/skill/pentest-report/tests/openhack-juice-shop-test.md`.
- [ ] [P2] Verify dependency check script still validates: `script/pentest-report-deps.sh`.

## Completed changes (moved)

### Runtime and validation (`ses_3849`)

- [x] [P0] Extend `addProposal` in `.opencode/lib/pentest-db.ts` with payload normalization.
- [x] [P0] Parse and canonicalize proposal payload JSON (`title -> name`, `severity -> lowercase enum`, `cvss.score/vector -> cvss_score/cvss_vector`, `affected_endpoint(s) -> assets`).
- [x] [P0] Reject invalid proposal payloads with explicit error messages.
- [x] [P0] Change `evaluateReadiness` to always set build-blocking error for open proposals (`proposed > 0`) in all safety modes.
- [x] [P0] Keep `buildReport` guarded by readiness and add tests for test-mode blocking.
- [x] [P1] Add duplicate proposal fingerprint warning (`name+severity+first asset`) in readiness output.
- [x] [P0] Keep `validated` as warning-only signal (no production build blocker).
- [x] [P1] Add runtime test coverage for proposal normalization and validation in `packages/opencode/test/pentest-db-runtime.test.ts`.
- [x] [P0] Add runtime test: readiness is `ready=false` when proposals remain `proposed` in `test` mode.
- [x] [P0] Add runtime test: `buildReport` fails in `test` mode when proposals remain open.
- [x] [P1] Add runtime test: severity normalization (`High`, `Medium`) to canonical values.

### Agent contracts and prompts (`ses_3849`)

- [x] [P0] Update `.opencode/agents/root.md` to retry once on `task` abort/empty `<task_result>`, then mark a coverage gap.
- [x] [P0] Add required subagent output contract in root prompt: `status`, `proposals_submitted`, `errors`, `coverage`.
- [x] [P0] Update root prompt so reporting resolves all proposals explicitly, not only top findings.
- [x] [P0] Update `.opencode/agents/onboarding.md` output contract with mandatory `question_asked=true` and `selected_mode`.
- [x] [P0] Update root prompt with onboarding soft-retry if question evidence is missing.
- [x] [P1] Add prompt-contract test for root retry/gap behavior in `packages/opencode/test/pentest-agent-prompts.test.ts`.

### Reporting flow (`ses_3849`)

- [x] [P0] Update `.opencode/agents/reporting.md`: require `proposed=0` before build; otherwise return blockers only.
- [x] [P1] Update reporting prompt to merge overlapping findings (same root cause/endpoint scope).
- [x] [P1] Update reporting prompt to fill narrative fields before build: `summary_text`, `subject_description`, `scope_targets_markdown`, `methodology_details`, `events`.
