# openhackstack Makefile
# Quick commands for managing the Docker environment

.PHONY: help start validate build up up-with-targets down restart logs shell dev app web serve install test clean status rebuild targets scan docs playground

help: ## Show this help message
	@echo "openhackstack - OpenCode Development Environment"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'
	@echo ""
	@echo "Docs: ./README.md"

start: ## Run startup script (builds and starts services)
	./bin/up

validate: ## Validate configuration and optionally run smoke tests
	./bin/test

build: ## Build container image
	docker compose build

up: ## Start dev container only (service: openhack)
	docker compose up -d

up-with-targets: ## Start dev container with vulnerable targets
	docker compose --profile targets up -d

down: ## Stop all services
	docker compose --profile targets down

restart: down up ## Restart dev container only

restart-with-targets: down up-with-targets ## Restart all services including targets

logs: ## View logs from all services
	docker compose logs -f

shell: ## Open bash shell in dev container (service: openhack)
	docker compose exec openhack bash

install: ## Install workspace dependencies with bun (from repo root)
	docker compose exec openhack bun install

dev: ## Run root dev script (typically TUI/CLI)
	docker compose exec openhack bun run dev

app: ## Run web app dev server (packages/app, container port 3000; host port may be ephemeral)
	docker compose exec openhack bun run dev:web

serve: ## Run opencode HTTP server (port 4096)
	docker compose exec openhack bun --cwd packages/opencode run dev -- serve --hostname 0.0.0.0 --port 4096

web: ## Run opencode web server (port 4096)
	docker compose exec openhack bun --cwd packages/opencode run dev -- web --hostname 0.0.0.0 --port 4096

test: ## Run package tests (root script is intentionally blocked; run package tests instead)
	@echo "Run tests from a package, eg:"
	@echo "  docker compose exec openhack bun --cwd packages/opencode test"

clean: ## Stop services and remove volumes
	docker compose --profile targets down -v

status: ## Show status of all services
	docker compose --profile targets ps

rebuild: ## Rebuild containers from scratch
	docker compose build --no-cache

targets: ## List vulnerable web applications
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
	docker compose --profile playground up -d playground

.DEFAULT_GOAL := help
