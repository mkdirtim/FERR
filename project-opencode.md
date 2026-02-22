# OpenCode Project Overview

This document covers the OpenCode product layer in this repository (runtime, apps, SDK, and shared packages).

## Scope

OpenCode in this repo includes:
- CLI/TUI runtime,
- API server,
- web app,
- desktop app,
- SDK and shared libraries used by those surfaces.

OpenHack-specific pentest workflows are documented in `project-openhack.md`.

## Core Top-Level Paths

| Path | Purpose |
| --- | --- |
| `package.json` | Monorepo scripts, workspace config, dependency catalog |
| `turbo.json` | Turborepo task graph |
| `packages/` | Product packages and shared libraries |
| `script/` | Repo-level utilities (`generate.ts`, formatting, report deps helper) |
| `patches/` | Patched upstream dependencies |
| `third_party_licenses/` | Third-party license attribution |
| `CONTRIBUTING.md` | Contributor workflow and expectations |
| `SECURITY.md` | Security policy and trust model |
| `AGENTS.md` | Local coding/testing guardrails for contributors |

## Package Map

| Package | Purpose |
| --- | --- |
| `packages/opencode` | Core runtime: CLI/TUI/server, agent/session/tooling infrastructure |
| `packages/app` | Web frontend (Solid + Vite) |
| `packages/desktop` | Tauri desktop wrapper around app UI |
| `packages/sdk/js` | JavaScript SDK (`@opencode-ai/sdk`) |
| `packages/ui` | Shared UI components and theme primitives |
| `packages/util` | Shared utility library |
| `packages/plugin` | Plugin helpers and tool schema helpers |
| `packages/script` | Shared internal script helpers |

## Runtime Areas (`packages/opencode/src/`)

Key directories:
- `cli/`, `server/`: user-facing runtime entrypoints
- `agent/`, `session/`, `tool/`, `skill/`: orchestration and tool/skill runtime
- `provider/`, `mcp/`: model provider + MCP integration
- `permission/`, `shell/`, `pty/`, `worktree/`: local execution and workspace boundaries
- `project/`, `config/`, `storage/`: metadata, config loading, persistence

## Common Commands

### Local Development
1. `bun install`
2. `bun dev` (CLI/TUI)
3. Optional web UI: `bun run --cwd packages/app dev`
4. Optional desktop UI: `bun run --cwd packages/desktop tauri dev`

### Build and Typecheck
- Typecheck monorepo: `bun run typecheck`
- Build core package: `bun run --cwd packages/opencode build`
- Build desktop app: `bun run --cwd packages/desktop tauri build`

### Generation
- Regenerate runtime-generated files: `./script/generate.ts`
- Regenerate JavaScript SDK: `./packages/sdk/js/script/build.ts`

## Testing

- Root `bun test` is intentionally blocked in this repo.
- Run tests from package directories (for example `packages/opencode`, `packages/app`).
- Core runtime tests are under `packages/opencode/test/`.

## Branching and Diffs

- Default branch is `dev`.
- Use `dev` or `origin/dev` as your diff base.
