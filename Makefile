SHELL := /bin/bash

# Docker-compose executable
DC=docker compose

# Environment file
ENV_FILE=.env

# Get local IP for Expo
LOCAL_IP := $(shell ip route get 1.1.1.1 | sed -n 's/.*src \([0-9.]*\).*/\1/p')

# Export for docker-compose to use in build args
export REACT_NATIVE_PACKAGER_HOSTNAME := $(LOCAL_IP)

export LOCAL_IP := $(LOCAL_IP)

# Colors for Terminal
BLUE   := $(shell tput -Txterm setaf 4)
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

help:
	@echo "${BLUE}Koudmain - Docker Development Environment${RESET}"
	@echo "-------------------------------------------------------"
	@echo "${YELLOW}Usage:${RESET} make <command>"
	@echo ""
	@echo "${BLUE}General Commands:${RESET}"
	@echo "  ${GREEN}up${RESET}                Start all services in background"
	@echo "  ${GREEN}down${RESET}              Stop and remove all containers"
	@echo "  ${GREEN}build${RESET}             Build or rebuild all images"
	@echo "  ${GREEN}logs${RESET}              View real-time output from all containers"
	@echo ""
	@echo "${BLUE}Specific Services:${RESET}"
	@echo "  ${GREEN}backend${RESET}           Start backend and database"
	@echo "  ${GREEN}web${RESET}               Start web frontend + backend"
	@echo "  ${GREEN}mobile${RESET}            Start mobile apps (worker & client) + backend"
	@echo "  ${GREEN}db_test${RESET}           Start the test database only"
	@echo "  ${GREEN}db-reset${RESET}    Wipe and recreate the database (Confirmation required)"
	@echo "  ${GREEN}documenso${RESET}         Start Documenso platform"
	@echo ""
	@echo "${BLUE}Management & Git:${RESET}"
	@echo "  ${GREEN}pull-all${RESET}          Update all repositories (git pull)"
	@echo "  ${GREEN}main-all${RESET}          Switch all repositories to 'main' branch"
	@echo "  ${GREEN}configure-pre-commit${RESET}  Install pre-commit hooks everywhere"
	@echo ""
	@echo "${BLUE}Logs (Specific):${RESET}"
	@echo "  ${YELLOW}logs-backend, logs-web, logs-mobile, logs-db, logs-redis...${RESET}"
	@echo "-------------------------------------------------------"

all: help

# --- General Commands ---
up:
	$(DC) up -d

down:
	$(DC) down

build:
	$(DC) build

# --- Logs ---

logs:
	$(DC) logs -f

logs-employer:
	$(DC) logs -f mobile-employer

logs-worker:
	$(DC) logs -f mobile-worker

logs-backend:
	$(DC) logs -f backend

logs-worker-go:
	$(DC) logs -f worker

logs-web:
	$(DC) logs -f frontend

logs-db:
	$(DC) logs -f db

logs-redis:
	$(DC) logs -f redis

logs-test-db:
	$(DC) logs -f db_test

logs-documenso:
	$(DC) logs -f documenso

# --- Specific Commands ---

# Start only the backend (DB will start automatically due to depends_on)
backend:
	$(DC) up -d backend

# Start the web frontend and the backend
web:
	$(DC) up -d frontend

# Start the mobile applications and the backend
mobile:
	$(DC) up -d mobile-employer mobile-worker

db_test:
	$(DC) up -d db_test

# Start the Documenso platform
documenso:
	$(DC) up -d documenso

build-documenso:
	$(DC) build documenso

# --- Management commands ---

pull-all:
	@echo "Reading .env and updating repositories..."
	@while IFS='=' read -r key value; do \
		if [[ "$$key" == *PATH_FOLDER ]] && [[ "$$key" != WORKDIR* ]]; then \
			clean_path=$$(echo "$$value" | tr -d "'" | tr -d '"' | tr -d '\r'); \
			git -C "$$clean_path" pull; \
		fi \
	done < $(ENV_FILE)

main-all:
	@echo "Reading .env and switching repositories to main branch..."
	@while IFS='=' read -r key value; do \
		if [[ "$$key" == *PATH_FOLDER ]] && [[ "$$key" != WORKDIR* ]]; then \
			clean_path=$$(echo "$$value" | tr -d "'" | tr -d '"' | tr -d '\r'); \
			echo "-> Checking out main in $$clean_path"; \
			git -C "$$clean_path" checkout main || exit 1; \
		fi \
	done < $(ENV_FILE)

configure-pre-commit:
	@echo "Reading .env and configuring pre-commit in all repositories..."
	@while IFS='=' read -r key value; do \
		if [[ "$$key" == *PATH_FOLDER ]] && [[ "$$key" != WORKDIR* ]]; then \
			clean_path=$$(echo "$$value" | tr -d "'" | tr -d '"' | tr -d '\r'); \
			cd $$clean_path; \
			pre-commit install; \
			echo "Installed in $$clean_path"; \
		fi \
	done < $(ENV_FILE)

# --- Database Management ---

db-reset:
	@echo "${YELLOW}WARNING: This will DELETE the entire database and recreate the schema.${RESET}"
	@read -p "Are you sure you want to proceed? [y/N] " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		$(DC) exec backend sh -c "npx sequelize-cli db:drop && npx sequelize-cli db:create && npx sequelize-cli db:migrate"; \
		echo "${GREEN}Database has been reset successfully (empty schema).${RESET}"; \
	else \
		echo "${BLUE}Operation cancelled.${RESET}"; \
	fi

.PHONY: help all up down build logs backend web mobile db_test logs-db logs-redis pull-all main-all db-reset
