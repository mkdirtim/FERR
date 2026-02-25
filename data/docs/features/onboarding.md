# Onboarding

## Verification Status
- Last verified: **2026-02-25**
- Prompt contract source: `.opencode/agents/onboarding.md`
- Tool limitation source: `packages/opencode/src/tool/question.ts`

## Goal
Establish assessment readiness before technical testing starts.

## Scope
- Confirm in-scope targets, exclusions, and constraints
- Validate credentials, access paths, and test windows
- Capture assumptions, dependencies, and blockers

## Inputs
- Rules of engagement
- Target inventory (domains, URLs, APIs)
- Access details (accounts, MFA flow, allowlists)
- Timeline and communication channel

## Intake Decision
When the session starts from a target input (for example `http://localhost:3333`), ask the user via the question tool:

- `How should we initialize this assessment?`
- `Manual setup` - Enter scope, contacts, and engagement details manually.
- `Juice Shop profile` - Apply OWASP Juice Shop defaults for a demo assessment.
- `BadStore profile` - Apply BadStore.net defaults for a demo assessment.

After intake mode is selected, ask scan mode via the question tool:

- `Which scan depth should we apply?`
- `Quick` - Fast, high-impact checks for rapid triage.
- `Standard` - Balanced coverage and validation depth.
- `Deep` - Comprehensive testing with extended chaining.
- `None` - Run without a scan-mode preset; use manual strategy.

Question payload constraints:
- `multiple=false`
- `custom=false` (desired)

Current limitation:
- `question` tool currently omits `custom` from its LLM-facing schema, so `custom=false` cannot be reliably enforced in tool args yet.

Requirement:
- This must be a real `question` tool call, not a plain text prompt that asks for `A/B` input.

Juice Shop defaults source:
- `data/pentest/assets/default-onboarding-juiceshop.md`

Badstore defaults source:
- `data/pentest/assets/default-onboarding-badstore.md`

Manual/custom source:
- `data/pentest/assets/custom-onboarding.md`
- Collect each empty value from the user.

For all modes:
- Set `PH_TARGET_URL` from the initial target input.
- Do not set `PH_DATE` during onboarding. Report build sets date automatically.

## Workflow
1. If target input is provided, run intake decision question first
2. Capture manual engagement data or apply Juice Shop/Badstore defaults
3. Confirm scope and exclusions in writing
4. Validate access and prerequisite tooling
5. Identify missing inputs and blockers
6. Produce kickoff task breakdown for orchestration -> exploitation -> validation -> reporting

## Outputs
- Intake mode selected (`custom`, `juiceshop`, or `badstore`) and DB engagement mode selected (`manual`, `juiceshop-defaults`, or `badstore-defaults`)
- Scan mode selected (`none`, `quick`, `standard`, or `deep`)
- Engagement metadata values used
- Scope checklist (confirmed vs pending)
- Blocker list with owner and next action
- Prioritized kickoff plan for exploitation fan-out, validation fan-out, and reporting

## Done Criteria
- Intake decision completed and metadata captured
- Scope and constraints are explicit
- Access is verified or blocker owner is assigned
- First-pass execution plan is ready for handoff
