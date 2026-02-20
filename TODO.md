# TODO

Consolidated from:
- `.opencode/agents/TODO`
- `.opencode/skill/pentest-report/TODO`

## Agent roadmap and tuning

- [ ] Add optional `validation` subagent for stricter QA flow.
- [ ] Add optional `impact` subagent to isolate business-impact demonstration.
- [ ] Add optional vulnerability specialists: `idor`, `auth`, `sqli`, `xss`.
- [ ] Add optional `api` subagent for GraphQL and complex authz patterns.
- [ ] Add optional `infra-web` subagent for web-reachable infrastructure and misconfiguration checks.
- [ ] Set and document `temperature` defaults for root and subagents.
- [ ] Set and document `top_p` defaults for root and subagents.
- [ ] Set and document `steps` (max-steps) defaults for root and subagents.
- [ ] Evaluate and document provider-specific model options per agent (for example `reasoningEffort`, `textVerbosity`).
- [ ] Define explicit tool allow/deny policy for root and subagents, including wildcard tool rules.
- [ ] Review and document `mode` per agent (`primary`, `subagent`, `all`).
- [ ] Decide per-agent `hidden: true` usage (Task-only/internal) vs visible in `@` autocomplete.
- [ ] Define `permission.task` delegation rules for root/orchestrator with ordered allow/ask exceptions and default deny.
- [ ] Assign `color` for root and each subagent for clearer UI differentiation.

Current active subagents: `recon`, `analysis`, `exploitation`, `reporting`.

## OpenHack report skill maintenance

- [ ] Keep OpenHack template in sync with `/Users/mkdirtim/Development/projects/pentest/reporting/markdown/src/openhack-report-template_v1.md`.
- [ ] Keep Eisvogel in sync with `/Users/mkdirtim/Development/projects/pentest/reporting/markdown/src/eisvogel.latex`.
- [ ] Keep sample test fixture current: `.opencode/skill/pentest-report/tests/openhack-juice-shop-test.md`.
- [ ] Verify dependency check script still validates: `script/pentest-report-deps.sh`.

## Session `ses_3849` tracking

### P0 Runtime/Tooling (Code)

- [x] Extend `addProposal` in `.opencode/lib/pentest-db.ts` with payload normalization.
- [x] Parse and canonicalize proposal payload JSON (`title -> name`, `severity -> lowercase enum`, `cvss.score/vector -> cvss_score/cvss_vector`, `affected_endpoint(s) -> assets`).
- [x] Reject invalid proposal payloads with explicit error messages.
- [x] Change `evaluateReadiness` to always set build-blocking error for open proposals (`proposed > 0`) in all safety modes.
- [x] Keep `buildReport` guarded by readiness and add tests for test-mode blocking.
- [x] Add duplicate proposal fingerprint warning (`name+severity+first asset`) in readiness output.
- [x] Keep `validated` as warning-only signal (no production build blocker).

### P0 Agent orchestration (Prompts)

- [x] Update `.opencode/agents/root.md` to retry once on `task` abort/empty `<task_result>`, then mark a coverage gap.
- [x] Add required subagent output contract in root prompt: `status`, `proposals_submitted`, `errors`, `coverage`.
- [x] Update root prompt so reporting resolves all proposals explicitly, not only top findings.
- [x] Update `.opencode/agents/onboarding.md` output contract with mandatory `question_asked=true` and `selected_mode`.
- [x] Update root prompt with onboarding soft-retry if question evidence is missing.

### P1 Reporting quality (Prompts + flow)

- [x] Update `.opencode/agents/reporting.md`: require `proposed=0` before build; otherwise return blockers only.
- [x] Update reporting prompt to merge overlapping findings (same root cause/endpoint scope).
- [x] Update reporting prompt to fill narrative fields before build: `summary_text`, `subject_description`, `scope_targets_markdown`, `methodology_details`, `events`.

### P1 Tests

- [x] Add runtime test coverage for proposal normalization and validation in `packages/opencode/test/pentest-db-runtime.test.ts`.
- [x] Add runtime test: readiness is `ready=false` when proposals remain `proposed` in `test` mode.
- [x] Add runtime test: `buildReport` fails in `test` mode when proposals remain open.
- [x] Add runtime test: severity normalization (`High`, `Medium`) to canonical values.
- [x] Add prompt-contract test for root retry/gap behavior in `packages/opencode/test/pentest-agent-prompts.test.ts`.

### Current run (one-time operational tasks)

- [ ] For run `7870c542-9217-4fbb-af41-df4515ec8101`, resolve all remaining open proposals (`accept` or `reject`).
- [ ] Review current 11 findings for overlap/redundancy and merge if needed.
- [ ] Fill missing narrative fields, then rebuild report outputs.
- [ ] Finalize the run after successful rebuild.
