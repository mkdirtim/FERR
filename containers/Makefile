# OpenHack Makefile

.PHONY: help build up down restart logs shell install dev serve status targets clean rebuild

help: ## Show this help message
	@echo "OpenHack — openhack + juiceshop + badstore"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

build: ## Build the openhack container image
	docker compose build

up: ## Start all services (openhack + juiceshop + badstore)
	docker compose up -d

down: ## Stop all services
	docker compose down

restart: down up ## Restart all services

logs: ## Tail logs from all services
	docker compose logs -f

shell: ## Open a bash shell in the openhack container
	docker compose exec openhack bash

install: ## Install workspace dependencies with bun
	docker compose exec openhack bun install

dev: ## Run the dev script (TUI/CLI)
	docker compose exec openhack bun run dev

serve: ## Run the opencode HTTP server (port 4096)
	docker compose exec openhack bun --cwd packages/opencode run dev -- serve --hostname 0.0.0.0 --port 4096

status: ## Show status of all services
	docker compose ps

targets: ## List vulnerable web applications and their ports
	@echo "Targets:"
	@echo "  Juice Shop  http://localhost:3333"
	@echo "  BadStore    http://localhost:3336"

clean: ## Stop services and remove volumes
	docker compose down -v

rebuild: ## Rebuild container image from scratch (no cache)
	docker compose build --no-cache

.DEFAULT_GOAL := help
