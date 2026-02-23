# TODO

Consolidated from:
- `.opencode/agents/TODO`
- `.opencode/skills/agent-report/TODO`

Current active subagents: `recon`, `analysis`, `exploitation`, `reporting`.

## Active TODOs (prioritized and grouped)

Legend: `[ ]` open, `[x]` resolved, `(partial)` progress exists but remaining work is still required.

### Runtime evidence lifecycle

- [ ] [P1] [RUNTIME-01] Add regression check/script that fails when new runtime evidence files appear in `packages/opencode/` (or other non-run roots) during a run.
- [ ] [P2] [RUNTIME-02] Add evidence relevance checks so attached screenshots/logs must match the claimed exploited state/endpoint (avoid homepage/profile mismatch artifacts).
- [ ] [P1] [RUNTIME-03] (partial) Add a run-scoped browser artifact helper that takes `run_id` + filename and returns a guaranteed absolute path under `evidence_dir`; context: path discipline is currently prompt/agent-driven, risk: repeated artifact-guard retries and slower execution.
- [ ] [P2] [RUNTIME-04] Add workspace hygiene automation for generated pentest artifacts; context: sessions produce large untracked `data/pentest/...` and `packages/opencode/...` files, risk: noisy diffs and accidental artifact commits.

### Proposal and report quality gates

- [ ] [P0] [QUALITY-04] (partial) Enforce reporting-quality completeness in runtime (not only prompt policy): accepted findings must include non-empty description/proof/remediation, CVSS score+vector, non-empty assets, and artifact linkage for `validated=true`; context: current guarantees are mainly in agent prompt guidance, risk: incomplete findings can still pass through in some flows.
- [ ] [P1] [QUALITY-05] Revisit Proposal -> Accepted field mapping semantics: decide policy for `status`/`validated` when present in `pentest_add_proposal.payload_json` (pass through, reject, or keep accept-time override only), document/default behavior explicitly, and add runtime + prompt-contract tests. In the same pass, review and align `pentest_add_proposal.payload_json` required/optional contract fields across runtime, tool descriptions, and docs.

### Tool schema gaps

- [ ] [P1] [TOOL-01] `question` tool omits `custom` field from LLM schema (`Question.Info.omit({ custom: true })`), so agents cannot set `custom: false` to suppress "Type your own answer" — even when the agent prompt instructs it. Fix: expose `custom` in the tool schema or default it to `false` in `execute`. Affected file: `packages/opencode/src/tool/question.ts`.

### Prompt contracts and docs alignment

- [ ] [P0] [ONBOARD-01] Fix custom/manual onboarding interaction flow: after `Manual setup`, the onboarding agent must ask the user for missing onboarding fields (for example assessor/client/contact/scope metadata) instead of auto-filling or silently continuing with placeholders; keep unresolved values in `missing_fields` when user input is not provided.
- [ ] [P1] [CONTRACT-01] (partial) Add canonical `pentest_add_proposal` payload templates to recon/exploitation/JWT task prompts (required fields, CVSS v4 format, and `assets` as array of strings) to reduce retry/error loops.
- [ ] [P1] [CONTRACT-02] Standardize subagent output IDs: require `proposal_ids[]` in proposal-producing agents, and only emit `finding_id` after explicit accept step to avoid proposal/finding ID confusion.
- [ ] [P1] [CONTRACT-03] Add prompt-contract test for delegation timeliness: after onboarding, root must delegate to the requested specialist tasks within a bounded number of steps (no repeated skill-loading loops).
- [ ] [P1] [CONTRACT-04] Condense output sections in `.opencode/agents/recon.md`, `.opencode/agents/analysis.md`, and `.opencode/agents/exploitation.md` to reference the standard root contract and keep only agent-specific outputs.
- [ ] [P1] [DOC-01] Trim `data/features/onboarding.md` to onboarding-owned responsibilities only (workflow steps 1-2, scoped outputs/done criteria) and remove duplicated payload/path implementation details.
- [ ] [P1] [DOC-02] Trim `data/features/reporting.md` to workflow spec only and remove embedded skill-layout reference section; update goal sentence accordingly.

### Permissions and delegation policy

- [ ] [P1] [PERM-01] Define explicit tool allow/deny policy for root and subagents, including wildcard tool rules.
- [ ] [P1] [PERM-02] Define `permission.task` delegation rules for root/orchestrator with ordered allow/ask exceptions and default deny.
- [ ] [P2] [PERM-03] Decide policy for explicit permission denies in agent files; if default-deny remains authoritative and no wildcard exceptions require explicit blocks, remove redundant deny lines from `.opencode/agents/onboarding.md`, `.opencode/agents/reporting.md`, `.opencode/agents/recon.md`, `.opencode/agents/analysis.md`, and `.opencode/agents/exploitation.md`.

### Optional agent architecture and tuning

- [ ] [P2] [ARCH-03] Set and document `temperature` defaults for root and subagents.
- [ ] [P2] [ARCH-04] Set and document `top_p` defaults for root and subagents.
- [ ] [P2] [ARCH-05] Set and document `steps` (max-steps) defaults for root and subagents.
- [ ] [P2] [ARCH-06] Evaluate and document provider-specific model options per agent (for example `reasoningEffort`, `textVerbosity`).
- [ ] [P2] [ARCH-07] Review and document `mode` per agent (`primary`, `subagent`, `all`).
- [ ] [P2] [ARCH-08] Decide per-agent `hidden: true` usage (Task-only/internal) vs visible in `@` autocomplete.
- [ ] [P2] [ARCH-09] Assign `color` for root and each subagent for clearer UI differentiation.

### Skill naming and prefixes

- [x] [P1] [PREFIX-01] Adopt and document skill prefix taxonomy: `vuln-` (vulnerabilities), `scanmode-` (scan modes), `agent-` (agent-specific workflows), `project-` (project-specific skills), `guide-` (generic operator guidance).
- [x] [P1] [PREFIX-02] Migrate skill names and directories to prefixed names (including `SKILL.md` `name:` values) with deterministic old->new mapping.
- [ ] [P1] [PREFIX-03] Add backward-compatibility aliases for old skill names to avoid breaking prompts/workflows during migration. (Skipped for now by request)
- [x] [P2] [PREFIX-04] Update docs, examples, and references to prefer prefixed skill names.

## Bigger Ideas (feature backlog, no urgency)

Use this section for feature-sized initiatives that are valuable but not currently urgent.

- [ ] [IDEA-01] Add optional `validation` subagent for stricter QA flow.
- [ ] [IDEA-02] Add optional `impact` subagent to isolate business-impact demonstration.
- [ ] [IDEA-03] Add additional feature ideas here as they are identified.
- [ ] [IDEA-04] Add optional local sanitization/pseudonymization pass using a self-hosted model before sending prompts/context to external LLM providers (for example `http://customer-a.com` -> `http://example-a.com`).
- [ ] [IDEA-05] Add dedicated `recon` agent in orchestration order (after onboarding, before other specialist agents).
- [ ] [IDEA-06] Add OWASP Penetration Test Reporting Standard (OPTRS) output/support once OPTRS is out of beta.
- [ ] [IDEA-07] Add multi-LLM validation pattern: send one prompt to `K` LLMs, collect full independent answers, then run a synthesis step that reconciles outputs into one best combined response.
- [ ] [IDEA-08] Implement CVSS 4.0 support across pentest runtime, prompts, templates, validation, and reporting output.
- [ ] [IDEA-09] Redact sensitive exploit material before persistence/rendering (full JWTs, password hashes, secret key material) while preserving reproducible PoC steps.

## Branch Plan (feature-xxx)

Branch naming rule: use `feature-<descriptive-scope>` and keep each branch scoped to a coherent set of IDs.

- `feature-runtime-evidence-guards` -> `RUNTIME-01`, `RUNTIME-02`, `RUNTIME-03`
- `feature-runtime-workspace-hygiene` -> `RUNTIME-04`
- `feature-quality-completeness-baseline` -> `QUALITY-04`
- `feature-contract-payload-and-ids` -> `CONTRACT-01`, `CONTRACT-02`
- `feature-contract-delegation-timeliness` -> `CONTRACT-03`
- `feature-contract-prompt-trim` -> `CONTRACT-04`, `CONTRACT-05`
- `feature-docs-onboarding-reporting-scope` -> `DOC-01`, `DOC-02`
- `feature-docs-project-overview-visuals` -> `DOC-03`, `DOC-04`, `DOC-05`, `DOC-06`, `DOC-07`, `DOC-08`, `DOC-09`
- `feature-docs-cvss31-templates` -> `DOC-10`
- `feature-permission-policy-task-rules` -> `PERM-01`, `PERM-02`, `PERM-03`
- `feature-agent-model-defaults` -> `ARCH-03`, `ARCH-04`, `ARCH-05`, `ARCH-06`
- `feature-agent-mode-visibility-color` -> `ARCH-07`, `ARCH-08`, `ARCH-09`
- `feature-skill-prefix-taxonomy` -> `PREFIX-01`
- `feature-skill-prefix-migration` -> `PREFIX-02`, `PREFIX-04`
- `feature-idea-validation-subagent` -> `IDEA-01`
- `feature-idea-impact-subagent` -> `IDEA-02`
- `feature-idea-local-sanitization` -> `IDEA-04`
- `feature-idea-dedicated-recon-agent` -> `IDEA-05`
- `feature-idea-optrs-support` -> `IDEA-06`
- `feature-idea-multi-llm-validation` -> `IDEA-07`
- `feature-idea-cvss4-support` -> `IDEA-08`
- `feature-idea-sensitive-redaction` -> `IDEA-09`

## Skill Prefix Taxonomy

### Prefix groups

- `vuln-` -> vulnerability/finding-focused skills
- `scanmode-` -> scan depth/mode skills
- `agent-` -> agent-specific orchestration/report workflows
- `project-` -> project-specific workflow/helper skills
- `guide-` -> helper/operator usage skills

### Current to target names

- `authentication-jwt` -> `vuln-authentication-jwt`
- `broken-function-level-authorization` -> `vuln-broken-function-level-authorization`
- `business-logic` -> `vuln-business-logic`
- `csrf` -> `vuln-csrf`
- `idor` -> `vuln-idor`
- `information-disclosure` -> `vuln-information-disclosure`
- `insecure-file-uploads` -> `vuln-insecure-file-uploads`
- `mass-assignment` -> `vuln-mass-assignment`
- `open-redirect` -> `vuln-open-redirect`
- `path-traversal-lfi-rfi` -> `vuln-path-traversal-lfi-rfi`
- `race-conditions` -> `vuln-race-conditions`
- `rce` -> `vuln-rce`
- `sql-injection` -> `vuln-sql-injection`
- `ssrf` -> `vuln-ssrf`
- `subdomain-takeover` -> `vuln-subdomain-takeover`
- `xss` -> `vuln-xss`
- `xxe` -> `vuln-xxe`
- `scan-quick` -> `scanmode-quick`
- `scan-standard` -> `scanmode-standard`
- `scan-deep` -> `scanmode-deep`
- `root-agent` -> `agent-root`
- `pentest-report` -> `agent-report`
- `usage` -> `project-usage`

## Completed TODOs (grouped by topic)

### Runtime, DB, and API correctness

- [x] [P0] Fix artifact attach ID confusion: support proposal-to-finding resolution in artifact flow (either new `pentest_attach_artifact_by_proposal` or optional `proposal_id` in `pentest_attach_artifact`), and return explicit error when a proposal ID is passed as `finding_id`.
- [x] [P0] Add canonical run-path API for agents (`run_dir`, `evidence_dir`, `report_dir`) and require artifact writes under run directory to prevent `ENOENT` from cwd writes.
- [x] [P0] Eliminate split write roots (`data/pentest/...` vs `packages/opencode/...`): force all runtime outputs (screenshots, logs, yml/json evidence, artifacts) into run-scoped `data/pentest/running/<run_id>/...` and add a one-time cleanup/migration for stray files.
- [x] [P1] Harden tool argument validation for required fields (for example `run_id`) and replace low-level TypeErrors with user-facing validation errors.
- [x] [P1] Improve proposal payload contract enforcement feedback (clear canonical schema errors for `name|severity|description`, CVSS v4 format, and supported asset shape).
- [x] [P1] Add proposal payload preflight validation (`name`, `severity`, `description`, CVSS v4, `assets` shape) before `pentest_add_proposal` to reduce repeated submit-fail-retry loops in subagents.
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
- [x] [P1] Update `.opencode/skills/agent-report/SKILL.md` quality-gate wording so pending proposals block build in all safety modes.
- [x] [P1] Update reporting prompt to merge overlapping findings (same root cause/endpoint scope).
- [x] [P1] Update reporting prompt to fill narrative fields before build: `summary_text`, `subject_description`, `scope_targets_markdown`, `methodology_details`, `events`.
- [x] [P0] Enforce onboarding-first root behavior as hard gate before valid `run_id` and add prompt-contract coverage.
- [x] [P0] Enforce root safeguard to avoid run-scoped DB calls before valid `run_id` and add prompt-contract coverage.
- [x] [P0] Enforce reporting-only build path from root (no direct script/skill build execution) and add prompt-contract coverage.
- [x] [P0] Enforce finalize verification contract (`pentest_finalize_run` + `pentest_get_report_paths` with finalized status) in root/reporting prompts.
- [x] [P1] Add prompt-contract test that root cannot take direct report-build actions (no direct reporting skill/script execution; must delegate to reporting task flow).
- [x] [P1] [CONTRACT-05] Remove redundant root prompt content in `.opencode/agents/root.md` (duplicate intake option list, duplicate completion rule) and condense scope decomposition to one concise instruction line.

### Documentation and visualization

- [x] [P1] [DOC-03] Fix stale docs references to pruned files in project docs (for example prune lists that still mention only `README*.md` while `CONTRIBUTING.md`, `SECURITY.md`, and `STATS.md` are also pruned).
- [x] [P2] [DOC-04] Add a Mermaid system-context diagram to `project.md` showing OpenCode runtime, OpenHack layer, and `data/pentest` runtime state boundaries.
- [x] [P2] [DOC-05] Add OpenCode package/runtime topology diagrams to `project-opencode.md` (package dependency view and runtime component flow).
- [x] [P2] [DOC-06] Add OpenHack workflow diagrams to `project-openhack.md` (agent orchestration, proposal-to-finding state flow, run lifecycle).
- [x] [P2] [DOC-07] Add a short "Use this doc if..." routing box to `project.md` for faster navigation between `project-opencode.md` and `project-openhack.md`.
- [x] [P2] [DOC-08] Add a "where to change what" impact matrix to `project-opencode.md` (feature/change type -> directories/files).
- [x] [P2] [DOC-09] Add a trust/sensitivity boundary diagram to `project-openhack.md` for `data/pentest/**` evidence/report artifacts.
- [x] [P1] [DOC-10] Verify CVSS references in `.opencode/skills/agent-report/tests/openhack-juice-shop-test.md` and `openhack-report-template_v1.md` remain CVSS 3.1; no content changes required.

### Tooling maintenance

- [x] [P2] Verify dependency check script still validates: `script/pentest-report-deps.sh`.

## Changelog

This section is the canonical changelog for this repository backlog workflow. Keep newest entries first.

### 2026-02-23

- Completed `CONTRACT-05`: trimmed redundant root prompt intake/completion text and condensed scope decomposition in `.opencode/agents/root.md`.
- Completed `DOC-03` through `DOC-09` across `project.md`, `project-opencode.md`, and `project-openhack.md` (stale reference cleanup, routing box, topology/workflow diagrams, trust boundary diagram, and impact matrix), and completed `DOC-10` as verification-only because CVSS references were already 3.1 in `.opencode/skills/agent-report/tests/openhack-juice-shop-test.md` and `openhack-report-template_v1.md`.

### 2026-02-22

- TODO management refactor in `TODO.md`: grouped active backlog by execution area, added stable IDs, and added `(partial)` progress markers.
- Moved verified-resolved items into completed tracking in `TODO.md` (`proposal preflight validation`, `dependency check script validation`).
- Added non-urgent feature backlog section `## Bigger Ideas` in `TODO.md`.
- Added and standardized the in-file changelog section in `TODO.md` (replacing standalone `changelog.md`).
- Added proposed skill-prefix taxonomy and migration plan in `TODO.md`, including `feature-xxx` branch mapping and current->target skill names.
- Updated skill-prefix taxonomy so `usage` is treated as project-specific: `usage` -> `project-usage`.

### 2026-02-19

- Enabled OpenCode tool permissions in project config: `websearch` is set to `allow` in `.opencode/opencode.jsonc`.
- Enabled Exa-backed web search for non-OpenCode providers by setting `OPENCODE_ENABLE_EXA=1`.
- Made `OPENCODE_ENABLE_EXA=1` persistent in shell exports and ensured the `openhack` alias runs with it.
