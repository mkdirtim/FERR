# Guardrails

This file defines how guardrails work in this repo, what is advisory vs enforced, and when each layer applies.

## Verification Status

- Last verified: **2026-02-25**
- Runtime enforcement source: `.opencode/lib/pentest-db.ts`
- Permission enforcement source: `packages/opencode/src/permission/next.ts`

## Enforcement Levels

| Level | Type | Enforced by | Behavior on violation |
|---|---|---|---|
| L0 | Prompt guidance | Agent prompt files under `.opencode/agents/*.md` | Not hard-blocking by itself; model may still produce invalid output |
| L1 | Tool argument schema | Tool definitions under `.opencode/tools/*.ts` | Tool call is rejected if top-level args fail schema |
| L2 | Runtime/domain validation | Business logic under `.opencode/lib/*.ts` | Hard error; operation fails |
| L3 | Workflow readiness gate | `checkReadiness()` + `buildReport()` in `.opencode/lib/pentest-db.ts` | Build/finalize blocked when gate fails |
| L4 | Permission policy | Agent `permission:` blocks + permission engine | Tool denied/ask/rejected at runtime |
| L5 | Regression tests | Tests under `packages/opencode/test/**` | CI/local tests fail; changes should not merge |
| L6 | Git hook quality gate | `.husky/pre-push` | Push blocked on typecheck failure |

## Where Each Guardrail Applies

### 1) Prompt guardrails (L0)
- Files: `.opencode/agents/orchestration.md`, `.opencode/agents/onboarding.md`, `.opencode/agents/exploitation.md`, `.opencode/agents/validation.md`, `.opencode/agents/reporting.md`
- Used for:
  - workflow sequencing (onboarding first, reporting does acceptance/build)
  - payload conventions (for example `assets` vs `assets_json`)
  - evidence path conventions
- Important: prompt rules are intent, not final truth.

### 2) Tool arg schemas (L1)
- File: `.opencode/tools/pentest.ts`
- Used for:
  - top-level arg shape (for example `run_id`, `payload_json`, `proposal_id`)
- Limitation:
  - `pentest_add_proposal` accepts `payload_json` as a string; nested JSON fields are validated later at runtime (L2), not here.
  - `question` tool currently omits `custom` from its exposed LLM schema (`Question.Info.omit({ custom: true })`), so prompts can request `custom=false` but cannot reliably enforce it via tool args today.

### 3) Runtime/domain validation (L2)
- File: `.opencode/lib/pentest-db.ts`
- Used for:
  - proposal payload parsing and strict checks (`name`, `severity`, `description`)
  - onboarding default seeding from code-owned constants (`.opencode/lib/onboarding-defaults.ts`)
  - CVSS format/range checks (`CVSS:3.1/...`, score `0..10`, or `N/A [failed to compute]`)
  - assets checks (`assets` must be array of non-empty strings)
  - `run_id` UUID validation
  - path safety checks (`rel_path` must stay inside run dir)
  - run mutability checks (`running` only for mutable operations)
  - proposal/finding linkage consistency checks for artifact attachment
- Behavior:
  - throws hard errors and rejects the call.

### 4) Readiness/build gates (L3)
- File: `.opencode/lib/pentest-db.ts`
- `checkReadiness()`:
  - emits warnings (for example CVSS compute failure markers and duplicate proposal fingerprints)
  - emits blockers (for example pending proposals)
  - in production safety mode, enforces stronger blockers (missing required run fields, default placeholders, empty narrative fields, draft findings, missing CVSS where required, empty assets)
- `buildReport()`:
  - always calls `checkReadiness()`
  - fails when `ready=false`

### 5) Permission enforcement (L4)
- Agent-level permissions:
  - each agent frontmatter has explicit allow/deny per tool (`permission:` block)
- Runtime evaluator:
  - file: `packages/opencode/src/permission/next.ts`
  - evaluates rules and returns `allow`, `ask`, or `deny`
  - supports hard deny errors (`DeniedError`, `RejectedError`)

### 6) Tests as guardrails (L5)
- Prompt contract tests:
  - `packages/opencode/test/pentest/pentest-agent-prompts.test.ts`
  - ensures key prompt guardrail text is present (for regression detection)
- Runtime tests:
  - `packages/opencode/test/pentest/pentest-db-runtime.test.ts`
  - ensures DB/tool contracts reject invalid payloads and enforce readiness rules.

### 7) Push-time guardrail (L6)
- File: `.husky/pre-push`
- Enforces:
  - Bun version compatibility check
  - `bun typecheck` before push
- Behavior:
  - push fails if typecheck fails.

## Common Confusion: `assets` vs `assets_json`

### `pentest_add_proposal`
- Field: `assets`
- Type: `string[]`
- Example:
```json
{
  "assets": ["POST /rest/user/login", "GET /rest/user/whoami", "email parameter"]
}
```

### `pentest_accept_proposal` / `pentest_update_finding`
- Field: `assets_json`
- Type: JSON string encoding `string[]`
- Example:
```json
{
  "assets_json": "[\"POST /rest/user/login\",\"GET /rest/user/whoami\"]"
}
```

If object arrays are sent (for example `{ "type": "...", "value": "..." }`), runtime validation will hard-fail.

## Error-to-Fix Quick Map

| Error text | Meaning | Fix |
|---|---|---|
| `proposal payload assets must be a JSON array of strings` | wrong `assets` shape in proposal payload | send `assets: string[]` |
| `proposal payload assets must contain only non-empty strings` | empty or non-string asset values | remove empty/objects; use non-empty strings only |
| `cvss_vector must match CVSS:3.1/<metric>:<value> format or be "N/A [failed to compute]"` | wrong CVSS version/format | use CVSS 3.1 vector, or use `N/A [failed to compute]` when calculation fails |
| `assets_json must be a JSON array of strings` | wrong reporting override payload | pass JSON string array in `assets_json` |
| `pending proposals must be resolved before build` | unresolved proposals at report stage | accept/reject all proposals first |
| `Run ... is not mutable (status=...)` | mutating call on finalized/non-running run | perform write operations only while run is running |
| `Invalid path outside run directory` | path traversal / wrong base | keep artifacts inside run dir, usually `evidence/...` |

## Practical Rule of Thumb

When prompt text and runtime behavior disagree, runtime validation (L2/L3/L4) is the source of truth.
