# CVSS 3.1 Integration (OpenHack)

This document describes the full CVSS integration in OpenHack: the dedicated tool, runtime validation, readiness behavior, and report rendering.

## Scope and Design

- Runtime is CVSS 3.1 only.
- CVSS 4.0 is not accepted by runtime validators.
- CVSS calculation is exposed as a separate tool: `pentest_calculate_cvss`.
- Compute failures are explicit:
  - `cvss_vector = "N/A [failed to compute]"`
  - `cvss_score = null`
  - `severity = null`
  - `status = "failed"`
- Compute failures produce warnings, not build blockers.

## Library and Dependency

- Library: `@neuralegion/cvss` (`1.3.0`)
- Imported in runtime:
  - `calculateBaseScore`
  - `validate` (aliased as `validateCvss31`)
- Relevant files:
  - `/Users/mkdirtim/FERR/openhack/.opencode/lib/pentest-db.ts`
  - `/Users/mkdirtim/FERR/openhack/package.json`
  - `/Users/mkdirtim/FERR/openhack/packages/opencode/package.json`

## Main Components

- Tool schema and registration:
  - `/Users/mkdirtim/FERR/openhack/.opencode/tools/pentest.ts`
- CVSS calculation + validation + readiness + rendering:
  - `/Users/mkdirtim/FERR/openhack/.opencode/lib/pentest-db.ts`
- Agent contracts using the tool:
  - `/Users/mkdirtim/FERR/openhack/.opencode/agents/analysis.md`
  - `/Users/mkdirtim/FERR/openhack/.opencode/agents/reporting.md`
- Tests:
  - `/Users/mkdirtim/FERR/openhack/packages/opencode/test/pentest/pentest-db-runtime.test.ts`
  - `/Users/mkdirtim/FERR/openhack/packages/opencode/test/pentest/pentest-agent-prompts.test.ts`

## Tool Contract: `pentest_calculate_cvss`

The tool is implemented as `calculate_cvss` in `pentest.ts`, exposed as `pentest_calculate_cvss` in agent usage.

### Input

Required CVSS 3.1 base metrics:

- `attack_vector`: `network | adjacent | local | physical`
- `attack_complexity`: `low | high`
- `privileges_required`: `none | low | high`
- `user_interaction`: `none | required`
- `scope`: `unchanged | changed`
- `confidentiality`: `none | low | high`
- `integrity`: `none | low | high`
- `availability`: `none | low | high`

### Output

- `status`: `"ok" | "failed"`
- `cvss_vector`: `string`
  - success: `CVSS:3.1/...`
  - failure: `N/A [failed to compute]`
- `cvss_score`: `number | null`
- `severity`: `"critical" | "high" | "medium" | "low" | "info" | null`
- `message?`: error context on failure

## Calculation Flow

Implemented in `calculateCvss31(...)` in `pentest-db.ts`.

1. Map semantic metric values to CVSS 3.1 short codes.
2. Build deterministic vector:
   - `CVSS:3.1/AV:.../AC:.../PR:.../UI:.../S:.../C:.../I:.../A:...`
3. Validate vector via `validateCvss31`.
4. Compute score via `calculateBaseScore`, rounded to 1 decimal.
5. Derive severity from score:
   - `>= 9.0` -> `critical`
   - `>= 7.0` -> `high`
   - `>= 4.0` -> `medium`
   - `>= 0.1` -> `low`
   - `0.0` -> `info`
6. On exception or invalid score (`NaN`), return `status="failed"` + `N/A` fallback.

## Runtime Validation Rules

`validateCvssVector(...)` enforces accepted vectors for findings/proposal normalization.

Allowed:

- `CVSS:3.1/<metric>:<value>` (validated by regex and library validation)
- exact literal: `N/A [failed to compute]`

Rejected:

- `CVSS:4.0/...`
- malformed 3.1 vectors

Error message:

- `cvss_vector must match CVSS:3.1/<metric>:<value> format or be "N/A [failed to compute]"`

## Proposal and Finding Behavior

- Analysis/Reporting should call `pentest_calculate_cvss` and persist returned `cvss_score`/`cvss_vector`.
- Proposal payload extras are not canonical fields at accept time:
  - `status` / `validated` in proposal payload are ignored unless passed as explicit accept/update overrides.
  - `cwe_ids` and `vulnerability_type` are not persisted as structured finding columns.
- Accept defaults without overrides:
  - `status = open`
  - `validated = false`

## Readiness and Build Semantics

In `checkReadiness(...)`:

- If any finding has `cvss_vector = "N/A [failed to compute]"`:
  - warning: `cvss could not be computed for one or more findings`
  - no blocker from this condition itself

Production CVSS blocker logic:

- Block when CVSS is effectively missing:
  - missing vector, or
  - non-`N/A` vector but missing score
- Do not block solely for `N/A [failed to compute]`.

## Report Rendering

`cvssDisplay(...)` behavior:

- `N/A [failed to compute]` -> plain text
- score without vector -> bold score only
- `CVSS:3.1/...` -> bold score + link to FIRST CVSS 3.1 calculator:
  - `https://www.first.org/cvss/calculator/3.1#<vector>`

## Agent Integration

### Analysis agent

- Allowed to call `pentest_calculate_cvss`.
- Instructed to use it when CVSS metrics are available and store output in proposal payload.
- Instructed to use only CVSS 3.1 vectors.

### Reporting agent

- Allowed to call `pentest_calculate_cvss`.
- Prefers calculated CVSS before writing/updating findings.
- Quality gate requires CVSS for accepted findings:
  - CVSS 3.1 vector + score, or
  - `cvss_vector = N/A [failed to compute]`

## Tests Covering CVSS Integration

`pentest-db-runtime.test.ts` includes:

- deterministic `calculateCvss31` output test
- vector validation test (valid 3.1 + `N/A` accepted, invalid rejected)
- production readiness test for `N/A` warning-only behavior

`pentest-agent-prompts.test.ts` includes:

- prompt contract checks for CVSS 3.1 wording
- prompt contract checks for `pentest_calculate_cvss` usage guidance

## Example Tool Call

Input:

```json
{
  "attack_vector": "network",
  "attack_complexity": "low",
  "privileges_required": "none",
  "user_interaction": "none",
  "scope": "unchanged",
  "confidentiality": "high",
  "integrity": "high",
  "availability": "none"
}
```

Typical output:

```json
{
  "status": "ok",
  "cvss_vector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N",
  "cvss_score": 9.1,
  "severity": "critical"
}
```

Failure output:

```json
{
  "status": "failed",
  "cvss_vector": "N/A [failed to compute]",
  "cvss_score": null,
  "severity": null,
  "message": "failed to compute CVSS base score"
}
```
