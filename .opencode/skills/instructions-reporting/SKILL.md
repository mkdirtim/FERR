---
name: instructions-reporting
description: Create and finalize OpenHack penetration test reports from runtime DB data, evidence, and screenshots. Use when asked to build reports from pentest run state and render deliverables in PDF, HTML, DOCX, or all formats.
---

# Pentest Report

Build client-ready reports with this sequence: materialize markdown from run DB, then render outputs.

## Defaults

- Template: `.opencode/skills/instructions-reporting/assets/openhack-report-template_v1.md`
- Build script (manual/debug): `.opencode/skills/instructions-reporting/assets/tests/build-report-db.ts`
- Marker reference: `.opencode/skills/instructions-reporting/references/markers.md`
- Proposal contract: `.opencode/skills/instructions-reporting/references/proposal-schema.md`
- Default render output: `data/pentest/running/<run-id>/report/openhack-report.<format>`

## Required Inputs

- Assessor metadata: company name, assessor names, assessor email, report date
- Client and scope metadata: client name, target application, target URL/host, assessment type, test environment
- Findings data: title, severity, CVSS v3.1 vector/score (or `N/A [failed to compute]`), affected assets, status, description, PoC, remediation
- Evidence paths: screenshot/image files referenced in markdown

## Workflow

1. Materialize report markdown from run DB — throws on unresolved placeholders or production guard failures.
2. Render to required format(s).
3. Run final QA checks on output content and figure references.
4. Resolve output locations with `pentest_get_report_paths` after build/finalize.

## Commands

Prefer tools over the CLI script. Use the CLI for manual debugging only.

1. Materialize markdown from DB:
- Tool: `pentest_materialize_report` with `run_id`
- CLI fallback: `bun .opencode/skills/instructions-reporting/assets/tests/build-report-db.ts materialize --run-id <run-id>`

2. Build report outputs:
- Tool: `pentest_build_report` with `run_id` and `format` (`pdf`, `html`, `docx`, or `all`)
- CLI fallback: `bun .opencode/skills/instructions-reporting/assets/tests/build-report-db.ts build --run-id <run-id> --format <format>`

## Dependencies

pandoc and xelatex are pre-installed in the openhack container image. No manual installation required.

## Quality Gates

- Do not ship reports with unresolved template markers.
- Keep CVSS values in CVSS v3.1 format with calculator links; if vector is `N/A [failed to compute]`, render as plain text without calculator link.
- Keep finding IDs, severity counts, and summary table in sync.
- Ensure every screenshot path used in markdown resolves from report location.
- In production mode, report build fails if required onboarding values still match default placeholders.
- In all safety modes, report build fails if any proposals are still in `proposed` status.
