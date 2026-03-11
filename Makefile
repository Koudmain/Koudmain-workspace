# Docker-compose executable
DC=docker compose

help:
	@echo "Koudmain - Docker Commands :"
	@echo ""
	@echo "General Commands:"
	@echo "  make up          - Start all services in the background"
	@echo "  make down        - Stop and remove all containers"
	@echo "  make build       - Build or rebuild all images"
	@echo "  make logs        - View output from all containers (real-time)"
	@echo ""
	@echo "Specific Commands:"
	@echo "  make backend     - Start only the backend (and the database)"
	@echo "  make web         - Start the web frontend + backend (and DB)"
	@echo "  make mobile      - Start the mobile apps + backend (and DB)"

all: help

# --- General Commands ---
up:
	$(DC) up -d

down:
	$(DC) down

build:
	$(DC) build

logs:
	$(DC) logs -f

# --- Specific Commands ---

# Start only the backend (DB will start automatically due to depends_on)
backend:
	$(DC) up -d backend

# Start the web frontend and the backend
web:
	$(DC) up -d frontend

# Start the mobile applications and the backend
mobile:
	$(DC) up -d mobile-worker mobile-client

.PHONY: help all up down build logs backend web mobile
