.PHONY: dev dev-lan dev-local dev-live dev-thread dev-live-thread site-url site-url-stage site-url-prod issue-create

PORT ?= 7000
THREAD_BASE_PORT ?= 7001
BIND ?= 0.0.0.0
LOCAL_HOST ?= localhost
PORT_AUTO ?= 1
PORT_SCAN_LIMIT ?= 25
LIVE ?= 0
LIVE_FILES ?= index.html,work/**/*.html,assets/css/**/*.css,assets/js/**/*.js
PREVIEW_ENV ?= $(HOME)/.codex/bin/codex-preview-env
SITE_URL ?= https://nieder.me/2026
ISSUE_TITLE ?=
ISSUE_BODY_FILE ?=

.DEFAULT_GOAL := dev

site-url:
	@./scripts/set-site-url.sh "$(SITE_URL)"

site-url-stage: SITE_URL := https://nieder.me/2026
site-url-stage: site-url

site-url-prod: SITE_URL := https://nieder.me
site-url-prod: site-url

dev:
	@LIVE_MODE="$(LIVE)"; \
	if [ "$$LIVE_MODE" = "1" ]; then \
		if ! command -v npx >/dev/null 2>&1; then \
			echo "npx is required for live reload. Install Node.js first: https://nodejs.org/"; \
			exit 1; \
		fi; \
		if ! node -e "require('node:path')" >/dev/null 2>&1; then \
			echo "Your current Node runtime does not support 'node:path'."; \
			echo "Current version: $$(node -v 2>/dev/null || echo 'unknown')"; \
			echo "Use a newer Node (recommended: nvm use 20), then rerun with LIVE=1."; \
			exit 1; \
		fi; \
		if ! npx --version >/dev/null 2>&1; then \
			echo "npx is unavailable with the current Node/NPM setup."; \
			echo "Current Node version: $$(node -v 2>/dev/null || echo 'unknown')"; \
			echo "Use a newer Node (recommended: nvm use 20), then rerun with LIVE=1."; \
			exit 1; \
		fi; \
	fi; \
	if [ ! -x "$(PREVIEW_ENV)" ]; then \
		echo "Missing preview helper: $(PREVIEW_ENV)"; \
		echo "See /Users/niederme/.codex/docs/web-preview-convention.md"; \
		exit 1; \
	fi; \
	set -- --port "$(PORT)" --scan-limit "$(PORT_SCAN_LIMIT)" --local-host "$(LOCAL_HOST)"; \
	if [ "$(PORT_AUTO)" != "1" ]; then set -- "$$@" --no-port-auto; fi; \
	if ! PREVIEW_ENV_OUTPUT="$$($(PREVIEW_ENV) "$$@")"; then \
		if [ "$(PORT_AUTO)" = "1" ]; then \
			echo "Set PORT manually, for example: make dev PORT=8080"; \
		else \
			echo "Use a different port, for example: make dev PORT=8080"; \
			echo "Or enable auto port selection: make dev PORT_AUTO=1"; \
		fi; \
		exit 1; \
	fi; \
	eval "$$PREVIEW_ENV_OUTPUT"; \
	if [ "$$PORT_WAS_BUSY" = "1" ]; then echo "Port $(PORT) is already in use. Using $$PORT_TO_USE instead."; fi; \
	if [ "$$LIVE_MODE" = "1" ]; then \
		echo "Live reload on this Mac: $$LOCAL_URL"; \
		echo "Live reload on your network: $$LAN_URL"; \
		echo "(Ctrl+C to stop)"; \
		(sleep 0.8; open "$$LOCAL_URL/") >/dev/null 2>&1 & \
		npx browser-sync start --server . --files '$(LIVE_FILES)' --host $(BIND) --port $$PORT_TO_USE --no-open; \
	else \
		echo "Serving on this Mac: $$LOCAL_URL"; \
		echo "Serving on your network: $$LAN_URL"; \
		echo "(Ctrl+C to stop)"; \
		(sleep 0.8; open "$$LOCAL_URL/") >/dev/null 2>&1 & \
		python3 -m http.server $$PORT_TO_USE --bind $(BIND); \
	fi

dev-lan: dev

dev-thread: PORT := $(THREAD_BASE_PORT)
dev-thread: dev

dev-local:
	@LIVE_MODE="$(LIVE)"; \
	if [ "$$LIVE_MODE" = "1" ]; then \
		if ! command -v npx >/dev/null 2>&1; then \
			echo "npx is required for live reload. Install Node.js first: https://nodejs.org/"; \
			exit 1; \
		fi; \
		if ! node -e "require('node:path')" >/dev/null 2>&1; then \
			echo "Your current Node runtime does not support 'node:path'."; \
			echo "Current version: $$(node -v 2>/dev/null || echo 'unknown')"; \
			echo "Use a newer Node (recommended: nvm use 20), then rerun with LIVE=1."; \
			exit 1; \
		fi; \
		if ! npx --version >/dev/null 2>&1; then \
			echo "npx is unavailable with the current Node/NPM setup."; \
			echo "Current Node version: $$(node -v 2>/dev/null || echo 'unknown')"; \
			echo "Use a newer Node (recommended: nvm use 20), then rerun with LIVE=1."; \
			exit 1; \
		fi; \
	fi; \
	if [ ! -x "$(PREVIEW_ENV)" ]; then \
		echo "Missing preview helper: $(PREVIEW_ENV)"; \
		echo "See /Users/niederme/.codex/docs/web-preview-convention.md"; \
		exit 1; \
	fi; \
	set -- --port "$(PORT)" --scan-limit "$(PORT_SCAN_LIMIT)" --local-host "$(LOCAL_HOST)" --local-only; \
	if [ "$(PORT_AUTO)" != "1" ]; then set -- "$$@" --no-port-auto; fi; \
	if ! PREVIEW_ENV_OUTPUT="$$($(PREVIEW_ENV) "$$@")"; then \
		if [ "$(PORT_AUTO)" = "1" ]; then \
			echo "Set PORT manually, for example: make dev-local PORT=8080"; \
		else \
			echo "Use a different port, for example: make dev-local PORT=8080"; \
			echo "Or enable auto port selection: make dev-local PORT_AUTO=1"; \
		fi; \
		exit 1; \
	fi; \
	eval "$$PREVIEW_ENV_OUTPUT"; \
	if [ "$$PORT_WAS_BUSY" = "1" ]; then echo "Port $(PORT) is already in use. Using $$PORT_TO_USE instead."; fi; \
	if [ "$$LIVE_MODE" = "1" ]; then \
		echo "Live reload local-only: $$LOCAL_URL (Ctrl+C to stop)"; \
		(sleep 0.8; open "$$LOCAL_URL/") >/dev/null 2>&1 & \
		npx browser-sync start --server . --files '$(LIVE_FILES)' --host localhost --port $$PORT_TO_USE --no-open; \
	else \
		echo "Serving local-only: $$LOCAL_URL (Ctrl+C to stop)"; \
		(sleep 0.8; open "$$LOCAL_URL/") >/dev/null 2>&1 & \
		python3 -m http.server $$PORT_TO_USE --bind localhost; \
	fi

dev-live: LIVE := 1
dev-live: dev

dev-live-thread: PORT := $(THREAD_BASE_PORT)
dev-live-thread: LIVE := 1
dev-live-thread: dev

issue-create:
	@if [ -z "$(ISSUE_TITLE)" ]; then \
		echo "ISSUE_TITLE is required."; \
		echo "Example: make issue-create ISSUE_TITLE='Fix login bug' ISSUE_BODY_FILE=/tmp/issue.md"; \
		exit 1; \
	fi
	@if [ -n "$(ISSUE_BODY_FILE)" ]; then \
		./scripts/create-gh-issue.sh --title "$(ISSUE_TITLE)" --body-file "$(ISSUE_BODY_FILE)"; \
	else \
		./scripts/create-gh-issue.sh --title "$(ISSUE_TITLE)"; \
	fi
