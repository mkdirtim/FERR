# Strix Agents and Prompts (Concise)

## Agents Available
- `BaseAgent` (framework base class)
- `StrixAgent` (only concrete agent implementation)

## Runtime Agent Types
- **Root agent**: a `StrixAgent` with `parent_id = None`
- **Subagent**: a `StrixAgent` created via `create_agent(...)` with `parent_id` set

Notes:
- There are no separate Python classes for "discovery", "validation", "reporting", or "fixing" agents.
- Those are prompt/workflow roles, not code-level agent classes.

## Prompt Used

- All agents use the same base template:
  - `strix/agents/StrixAgent/system_prompt.jinja`

## How Prompt Is Composed
Final system prompt = base template + injected blocks:
- Tool schemas (`get_tools_prompt()` from tool XML schemas)
- Scan mode skill (`scan_modes/quick|standard|deep`)
- Loaded skills (`<specialized_knowledge>` block)

## Skill Differences by Agent
- **Root agent default skills**:
  - `root_agent` (from `strix/skills/coordination/root_agent.md`)
  - plus selected scan mode skill
- **Subagent skills**:
  - Whatever is passed in `create_agent(skills=...)`
  - plus selected scan mode skill

## What Is Sent to the LLM Each Iteration
1. `system`: fully rendered system prompt
2. `user`: `<agent_identity>` metadata block (agent name/id)
3. conversation history:
   - Root: task/scoping instructions
   - Subagent: delegated task block and optional inherited context
