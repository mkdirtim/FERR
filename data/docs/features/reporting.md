# Reporting

## Goal
Deliver clear, evidence-backed findings with actionable remediation guidance, and document the pentest report skill layout.

## Scope
- Use `validated` proposals only
- Reject duplicates with full-context judgment
- Prioritize by exploitability and business impact

## Inputs
- Confirmed findings and proof artifacts
- Reproduction steps and affected assets
- Severity rationale and impact notes
- Environment and version context

## Workflow
1. If any proposal is still `proposed`, return blockers (no build).
2. Reject duplicates among `validated` proposals.
3. Accept remaining `validated` proposals into canonical findings.
4. Assign severity with clear rationale.
5. Run readiness preflight before build.
6. Build and finalize report artifacts.

## Outputs
- Final findings list with severity and confidence
- Reproduction summary and artifact references
- Remediation guidance and retest criteria
- Residual risk and open questions

## Done Criteria
- Every accepted finding came from a `validated` proposal
- Severity and impact are justified
- Remediation steps are concrete and testable

## Pentest Report Skill Layout

This documents:

```text
.
├── SKILL.md
├── TODO
├── assets
│   ├── eisvogel.latex
│   ├── images
│   │   ├── openhack-report-background.pdf
│   │   └── openhack-report-placeholder.png
│   └── openhack-report-template_v1.md
├── references
│   └── markers.md
├── scripts
│   ├── build-report-db.ts
│   └── build-report.sh
└── tests
    ├── openhack-juice-shop-test.md
    └── screenshots
        ├── 01-homepage.png
        ├── 02-captcha-bypass.png
        ├── 03-sql-injection-schema.png
        ├── 04-ftp-directory.png
        ├── 05-admin-config.png
        ├── 06-idor-track-order.png
        └── 07-contact-form-captcha.png
```

## Tree Overview

- `SKILL.md`
  - Skill contract and operating workflow for generating reports.
  - Defines defaults, required inputs, commands, dependencies, and quality gates.
- `TODO`
  - Maintenance checklist for template/theme parity and fixture upkeep.
- `assets/`
  - Static authoring and rendering assets used by report generation.
  - `assets/openhack-report-template_v1.md`: base markdown template with `PH_*` and `TODO_*` markers.
  - `assets/eisvogel.latex`: Pandoc LaTeX template used for styled PDF rendering.
  - `assets/images/`: shared visuals used by the report template.
- `references/`
  - Reference documentation used during authoring and validation.
  - `references/markers.md`: placeholder marker definitions and expected values.
- `assets/tests/`
  - Fixtures and manual tooling for validating report content flow and rendering behavior.
  - `assets/tests/openhack-juice-shop-test.md`: sample assessment report input.
  - `assets/tests/screenshots/`: evidence images referenced by the sample report.
  - `assets/tests/build-report-db.ts`: manual CLI for materialize/build (debug use only; agents use `pentest_materialize_report` and `pentest_build_report` tools).

## How Components Work Together

1. Read runtime DB run state and materialize markdown via `pentest_materialize_report` tool.
2. Render outputs (PDF/HTML/DOCX) via `pentest_build_report` tool.
3. Use files in `assets/tests/` to smoke-test formatting and image linking behavior.

## Notes

- Keep marker definitions in sync with `references/markers.md`.
- Keep proposal payloads aligned with `references/proposal-schema.md`.
- Keep template and rendering assets aligned with the checklist in `TODO`.
