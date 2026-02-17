# TODO: Optional Future Subagents

Optional agents we can add later if you want finer-grained delegation:

- `validation`: keep validation separate from exploitation for stricter QA flow ([agents docs](https://opencode.ai/docs/agents/)).
- `impact`: isolate business-impact demonstration from technical exploitation ([agents docs](https://opencode.ai/docs/agents/)).
- `idor` / `auth` / `sqli` / `xss`: vulnerability-specific specialists for parallel deep dives ([agents docs](https://opencode.ai/docs/agents/)).
- `api`: API-only agent for GraphQL and complex authz patterns ([agents docs](https://opencode.ai/docs/agents/)).
- `infra-web`: web-reachable infrastructure and misconfiguration checks ([agents docs](https://opencode.ai/docs/agents/)).
- Set `temperature` for root and subagents ([temperature docs](https://opencode.ai/docs/agents/#temperature)).
- Set `top_p` for root and subagents to control response diversity ([top_p docs](https://opencode.ai/docs/agents/#top-p)).
- Set `steps` (max-steps) for root and subagents ([max-steps docs](https://opencode.ai/docs/agents/#max-steps)).
- Evaluate provider-specific additional model options per agent (for example `reasoningEffort`, `textVerbosity`) and document chosen defaults ([additional options docs](https://opencode.ai/docs/agents/#additional)).
- Define explicit tool allow/deny policy for root and subagents, including wildcard tool rules where useful ([tools docs](https://opencode.ai/docs/agents/#tools), [tools reference](https://opencode.ai/docs/tools/)).
- Review and document `mode` for each agent (`primary`, `subagent`, `all`) to ensure intended usage paths ([mode docs](https://opencode.ai/docs/agents/#mode)).
- Decide which subagents should be `hidden: true` for Task-only/internal use and which should stay visible in `@` autocomplete ([hidden docs](https://opencode.ai/docs/agents/#hidden)).
- Define `permission.task` delegation rules for the root/orchestrator using glob patterns, with explicit default deny and ordered allow/ask exceptions ([task permissions docs](https://opencode.ai/docs/agents/#task-permissions)).
- Assign `color` for root and each subagent (theme color or hex) for clearer UI differentiation ([color docs](https://opencode.ai/docs/agents/#color)).

Current active subagent set:

- `recon`
- `analysis`
- `exploitation`
- `reporting`
