# Reporting

## Verification Status
- Last verified: **2026-02-25**
- Prompt contract source: `.opencode/agents/reporting.md`
- Runtime/report pipeline source: `.opencode/lib/pentest-db.ts`

## Goal
Deliver clear, evidence-backed findings with actionable remediation guidance and produce finalized run-scoped report artifacts.

## Scope
- Use DB state as source of truth.
- Resolve duplicate/overlapping `validated` proposals before acceptance.
- Accept only `validated` proposals into canonical findings.
- Build/finalize only after readiness passes.

## Inputs
- Proposal set from `pentest_get_proposals(run_id)`.
- Finding/report context from `pentest_get_findings` and `pentest_get_run`.
- Evidence and CVSS context attached through proposal/finding lifecycle.

## Workflow
1. Fetch proposals.
2. If any proposal is still `proposed`, return blockers and stop (`no build`).
3. Resolve duplicates among `validated` proposals:
   - reject true duplicates with `pentest_reject_proposal`.
   - merge complementary duplicates with `pentest_merge_proposals`.
4. If merges were created, return `revalidate_proposal_ids` and stop (`no build`).
5. Accept remaining `validated` proposals with `pentest_accept_proposal`.
6. Run `pentest_check_readiness`.
7. If readiness is not ready, return blockers and stop (`no build`).
8. Run `pentest_build_report`.
9. Run `pentest_finalize_run`.
10. Verify finalized state and paths via `pentest_get_report_paths` and require `run_status=finalized`.

## Hard Stops
- After any `pentest_merge_proposals` call, return immediately and do not accept/build/finalize in that same pass.
- Do not run shell report scripts from this agent path (for example `bun .../build-report-db.ts`); use pentest tools only.

## Outputs
- Accepted findings summary.
- Rejected duplicate proposal IDs and reasons.
- `revalidate_proposal_ids` when merges require validation before next reporting pass.
- Readiness/build/finalize results.
- Unresolved blockers, if any.

## Done Criteria
- Every accepted finding came from a `validated` proposal.
- No unresolved `proposed` proposals remain when build is attempted.
- Finalize completed and `pentest_get_report_paths` confirms `run_status=finalized`.
