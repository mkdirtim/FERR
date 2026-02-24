# ferr — container environment

Kali-based dev container for AI-assisted penetration testing, plus optional vulnerable targets and a playground container for running third-party agents.

## Quick start

```bash
make quickstart       # clone benchmark repos, build, and start
make up               # start dev container only (after first build)
make shell            # open a shell in the openhack container
```

## Build time

The first `docker compose build` is slow — expect **~60 minutes** on a cold cache:

| Layer | Time |
|---|---|
| apt packages (kali-linux-headless, pandoc, texlive, …) | ~23 min |
| SecLists wordlists (~450 MB download) | ~26 min |
| Go tools (httpx, katana, interactsh, gospider) | ~6 min |
| bun, trufflehog, nuclei templates | ~3 min |
| Everything else | ~2 min |

Subsequent builds are near-instant — all layers are cached unless the Dockerfile changes. Only the `nuclei -update-templates` layer re-runs if nuclei is updated (~1 min).

## Services

| Profile | Command | Description |
|---|---|---|
| *(default)* | `make up` | openhack dev container only |
| `targets` | `make up-with-targets` | + 5 vulnerable web apps |
| `playground` | `make playground` | + Kali playground + GVM/OpenVAS |
| all | `make up-all` | everything |

## Vulnerable targets

Started with `make up-with-targets`:

| App | URL |
|---|---|
| Juice Shop | http://localhost:3333 |
| DVWA | http://localhost:3334 |
| bWAPP | http://localhost:3335 |
| BadStore | http://localhost:3336 |
| WebGoat | http://localhost:3337 |
| WebWolf | http://localhost:3338 |

## Common commands

```bash
make build             # build container images
make up                # start dev container
make up-with-targets   # start dev + vulnerable targets
make down              # stop everything
make logs              # tail logs
make validate          # run smoke tests
make rebuild           # rebuild from scratch (no cache)
make status            # show running services
```

## Benchmarks

```bash
make xbow-list                        # list available CTF benchmarks
make xbow-build BENCH=XBEN-001-24     # build a benchmark
make xbow-run   BENCH=XBEN-001-24     # run a benchmark
make xbow-flag  BENCH=XBEN-001-24     # show the flag
```
