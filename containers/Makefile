# OpenHack Makefile

.PHONY: help quickstart quickstart-all validate build up up-with-targets up-all down restart restart-with-targets logs shell install dev app web serve test status targets scan docs playground playground-env benchmark-kali benchmark-pentestgpt benchmark-cai benchmark-strix xbow-list xbow-build xbow-run xbow-stop xbow-flag clean rebuild

help: ## Show this help message
	@echo "OpenHack — openhack + vulnerable targets + playground"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

quickstart: ## Clone all repos, build, and start (first-time setup)
	./setup/quickstart

quickstart-all: ## Quickstart then start everything (dev + targets + playground)
	./setup/quickstart
	$(MAKE) up-all

validate: ## Validate configuration and optionally run smoke tests
	./bin/docker-test

build: ## Build container images
	docker compose build

up: ## Start dev container only (service: openhack)
	docker compose up -d

up-with-targets: ## Start dev container with vulnerable targets
	docker compose --profile targets up -d

up-all: ## Start everything (dev + targets + playground)
	@if [ -f ./data/projects/playground.env ]; then \
		docker compose --env-file ./data/projects/playground.env --profile targets --profile playground up -d --build; \
	else \
		docker compose --profile targets --profile playground up -d --build; \
	fi

down: ## Stop all services (all profiles)
	docker compose --profile targets --profile playground down

restart: down up ## Restart dev container only

restart-with-targets: down up-with-targets ## Restart dev container and targets

logs: ## Tail logs from all services
	docker compose logs -f

shell: ## Open a bash shell in the openhack container
	docker compose exec openhack bash

install: ## Install workspace dependencies with bun
	docker compose exec openhack bun install

dev: ## Run the dev script (TUI/CLI)
	docker compose exec openhack bun run dev

app: ## Run web app dev server (packages/app, container port 3000)
	docker compose exec openhack bun run dev:web

web: ## Run opencode web server (port 4096)
	docker compose exec openhack bash -c "cd packages/opencode && bun run --conditions=browser ./src/index.ts web --hostname 0.0.0.0 --port 4096"

serve: ## Run the opencode HTTP server (port 4096)
	docker compose exec openhack bash -c "cd packages/opencode && bun run --conditions=browser ./src/index.ts serve --hostname 0.0.0.0 --port 4096"

test: ## Run package tests
	@echo "Run tests from a package, eg:"
	@echo "  docker compose exec openhack bun --cwd packages/opencode test"

status: ## Show status of all services
	docker compose --profile targets ps

targets: ## List vulnerable web applications and their ports
	@echo "Vulnerable Applications:"
	@echo "  - Juice Shop:  http://localhost:3333"
	@echo "  - DVWA:        http://localhost:3334"
	@echo "  - bWAPP:       http://localhost:3335"
	@echo "  - BadStore:    http://localhost:3336"
	@echo "  - WebGoat:     http://localhost:3337"
	@echo "  - WebWolf:     http://localhost:3338"

scan: ## Example: Run nmap scan on juiceshop
	docker compose exec openhack nmap -sV juiceshop

docs: ## Print documentation locations
	@echo "Docs:"
	@echo "  - ./README.md"

playground: ## Start playground container (Kali-based, profile: playground)
	@if [ -f ./data/projects/playground.env ]; then \
		docker compose --env-file ./data/projects/playground.env --profile playground up -d playground; \
	else \
		docker compose --profile playground up -d playground; \
	fi

playground-env: ## Create ./data/projects/playground.env (gitignored) from example
	@test -f ./data/projects/playground.env || cp ./data/projects/playground.env.example ./data/projects/playground.env
	@echo "Edit: ./data/projects/playground.env"

benchmark-kali: ## Scan targets from playground-kali (nmap, whatweb, nikto, ZAP, ffuf, sqlmap)
	docker compose --profile playground exec playground benchmark-kali

benchmark-pentestgpt: ## Run PentestGPT benchmark (RUNS=5)
	./bin/benchmark-pentestgpt $(RUNS)

benchmark-cai: ## Run CAI benchmark (RUNS=5)
	./bin/benchmark-cai $(RUNS)

benchmark-strix: ## Run Strix benchmark (RUNS=5)
	./bin/benchmark-strix $(RUNS)

xbow-list: ## List available XBOW benchmarks
	./bin/benchmark-xbow list

xbow-build: ## Build an XBOW benchmark (BENCH=XBEN-001-24)
	@test -n "$(BENCH)" || (echo "Usage: make xbow-build BENCH=XBEN-001-24" && exit 1)
	./bin/benchmark-xbow build $(BENCH)

xbow-run: ## Run an XBOW benchmark (BENCH=XBEN-001-24)
	@test -n "$(BENCH)" || (echo "Usage: make xbow-run BENCH=XBEN-001-24" && exit 1)
	./bin/benchmark-xbow run $(BENCH)

xbow-stop: ## Stop an XBOW benchmark (BENCH=XBEN-001-24)
	@test -n "$(BENCH)" || (echo "Usage: make xbow-stop BENCH=XBEN-001-24" && exit 1)
	./bin/benchmark-xbow stop $(BENCH)

xbow-flag: ## Show flag for an XBOW benchmark (BENCH=XBEN-001-24)
	@test -n "$(BENCH)" || (echo "Usage: make xbow-flag BENCH=XBEN-001-24" && exit 1)
	./bin/benchmark-xbow flag $(BENCH)

clean: ## Stop services and remove volumes
	docker compose --profile targets --profile playground down -v

rebuild: ## Rebuild container images from scratch (no cache)
	docker compose build --no-cache

.DEFAULT_GOAL := help
