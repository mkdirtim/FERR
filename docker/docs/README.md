# opencodestack

Docker-based dev environment for this repo with Kali tools (nmap, nuclei, etc.) and optional vulnerable targets.

## Prerequisites

- Docker with Docker Compose v2 (`docker compose`)

## Quick Start

From repo root:

```bash
cd docker

# Dev container only (service: openhack)
make up

# Dev container + Juice Shop
docker compose --profile targets up -d openhack juiceshop

# Optional: include vulnerable targets
make up-with-targets

# Enter the container
make shell
```

## Common Commands

From `docker/`:

```bash
make help      # list all commands
make shell     # enter container
make install   # bun install (repo root)
make dev       # bun run dev (repo root)
make app       # bun run dev:web (packages/app, port 3000)
make web       # opencode web (port 4096)
make serve     # opencode serve (port 4096)
make status    # show service status
make down      # stop everything
```

## Compose Examples

All commands below assume you're in `/Users/mkdirtim/FERR/openhack/docker/` (where `compose.yaml` lives).

Dev container only (service: `openhack`):

```bash
docker compose up -d
```

Dev container + Juice Shop:

```bash
docker compose --profile targets up -d openhack juiceshop
```

Dev container + all targets:

```bash
docker compose --profile targets up -d
```

## Ports

- OpenCode server/web: `http://localhost:4096`
- Web app dev (Vite): `http://localhost:3000`

Targets (only when started with `make up-with-targets`):
- Juice Shop: `http://localhost:3333`
- DVWA: `http://localhost:3334`
- bWAPP: `http://localhost:3335`
- BadStore: `http://localhost:3336`
- WebGoat: `http://localhost:3337`
- WebWolf: `http://localhost:3338`

## Repo Mount + Useful Paths

The repo is mounted into the container at `/app`.

- `/app/package.json` (workspace root)
- `/app/packages/opencode/` (CLI + server)
- `/app/packages/app/` (Vite app)

Inside the container:

```bash
cd /app
bun install
bun run dev
bun run dev:web
bun --cwd packages/opencode test
```

## Optional: SecLists Wordlists

Host path: `docker/data/seclists` (shared read-only into container as `/usr/share/wordlists/seclists`).

```bash
./bin/seclists
```
