# Wedding Game Development Makefile
# Provides convenient commands for development workflow

.PHONY: help setup install clean test dev mobile docs lint format backup prime-claude

# Default target
.DEFAULT_GOAL := help

# Colors for output
YELLOW := \033[1;33m
GREEN := \033[0;32m
BLUE := \033[0;34m
NC := \033[0m

help: ## Show this help message
	@echo "$(YELLOW)Wedding Game Development Commands$(NC)"
	@echo "=================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BLUE)Examples:$(NC)"
	@echo "  make setup     # Complete development environment setup"
	@echo "  make dev       # Start development session"
	@echo "  make test      # Run all tests"
	@echo "  make mobile    # Start mobile development"

setup: ## Complete development environment setup
	@echo "$(YELLOW)Setting up wedding game development environment...$(NC)"
	./setup.sh

install: ## Install dependencies only
	@echo "$(YELLOW)Installing dependencies...$(NC)"
	npm install
	python3 -m pip install -r requirements.txt

clean: ## Clean temporary files and caches
	@echo "$(YELLOW)Cleaning project...$(NC)"
	rm -rf node_modules/.cache .cache __pycache__ *.pyc
	rm -rf .pytest_cache .coverage htmlcov/
	rm -rf logs/*.log temp/* backups/*.tar.gz

test: ## Run all tests
	@echo "$(YELLOW)Running tests...$(NC)"
	python3 scripts/aggregate_tools.py --test
	./scripts/dev-session-manager.sh status

test-mcp: ## Test MCP configuration
	@echo "$(YELLOW)Testing MCP configuration...$(NC)"
	python3 scripts/aggregate_tools.py --test

dev: ## Start development session
	@echo "$(YELLOW)Starting development session...$(NC)"
	./scripts/dev-session-manager.sh start

dev-end: ## End development session
	@echo "$(YELLOW)Ending development session...$(NC)"
	./scripts/dev-session-manager.sh end

dev-status: ## Check development session status
	@echo "$(YELLOW)Checking development session status...$(NC)"
	./scripts/dev-session-manager.sh status

mobile: ## Start mobile development
	@echo "$(YELLOW)Starting mobile development...$(NC)"
	./scripts/mobile-dev-session.sh start

mobile-setup: ## Setup mobile development environment
	@echo "$(YELLOW)Setting up mobile development...$(NC)"
	./scripts/mobile-dev-session.sh setup

mobile-sync-push: ## Push mobile work to desktop
	@echo "$(YELLOW)Pushing mobile work...$(NC)"
	./scripts/sync-mobile-work.sh push

mobile-sync-pull: ## Pull work to mobile
	@echo "$(YELLOW)Pulling work to mobile...$(NC)"
	./scripts/sync-mobile-work.sh pull

docs: ## Serve documentation locally
	@echo "$(YELLOW)Starting documentation server...$(NC)"
	@echo "Open http://localhost:8000 in your browser"
	cd docs && python3 -m http.server 8000

lint: ## Run code linting
	@echo "$(YELLOW)Running linting...$(NC)"
	python3 -m flake8 scripts/ || true
	echo "Linting complete"

format: ## Format code
	@echo "$(YELLOW)Formatting code...$(NC)"
	python3 -m black scripts/ || true
	echo "Formatting complete"

backup: ## Create project backup
	@echo "$(YELLOW)Creating project backup...$(NC)"
	tar -czf backup-$(shell date +%Y%m%d-%H%M%S).tar.gz \
		--exclude='.git' \
		--exclude='node_modules' \
		--exclude='.cache' \
		--exclude='__pycache__' \
		--exclude='*.pyc' \
		--exclude='logs/*.log' \
		--exclude='temp/*' \
		.
	@echo "$(GREEN)Backup created successfully$(NC)"

git-status: ## Show git status with branch info
	@echo "$(YELLOW)Git Status:$(NC)"
	git status --porcelain
	@echo ""
	@echo "$(YELLOW)Current branch:$(NC) $(shell git branch --show-current)"
	@echo "$(YELLOW)Last commit:$(NC) $(shell git log -1 --format='%cr')"

env-check: ## Check environment configuration
	@echo "$(YELLOW)Environment Check:$(NC)"
	@echo "Node.js: $(shell node --version 2>/dev/null || echo 'Not installed')"
	@echo "Python: $(shell python3 --version 2>/dev/null || echo 'Not installed')"
	@echo "Git: $(shell git --version 2>/dev/null || echo 'Not installed')"
	@echo "npm: $(shell npm --version 2>/dev/null || echo 'Not installed')"
	@echo ""
	@if [ -f .env ]; then \
		echo "$(GREEN).env file exists$(NC)"; \
	else \
		echo "$(YELLOW).env file missing - copy from example.env.txt$(NC)"; \
	fi

install-mcp: ## Install MCP servers
	@echo "$(YELLOW)Installing MCP servers...$(NC)"
	./setup-mcp.sh

quick-start: ## Quick start development (setup + dev)
	@echo "$(YELLOW)Quick starting wedding game development...$(NC)"
	make setup
	make dev

# Advanced targets
debug-mcp: ## Debug MCP configuration issues
	@echo "$(YELLOW)Debugging MCP configuration...$(NC)"
	@echo "Cursor MCP config:"
	@if [ -f /home/joe/.cursor/mcp.json ]; then \
		cat /home/joe/.cursor/mcp.json; \
	else \
		echo "Cursor MCP config not found"; \
	fi
	@echo ""
	@echo "Project MCP configs:"
	@ls -la mcp-config*.json 2>/dev/null || echo "No MCP config files found"
	@echo ""
	@echo "Aggregator test:"
	@python3 scripts/aggregate_tools.py --test || echo "Aggregator test failed"

system-info: ## Show system information
	@echo "$(YELLOW)System Information:$(NC)"
	@echo "OS: $(shell uname -s)"
	@echo "Architecture: $(shell uname -m)"
	@echo "Kernel: $(shell uname -r)"
	@echo "Shell: $(SHELL)"
	@echo "Working directory: $(PWD)"
	@echo "User: $(USER)"
	@echo "Home: $(HOME)"

# Update targets
update-deps: ## Update all dependencies
	@echo "$(YELLOW)Updating dependencies...$(NC)"
	npm update
	python3 -m pip install --upgrade -r requirements.txt

update-mcp: ## Update MCP servers
	@echo "$(YELLOW)Updating MCP servers...$(NC)"
	npx -y @modelcontextprotocol/server-filesystem@latest --help > /dev/null 2>&1
	npx -y @modelcontextprotocol/server-github@latest --help > /dev/null 2>&1
	npx -y @modelcontextprotocol/server-puppeteer@latest --help > /dev/null 2>&1
	npx -y @modelcontextprotocol/server-memory@latest --help > /dev/null 2>&1

prime-claude: ## Prime Claude with project context and collaboration approach
	@echo "$(YELLOW)Priming Claude with project context...$(NC)"
	./scripts/prime-claude.sh

session-start: ## Start development session with full setup validation
	@echo "$(YELLOW)Starting development session...$(NC)"
	./scripts/session-start-hook.sh

validate-setup: ## Validate complete session setup
	@echo "$(YELLOW)Validating session setup...$(NC)"
	./scripts/validate-session-setup.sh

remind-claude: ## Remind Claude of collaboration approach
	@echo "$(YELLOW)Reminding Claude of collaboration protocol...$(NC)"
	./scripts/claude-reminder-hook.sh