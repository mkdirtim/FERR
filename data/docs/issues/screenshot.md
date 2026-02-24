# Screenshot Artifact Path Problem

## Summary

Screenshot capture and artifact attachment are enforced at different layers:

- Capture path location is mostly prompt-driven (soft guidance).
- Artifact attachment is runtime-validated (hard enforcement).

Result: screenshots can be created outside the run evidence directory, then `pentest_attach_artifact` fails until files are manually moved/copied.

## Evidence

### Session symptoms (observed)

1. Attach failed with:
   - `artifact file not found in run directory: evidence/jwt-localstorage-token-found.png ...`
2. Files were later found under:
   - `packages/opencode/jwt-localstorage-token-found.png`
   - `packages/opencode/jwt-forged-token-blocked.png`
3. After copying those files into:
   - `data/pentest/running/<run_id>/evidence/`
   attach succeeded.

This shows the screenshot write path and attachment read path were not aligned.

### Hard checks in code (current behavior)

1. `attachArtifact` requires the file to exist under run directory and rejects otherwise:
   - `.opencode/lib/pentest-db.ts:1606`
   - `.opencode/lib/pentest-db.ts:1609`
2. Path traversal/outside-run paths are rejected:
   - `.opencode/lib/pentest-db.ts:563`
   - `.opencode/lib/pentest-db.ts:567`
3. Evidence directory is available via run metadata:
   - `.opencode/lib/pentest-db.ts:1357`
   - `.opencode/lib/pentest-db.ts:1367`

### Prompt guidance exists but is soft

Agents are told to write browser outputs to absolute paths under `evidence_dir`:

- `.opencode/agents/analysis.md:45`
- `.opencode/agents/recon.md:41`
- `.opencode/agents/exploitation.md:38`
- `.opencode/agents/reporting.md:58`
- `.opencode/agents/root.md:63`

But this is not guaranteed at runtime if a tool call uses a relative filename.

## Root Cause

1. **Split enforcement boundary**
   - Capture location is not uniformly hard-enforced by the pentest runtime.
   - Attachment location is hard-enforced.
2. **Relative filename behavior**
   - Screenshot tools can write to current working directory when given relative names.
3. **Late failure point**
   - Problem is detected only during `pentest_attach_artifact`, not at capture time.

## Impact

1. Repeated attach failures and retries.
2. Manual copy/move recovery steps during runs.
3. Higher chance of missing evidence in final findings/report.
4. Noisy agent traces and slower execution.

## Possible Fixes

## 1) Immediate operational fix (no platform change)

At subagent task start:

1. Resolve/store `evidence_dir` once (`pentest_get_evidence_directory` or use root-provided value).
2. Use absolute capture paths only:
   - `${evidence_dir}/<kind>-<timestamp>-<rand>.png`
3. Before `pentest_attach_artifact`, verify file exists at that exact absolute path.

Pros: quick and low risk.
Cons: still relies on prompt compliance.

## 2) Strong fix (recommended)

Add a dedicated pentest wrapper tool for screenshots, e.g. `pentest_capture_screenshot`, that:

1. Accepts `run_id`, `filename`, and capture options.
2. Resolves and enforces write path under the active run `evidence_dir`.
3. Returns canonical values:
   - `abs_path`
   - `rel_path` (`evidence/<filename>`)

Pros: hard enforcement at capture time, no CWD leakage.
Cons: requires implementation work.

## 3) Optional safety net

Add a helper validator/tool (`pentest_assert_evidence_file`) used before attach:

1. Confirms file exists under `run_dir/evidence`.
2. Returns normalized `rel_path`.

Pros: catches drift earlier.
Cons: extra call unless integrated into capture wrapper.

## Acceptance Criteria for a Real Fix

1. No screenshot written outside `run_dir/evidence` in pentest flows.
2. No manual file move/copy needed after capture.
3. `pentest_attach_artifact` succeeds on first attempt for valid captures.
4. Negative test: relative screenshot filename cannot leak to CWD.
5. Positive test: capture returns stable `rel_path = evidence/<filename>`.
