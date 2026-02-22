# Project Overview

This repository is a Bun/Turbo monorepo for OpenCode plus OpenHack security-assessment workflows.
It contains:
- the core OpenCode runtime (CLI/TUI/server),
- web and desktop clients,
- shared SDK/UI/util packages,
- security-focused agent workflows and pentest runtime state.

## Who This Is For

### Users
- Run OpenCode locally (TUI/CLI): `bun dev`
- Run API server: `bun dev serve`
- Run desktop app: `bun run --cwd packages/desktop tauri dev`
- Run web app: `bun run --cwd packages/app dev` (with server running)

### Developers
- Primary contributor guide: `CONTRIBUTING.md`
- Security policy and trust boundaries: `SECURITY.md`
- Local coding/style guardrails for this repo: `AGENTS.md`

## Top-Level Layout

| Path | Purpose |
| --- | --- |
| `package.json` | Monorepo scripts, workspace config, shared dependency catalog |
| `turbo.json` | Turborepo task graph (`typecheck`, `build`, package-scoped test tasks) |
| `bun.lock` | Dependency lockfile |
| `packages/` | Main product and shared library packages |
| `.opencode/` | OpenHack-specific OpenCode config, pentest DB tools, security subagent prompts/skills |
| `data/` | Runtime docs and pentest run artifacts (`running` and `finished`) |
| `docker/` | Containerized dev + target lab + benchmarking environment |
| `script/` | Repo-level utility scripts (SDK/code generation, formatting, report deps) |
| `patches/` | Patched upstream dependencies |
| `third_party_licenses/` | Third-party attribution/license details |
| `README.md`, `README.uk.md` | Minimal project docs and alternate-language readme |
| `SECURITY.md`, `CONTRIBUTING.md` | Security policy and contribution process |

## Packages Map (`packages/`)

| Package | Purpose |
| --- | --- |
| `packages/opencode` | Core runtime: CLI/TUI/server, agent/session/tooling infrastructure |
| `packages/app` | Web frontend (Solid + Vite), unit/e2e test entrypoints |
| `packages/desktop` | Tauri desktop wrapper around app UI |
| `packages/sdk/js` | JavaScript SDK (`@opencode-ai/sdk`) |
| `packages/ui` | Shared UI component and theme package |
| `packages/util` | Shared utilities |
| `packages/plugin` | Plugin tooling (`@opencode-ai/plugin`) |
| `packages/script` | Shared script helpers |

## Core Runtime Areas (`packages/opencode/src/`)

Key directories to know:
- `cli/`, `server/`: command-line and HTTP/server entrypoints
- `agent/`, `session/`, `tool/`, `skill/`: orchestration, runtime state, tools, skills
- `provider/`, `mcp/`: model providers and MCP integration
- `permission/`, `shell/`, `pty/`, `worktree/`: local execution and workspace controls
- `project/`, `config/`, `storage/`: project metadata, config handling, persistence

## OpenHack Security Layer (`.opencode/`)

| Path | Purpose |
| --- | --- |
| `.opencode/opencode.jsonc` | Local OpenCode config (provider, MCP, permissions) |
| `.opencode/tools/pentest.ts` | Tool surface for pentest operations (`create_run`, `add_proposal`, `build_report`, etc.) |
| `.opencode/lib/pentest-db.ts` | Canonical pentest runtime DB logic, readiness gates, report assembly/finalize flow |
| `.opencode/agents/*.md` | Security subagent role prompts (`root`, `onboarding`, `analysis`, `reporting`, etc.) |
| `.opencode/skill/*/SKILL.md` | Vulnerability testing playbooks (SQLi, XSS, IDOR, CSRF, SSRF, JWT, RCE, XXE, etc.) |
| `.opencode/skill/pentest-report/` | Report templates, schema references, build scripts, test fixtures |
| `.opencode/scripts/migrate-runtime-artifacts.sh` | Stray artifact migration into run-scoped folders |

## Runtime Data (`data/`)

| Path | Purpose |
| --- | --- |
| `data/features/` | Workflow docs (`db.md`, `onboarding.md`, `reporting.md`) |
| `data/pentest/assets/` | Onboarding defaults and archived template snippets |
| `data/pentest/running/<run_id>/` | Active run state (`run.db`, `evidence/`, `report/`) |
| `data/pentest/finished/<run_id>/` | Finalized run state and report artifacts |

Notes:
- `run.db` is the canonical run state for each assessment.
- Evidence and generated reports are intentionally run-scoped under each `run_id`.

## Scripts and Generation

- Regenerate OpenCode-generated files: `./script/generate.ts`
- Regenerate JavaScript SDK: `./packages/sdk/js/script/build.ts`
- Check/install report build dependencies: `script/pentest-report-deps.sh`

## Dev Workflows

### Local Development
1. `bun install`
2. `bun dev` (CLI/TUI)
3. Optional web UI: `bun run --cwd packages/app dev`
4. Optional desktop UI: `bun run --cwd packages/desktop tauri dev`

### Type Checking
- `bun run typecheck`

### Tests
- Root test is intentionally blocked.
- Run tests from package directories (for example `packages/opencode`, `packages/app`).
- Pentest/security-focused tests live under `packages/opencode/test/pentest/`.
- `packages/opencode/test/pentest/pentest-db-runtime.test.ts`: DB runtime flow, proposal lifecycle, readiness gates, artifacts, report build/finalize, migrations.
- `packages/opencode/test/pentest/pentest-agent-prompts.test.ts`: agent prompt/contract coverage for pentest roles.

### Branching
- Default branch is `dev`.
- Use `dev`/`origin/dev` as your diff base in this repo.

## Docker Lab (Optional)

`docker/` provides a full security lab:
- OpenHack dev container,
- optional vulnerable targets (Juice Shop, DVWA, bWAPP, BadStore, WebGoat),
- benchmarking/playground containers.

Start with: `docker/README.md`.
