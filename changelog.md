# Changelog

## 2026-02-19

- Enabled OpenCode tool permissions in project config: `websearch` is set to `allow` in `.opencode/opencode.jsonc`.
- Enabled Exa-backed web search for non-OpenCode providers by setting `OPENCODE_ENABLE_EXA=1`.
- Made `OPENCODE_ENABLE_EXA=1` persistent in shell exports and ensured the `openhack` alias runs with it.
