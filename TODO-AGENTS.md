Plan: Simplify Agent Workflow Documentation (All Agents)

 Context

 All agent files follow the same two patterns that add noise without value:
 1. Explicit deny permission entries — subagent permissions default to deny if not listed
 2. Repetition of the standard output contract (status, proposals_submitted, errors,
 coverage) already defined once in root.md's Subagent Output Contract section

 Feature specs for onboarding and reporting additionally contain misplaced or overstated
 content that doesn't reflect what the agents actually do.

 No behavioral changes — documentation-only simplification pass.

 ---
 Changes by File

 .opencode/agents/onboarding.md

 Remove 8 explicit deny entries from permission block:
 pentest_add_proposal: deny
 pentest_add_finding: deny
 pentest_update_finding: deny
 pentest_delete_finding: deny
 pentest_attach_artifact: deny
 pentest_build_report: deny
 pentest_materialize_report: deny
 pentest_finalize_run: deny

 .opencode/agents/reporting.md

 Remove 2 explicit deny entries:
 pentest_set_onboarding: deny
 pentest_create_run: deny

 .opencode/agents/recon.md

 Remove 4 explicit deny entries:
 pentest_add_finding: deny
 pentest_update_finding: deny
 pentest_build_report: deny
 pentest_finalize_run: deny
 Additionally: condense "Output to parent" — the first 4 fields (status,
 proposals_submitted, errors, coverage) repeat the standard contract from root.md.
 Replace with: "Standard output contract (see root) plus:" followed by only the
 recon-specific fields:
 - In-scope assets discovered
 - Endpoint and parameter inventory
 - Auth boundaries and session surfaces
 - Tech stack and notable controls
 - Prioritized targets with rationale

 .opencode/agents/analysis.md

 Same changes as recon: remove 4 explicit deny entries and condense Output section.
 Analysis-specific output fields to keep:
 - Candidate vulnerabilities with exact location and signal
 - Reproduction hypotheses and required preconditions
 - Priority order for exploitation work

 .opencode/agents/exploitation.md

 a) Remove 4 explicit deny entries (same pattern as recon/analysis):
 pentest_add_finding: deny
 pentest_update_finding: deny
 pentest_build_report: deny
 pentest_finalize_run: deny

 b) Fix ambiguous wording on line 33:
 "Persist confirmed or rejected outcomes as proposals"

 "Rejected outcomes" implies exploitation performs proposal lifecycle actions (accept/reject),
 which is reporting's responsibility. Change to:
 "Persist confirmed outcomes and non-exploitable candidate notes as proposals"

 This removes the lifecycle confusion flagged in Master-TODO P1 Agent Prompt.

 Condense Output section the same way as recon/analysis (standard contract reference +
 exploitation-specific fields only).

 .opencode/agents/root.md

 Three redundancies:

 a) Intake Workflow lines 72–74: remove duplicate option list. Line 75 already says
 "onboarding has a canonical question payload — do not rephrase." The list contradicts
 this and creates a second maintenance point.

 b) Completion step 3: remove — duplicates DB Runtime Rule line 28 ("Never treat
 open proposals as acceptable for report build completion") verbatim.

 c) Scope Decomposition: replace 4 numbered steps with one sentence:
 Before spawning agents, identify attack surfaces, define in-scope boundaries,
 determine assessment mode (blackbox/greybox/whitebox), and prioritize by risk.

 ---
 data/features/onboarding.md

 The agent only does steps 1–2 of the 6-step Workflow. Steps 3–6 are root
 responsibilities. Trim to match reality:

 - Workflow: keep steps 1–2 only, remove 3–6
 - Remove from Outputs: scope checklist, blocker list, kickoff plan
 - Remove from Done Criteria: scope explicit, access verified, execution plan ready
 - Remove: duplicate question payload (lines 20–23) — lives in agent file
 - Remove: asset file paths (lines 28–36) — implementation detail

 data/features/reporting.md

 Lines 36–103 ("Pentest Report Skill Layout" through "Notes") are skill reference
 documentation, not workflow spec. This content already belongs in
 .opencode/skill/pentest-report/SKILL.md. Remove lines 36–103 entirely.
 Lines 1–35 (Workflow, Inputs, Outputs, Done Criteria) are accurate and stay.

 Also fix the Goal line to remove the orphaned clause: change
 "Deliver clear, evidence-backed findings with actionable remediation guidance, and document the pentest report skill layout."

 To:
 "Deliver clear, evidence-backed findings with actionable remediation guidance."

 .opencode/agents/reporting.md — fix narrative field rule (P0-1)

 Line 38 currently reads:
 "Before build, ensure narrative fields are populated: summary_text,
 subject_description, scope_targets_markdown, methodology_details, events."

 This is contradictory: pentest_set_onboarding (the only tool that writes these fields)
 is denied for reporting. Reporting cannot satisfy its own rule. The full fix (a new
 dedicated pentest_set_report_narrative tool) is tracked separately in Master-TODO P0-1.

 Doc fix: replace line 38 with:
 "Before build, verify narrative fields are populated via pentest_check_readiness.
 If blocked by missing narratives, return the blocker list to root to complete."

 This makes it a verification step (which reporting can do) rather than a write step
 (which it cannot).

 .opencode/skill/pentest-report/SKILL.md — fix stale quality-gate wording (P0-2)

 Line 61 currently reads:
 "In production mode, report build fails if any proposals are still in proposed status."

 This is stale. Pending proposals now block build in all safety modes (runtime behavior
 confirmed in pentest-db.ts and updated in db.md). Change to:
 "In all safety modes, report build fails if any proposals are still in proposed status."

 ---
 Out of Scope (tracked in Master-TODO)

 - pentest_set_report_narrative new tool (P0-1 full fix) — requires code change
 - Root skill/agent drift (P0-3) — no root-agent skill file found in repo
 - Tooling hardening: contact validation, finalized-run reads, not-found contracts (P1)
 - Observability tools: pentest_get_run_health, pentest_get_open_actions (P2)

 ---
 Files Modified

 ┌─────────────────────────────────────────┬──────────────────────────────────────────────────────────────────────────┐
 │                  File                   │                                Net change                                │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/agents/onboarding.md          │ −8 deny lines                                                            │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/agents/reporting.md           │ −2 deny lines, fix narrative rule (verify vs write)                      │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/agents/recon.md               │ −4 deny lines, condensed output section                                  │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/agents/analysis.md            │ −4 deny lines, condensed output section                                  │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/agents/exploitation.md        │ −4 deny lines, fix "rejected outcomes" wording, condensed output section │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/agents/root.md                │ −option list, −duplicate proposal step, condensed scope decomposition    │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ data/features/onboarding.md             │ −steps 3–6, trimmed outputs/criteria, −duplicate payload/paths           │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ data/features/reporting.md              │ −lines 36–103 (skill layout section)                                     │
 ├─────────────────────────────────────────┼──────────────────────────────────────────────────────────────────────────┤
 │ .opencode/skill/pentest-report/SKILL.md │ fix line 61: proposals block all modes, not production-only              │
 └─────────────────────────────────────────┴──────────────────────────────────────────────────────────────────────────┘

 Files NOT touched

 - pentest-db.ts, test files — no behavioral change

 ---
 Verification

 - All agent files: only allow entries remain (plus edit: deny and
 external_directory: deny which are meaningful explicit restrictions)
 - Recon + analysis + exploitation output sections: 4-field standard contract replaced by reference
 - Root: no option list in Intake Workflow, no proposal step in Completion, 1-sentence
 Scope Decomposition
 - Onboarding feature spec: 2-step Workflow, 2 Outputs, 1 Done Criterion
 - Reporting feature spec: ends at line 35, Goal line updated
 - Canonical question payload and modes remain solely in .opencode/agents/onboarding.md
