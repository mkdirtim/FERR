# Cleanup TODOs

Last updated after v1.2.5 upgrade (merge 711e18650, 2026-02-13).

## Current prune commit

- SHA: `b9cb07e82`
- Message: `fork: prune upstream-only directories (v1.1.64)`
- Note: on v1.2.5 upgrade this only deleted 2 files (`patches/`)

## Current fork-fix commit

- SHA: `49b6f7685`
- Message: `fork: fix workspace and patch consistency`

## Deleted — Whole Directories (DONE)

716 files deleted, 116,053 lines removed on `feature-cleanup` branch. Only whole-directory deletions to avoid cherry-pick conflicts during upstream upgrades.

| # | Directory | Files | Lines | What |
|---|-----------|------:|------:|------|
| 1 | `README*.md` (root) | 18 | 2,430 | All 18 translated + main README |
| 2 | `.github/` | 35 | 2,335 | CI workflows, issue templates, PR template |
| 3 | `.opencode/agent/` | 3 | 138 | Upstream triage/docs/duplicate-pr agents |
| 4 | `.opencode/tool/` | 4 | 245 | Upstream GitHub triage/PR-search tools |
| 5 | `.vscode/` | 2 | 16 | Example VS Code settings |
| 6 | `github/` | 10 | 1,596 | GitHub Action for `anomalyco/opencode` |
| 7 | `infra/` | 5 | 317 | SST/Cloudflare deployment infrastructure |
| 8 | `nix/` | 6 | 538 | Nix build scripts and flakes |
| 9 | `packages/console/` | 408 | 78,272 | SaaS console, billing, landing page |
| 10 | `packages/containers/` | 8 | 200 | CI container Dockerfiles |
| 11 | `packages/docs/` | 24 | 1,732 | Documentation site (Fumadocs) |
| 12 | `packages/enterprise/` | 36 | 1,881 | Enterprise/Zen features |
| 13 | `packages/extensions/` | 3 | 40 | Zed editor extension |
| 14 | `packages/function/` | 4 | 625 | Serverless API functions |
| 15 | `packages/identity/` | 6 | 12 | Brand identity assets |
| 16 | `packages/slack/` | 7 | 215 | Slack integration |
| 17 | `packages/web/` | 101 | 21,679 | Marketing website (Astro/Starlight) |
| 18 | `patches/` | 1 | 40 | Third-party patches |
| 19 | `script/` | 8 | 996 | Upstream CI/release scripts (3 utility scripts remain: `format.ts`, `generate.ts`, `hooks`) |
| 20 | `sdks/` | 16 | 1,068 | VS Code extension SDK |
| 21 | `specs/` | 10 | 1,678 | Internal design specs |
| | **Total** | **715** | **116,053** | |

## Kept — Standalone Files (to avoid cherry-pick conflicts)

These files were initially deleted but restored to keep the prune commit as whole-directory-only deletions. They remain tracked to avoid per-file cherry-pick conflicts during upgrades.

| File | Why kept |
|------|----------|
| `CONTRIBUTING.md` | Root-level, changes with upstream |
| `SECURITY.md` | Root-level, changes with upstream |
| `STATS.md` | Root-level, changes with upstream |
| `README.md` | Root-level, changes with upstream |
| `flake.lock`, `flake.nix` | Nix build (root-level) |
| `install` | Upstream installer (root-level) |
| `sst-env.d.ts`, `sst.config.ts` | SST config (root-level) |
| `themes/deltarune.json`, `themes/undertale.json` | Novelty themes |
| `logs/` (2 files) | Stale logs |
| `script/format.ts` | Runs prettier — useful for dev |
| `script/generate.ts` | Regenerates SDK from OpenAPI — useful for dev |
| `script/hooks` | Installs pre-push typecheck hook — actively used |
| `packages/*/sst-env.d.ts` | SST auto-generated types per package |
| `packages/*/script/publish.ts` | Upstream publish scripts per package |
| `packages/opencode/Dockerfile` | Upstream production image |
| `packages/desktop/src-tauri/icons/{dev,prod}/{android,ios}/` | Mobile icons |
| `packages/desktop/src-tauri/release/appstream.metainfo.xml` | Upstream release metadata |
| `packages/app/src/i18n/*.ts` (15 files) | Non-English translations — imported by `language.tsx` |
| `packages/desktop/src/i18n/*.ts` (14 files) | Non-English translations — imported by `i18n/index.ts` |
| `packages/ui/src/i18n/*.ts` (15 files) | Non-English translations — imported by UI components |
| `.opencode/command/issues.md` | Hardcoded to `anomalyco/opencode` |

## Files to Delete (Round 2)

### Fonts — Bloat Reduction (~29.4 MB)

| # | Item | Size | Why |
|---|------|------|-----|
| 1 | `packages/ui/src/assets/fonts/*NerdFontMono*.woff2` (26 files) | 27 MB | Never imported by any code. **INVESTIGATE FIRST**: lowercase equivalents are 0 bytes — may need renaming instead of deleting |
| 2 | `packages/ui/src/assets/fonts/*.otf` (7 files) | 1.8 MB | Never imported — only `.woff2` used |
| 3 | `packages/ui/src/assets/fonts/*.ttf` (4 files) | 0.6 MB | Never imported — only `.woff2` used |

### Test Fixtures (~3.9 MB)

| # | Item | Size | Why |
|---|------|------|-----|
| 4 | `packages/opencode/test/tool/fixtures/large-image.png` | 2.6 MB | Large test fixture — could use smaller image |
| 5 | `packages/opencode/test/tool/fixtures/models-api.json` | 1.3 MB | Upstream model API snapshot |

### Other

| # | Item | Size | Why |
|---|------|------|-----|
| 6 | `packages/desktop/src-tauri/assets/nsis-sidebar.bmp` | 151 KB | Only needed for Windows NSIS installers |
| 7 | `packages/desktop/src-tauri/assets/nsis-header.bmp` | 25 KB | Only needed for Windows NSIS installers |

### Local Disk Only (gitignored, but ~5.6 GB)

| # | Item | Size | Why |
|---|------|------|-----|
| 8 | `docker/data/seclists/` | 1.8 GB | SecLists wordlists — re-downloadable via setup script |
| 9 | `docker/data/benchmarks/` | 1.4 GB | XBOW benchmarks — re-downloadable |
| 10 | `docker/data/projects/` | 2.3 GB | Third-party project clones — re-downloadable |

## Files to Update

### Root `package.json`

| # | What to change |
|---|----------------|
| 1 | Remove workspaces: `"packages/console/*"`, `"packages/slack"` |
| 2 | Remove scripts: `"random"`, `"hello"` |
| 3 | Remove devDependencies: `semver`, `sst`, `@actions/artifact` |
| 4 | Remove dependencies: `@aws-sdk/client-s3` |
| 5 | Remove catalog: `@cloudflare/workers-types`, `@solidjs/start`, `@types/semver` |
| 6 | Update `repository.url` to your repo |

### `packages/opencode/package.json`

| # | What to change |
|---|----------------|
| 7 | Remove fake scripts: `"random"`, `"clean"`, `"lint"`, `"format"`, `"docs"`, `"deploy"` |
| 8 | Remove junk field: `"randomField": "this-is-a-random-value-12345"` |
| 9 | Remove unused devDependency: `why-is-node-running` |

### `.opencode/command/commit.md`

| # | What to change |
|---|----------------|
| 10 | Remove line 17 referencing deleted `packages/web` |

## Upstream References to Review

These are hardcoded upstream URLs/branding in source code. Changing some may break functionality (e.g., share API, config schema). Review when ready to rebrand.

| # | File | What | Status |
|---|------|------|--------|
| 1 | ~~`packages/opencode/src/share/share.ts`~~ | ~~Hardcoded `api.opencode.ai`~~ | **Resolved in v1.2.5**: replaced by `share-next.ts` which uses config-driven URL (`opncd.ai` default). Still disabled via `OPENCODE_DISABLE_SHARE`. |
| 2 | `packages/opencode/src/server/server.ts:544` | Proxies to `app.opencode.ai` | Still present |
| 3 | `packages/opencode/src/config/config.ts:91` | `$schema` URL pointing to `opencode.ai/config.json` | Still present |
| 4 | `packages/opencode/src/provider/provider.ts:339,419` | HTTP-Referer headers with `opencode.ai` | Still present |
| 5 | `packages/opencode/src/cli/cmd/github.ts:1299` | `social-cards.sst.dev` for share card images | Still present |
| 6 | `packages/opencode/src/session/prompt/anthropic-20250930.txt:143` | Hardcoded upstream dev path `/home/thdxr/dev/projects/anomalyco/opencode` | Still present |
| 7 | `packages/desktop/src-tauri/tauri.prod.conf.json:35` | Updater endpoint pointing to `anomalyco` | Still present |
| 8 | `packages/desktop/src-tauri/Cargo.toml:5` | `authors = ["Anomaly Innovations"]` | Still present |
| 9 | `packages/app/AGENTS.md:7` | References `opencode dev web` which proxies `app.opencode.ai` | Still present |
| 10 | `.opencode/opencode.jsonc:2,4` | `$schema` and commented-out `enterprise.dev.opencode.ai` URL | Still present |
| 11 | `packages/opencode/src/session/prompt/anthropic.txt:10` | GitHub URL `anomalyco/opencode` | Still present |
| 12 | `packages/opencode/src/session/prompt/qwen.txt:9` | GitHub URL `anomalyco/opencode` | Still present |
| 13 | `.opencode/command/issues.md:6` | Hardcoded `anomalyco/opencode` for gh CLI | Still present |

## Investigate

| # | Item | Why |
|---|------|-----|
| 1 | Font loading in UI | Lowercase nerd font `.woff2` files are **0 bytes**. Check if fonts render. May need CamelCase files renamed to lowercase instead of deleted. v1.2.5 added GeistMono Nerd Font — verify it loads correctly. |
| 2 | `packages/opencode/src/share/` | Refactored in v1.2.5: `share.ts` replaced by `share-next.ts` + `share.sql.ts`. Now config-driven (`opncd.ai` default) instead of hardcoded. Still disabled via `OPENCODE_DISABLE_SHARE`. Consider removing entirely. |
| 3 | `packages/opencode/src/ide/` `install()` function | Installs upstream `sst-dev.opencode` VS Code extension. `Ide.install()` not called anywhere. Dead code. |

## v1.2.5 Upgrade Notes

Notable upstream changes between v1.1.64 and v1.2.5 (72 commits, 154 files changed in kept packages):

- Share module refactored: `share.ts` → `share-next.ts` + `share.sql.ts` with SQLite storage and config-driven URL
- New `db` command for database inspection and querying
- SQLite migration: IDs now derived from file paths
- GeistMono Nerd Font added to available mono font options
- Localized "free usage exceeded" error and clickable "Add credits" link
- Various app fixes (file tree, prompt history, keybindings, focus after update)

## Post-cleanup

- Run `bun install` to regenerate `bun.lock` after package.json changes
- Delete this file once all items are completed
