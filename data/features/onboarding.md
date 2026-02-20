# Onboarding

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

- `How would you like to configure this security assessment for target <target>?`
- `Enter engagement data now` - manually configure assessment context and stakeholder metadata for a real engagement
- `Use defaults for testing` - auto-fill onboarding fields with generic sample values to learn the workflow and verify setup
- `Run against Juice Shop` - auto-fill onboarding fields with OWASP Juice Shop defaults for an end-to-end demo run

Requirement:
- This must be a real `question` tool call, not a plain text prompt that asks for `A/B` input.

Default source:
- `/Users/mkdirtim/FERR/openhack/data/pentest/assets/default-onboarding.md`

Juice Shop defaults source:
- `/Users/mkdirtim/FERR/openhack/data/pentest/assets/default-onboarding-juiceshop.md`

Manual/custom source:
- `/Users/mkdirtim/FERR/openhack/data/pentest/assets/custom-onboarding.md`
- Collect each empty value from the user.

For all modes:
- Set `PH_TARGET_URL` from the initial target input.
- Set `PH_DATE` from CLI (`date +%F`).

## Workflow
1. If target input is provided, run intake decision question first
2. Capture manual engagement data, apply default metadata set, or apply Juice Shop defaults
3. Confirm scope and exclusions in writing
4. Validate access and prerequisite tooling
5. Identify missing inputs and blockers
6. Produce kickoff task breakdown

## Outputs
- Intake mode selected (`manual`, `defaults`, or `juiceshop-defaults`)
- Engagement metadata values used
- Scope checklist (confirmed vs pending)
- Blocker list with owner and next action
- Prioritized kickoff plan for recon, analysis, exploitation, and reporting

## Done Criteria
- Intake decision completed and metadata captured
- Scope and constraints are explicit
- Access is verified or blocker owner is assigned
- First-pass execution plan is ready for handoff
