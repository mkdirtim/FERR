# Reporting

## Goal
Deliver clear, evidence-backed findings with actionable remediation guidance, and document the pentest report skill layout.

## Scope
- Use validated findings only
- Remove duplicates and inconsistent claims
- Prioritize by exploitability and business impact

## Inputs
- Confirmed findings and proof artifacts
- Reproduction steps and affected assets
- Severity rationale and impact notes
- Environment and version context

## Workflow
1. Normalize and deduplicate findings
2. Verify each finding has reproducible evidence
3. Assign severity with clear rationale
4. Write remediation and verification guidance

## Outputs
- Final findings list with severity and confidence
- Reproduction summary and artifact references
- Remediation guidance and retest criteria
- Residual risk and open questions

## Done Criteria
- Every finding is reproducible and scoped
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
- `scripts/`
  - Automation entrypoints for report lifecycle operations.
  - `scripts/build-report.sh`: initialize, fill, validate, and render report outputs.
- `tests/`
  - Fixtures used to validate report content flow and rendering behavior.
  - `tests/openhack-juice-shop-test.md`: sample assessment report input.
  - `tests/screenshots/`: evidence images referenced by the sample report.

## How Components Work Together

1. Start from `assets/openhack-report-template_v1.md` using `scripts/build-report.sh --init`.
2. Fill template markers using `--fill` and validate marker resolution.
3. Render outputs (PDF/HTML/DOCX) with the same script.
4. Use files in `tests/` to smoke-test formatting and image linking behavior.

## Notes

- Keep marker definitions in sync with `references/markers.md`.
- Keep template and rendering assets aligned with the checklist in `TODO`.
