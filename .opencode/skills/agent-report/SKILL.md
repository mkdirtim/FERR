---
name: agent-report
description: Create and finalize OpenHack penetration test reports from runtime DB data, evidence, and screenshots. Use when asked to build reports from pentest run state and render deliverables in PDF, HTML, DOCX, or all formats.
---

# Pentest Report

Build client-ready reports with this sequence: materialize markdown from run DB, validate quality gates, render outputs.

## Defaults

- Template: `.opencode/skills/agent-report/assets/openhack-report-template_v1.md`
- Build script: `.opencode/skills/agent-report/scripts/build-report-db.ts`
- Marker reference: `.opencode/skills/agent-report/references/markers.md`
- Proposal contract: `.opencode/skills/agent-report/references/proposal-schema.md`
- Default render output: `data/pentest/running/<run-id>/report/openhack-report.<format>`

## Required Inputs

- Assessor metadata: company name, assessor names, assessor email, report date
- Client and scope metadata: client name, target application, target URL/host, assessment type, test environment
- Findings data: title, severity, CVSS v3.1 vector/score (or `N/A [failed to compute]`), affected assets, status, description, PoC, remediation
- Evidence paths: screenshot/image files referenced in markdown

## Workflow

1. Read run DB and materialize report markdown from template.
2. Validate strictly and fix unresolved placeholders or production guard failures.
3. Render to required format(s).
4. Run final QA checks on output content and figure references.
5. Resolve output locations with `pentest_get_report_paths` after build/finalize.

## Commands

1. Materialize markdown from DB:
- `bun .opencode/skills/agent-report/scripts/build-report-db.ts materialize --run-id <run-id>`

2. Validate materialized report:
- `bun .opencode/skills/agent-report/scripts/build-report-db.ts validate --run-id <run-id>`

3. Build report outputs:
- `bun .opencode/skills/agent-report/scripts/build-report-db.ts build --run-id <run-id> --format pdf`
- `bun .opencode/skills/agent-report/scripts/build-report-db.ts build --run-id <run-id> --format html`
- `bun .opencode/skills/agent-report/scripts/build-report-db.ts build --run-id <run-id> --format docx`
- `bun .opencode/skills/agent-report/scripts/build-report-db.ts build --run-id <run-id> --format all`

## Dependencies

Run:
- `bash script/pentest-report-deps.sh check`

Then install missing requirements:
- `bash script/pentest-report-deps.sh install`

## Quality Gates

- Do not ship reports with unresolved template markers.
- Keep CVSS values in CVSS v3.1 format with calculator links; if vector is `N/A [failed to compute]`, render as plain text without calculator link.
- Keep finding IDs, severity counts, and summary table in sync.
- Ensure every screenshot path used in markdown resolves from report location.
- In production mode, report build fails if required onboarding values still match default placeholders.
- In all safety modes, report build fails if any proposals are still in `proposed` status.
