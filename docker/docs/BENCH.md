# Bench Containers

This repo supports optional "bench" containers for running third-party open-source hacking agents locally while sharing the same Docker network as the vulnerable targets (Juice Shop, DVWA, etc.).

Bench projects live under `docker/bench/projects/` and are intentionally local-only (ignored by git).

## Services And Profiles

- Ubuntu bench:
  - profile: `bench-ubuntu`
  - service: `benchubuntu`
  - container: `openhack-bench-ubuntu`
- Kali bench:
  - profile: `bench-kali`
  - service: `benchkali`
  - container: `openhack-bench-kali`

Both are attached to `opencodestack-network`, so they can reach targets by service name (example: `http://juiceshop:3000`).

## Start

All commands assume you're in `/Users/mkdirtim/FERR/openhack/docker/`.

Ubuntu bench only:

```bash
docker compose --profile bench-ubuntu up -d benchubuntu
docker compose exec benchubuntu bash
```

Kali bench only:

```bash
docker compose --profile bench-kali up -d benchkali
docker compose exec benchkali bash
```

Bench plus a target (example: Juice Shop):

```bash
docker compose --profile bench-ubuntu --profile targets up -d benchubuntu juiceshop
```

## Project Layout

Projects should end up at:

- `/Users/mkdirtim/FERR/openhack/docker/bench/projects/PentestGPT`
- `/Users/mkdirtim/FERR/openhack/docker/bench/projects/cai`
- `/Users/mkdirtim/FERR/openhack/docker/bench/projects/strix`

Inside the bench container, they appear at `/playground/projects/...`.

## Notes

- If a project needs heavier tooling (metasploit/sqlmap/hydra), use the Kali bench container.
- If a project needs a stable Python 3.12+ toolchain (uv/poetry), start with the Ubuntu bench container.
