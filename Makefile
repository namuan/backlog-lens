.PHONY: help build up down restart logs test clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build all Docker containers
	docker-compose build

up: ## Start all services
	docker-compose up -d

up-logs: ## Start all services with logs
	docker-compose up

down: ## Stop all services
	docker-compose down

down-clean: ## Stop all services and remove volumes
	docker-compose down -v

restart: down up ## Restart all services

logs: ## Show logs from all services
	docker-compose logs -f

logs-api: ## Show API logs
	docker-compose logs -f api

logs-frontend: ## Show frontend logs
	docker-compose logs -f frontend

logs-db: ## Show database logs
	docker-compose logs -f postgres

test: ## Run basic tests
	./test.sh

db-shell: ## Open PostgreSQL shell
	docker exec -it $$(docker-compose ps -q postgres) psql -U jira -d jira_intel

api-shell: ## Open API container shell
	docker exec -it $$(docker-compose ps -q api) /bin/bash

clean: ## Clean up all containers, volumes, and images
	docker-compose down -v --rmi all

status: ## Show status of all services
	docker-compose ps

migrate: ## Run database migrations manually
	docker exec -i $$(docker-compose ps -q postgres) psql -U jira -d jira_intel < database/migrations/001_init_schema.sql

.DEFAULT_GOAL := help
