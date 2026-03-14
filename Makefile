.PHONY: dev dev-lan dev-local dev-live dev-thread dev-live-thread site-url site-url-stage site-url-prod issue-create

PORT ?= 7777
THREAD_BASE_PORT ?= 7778
BIND ?= 0.0.0.0
LOCAL_HOST ?= localhost
PORT_AUTO ?= 1
PORT_SCAN_LIMIT ?= 25
LIVE ?= 0
LIVE_FILES ?= index.html,work/**/*.html,assets/css/**/*.css,assets/js/**/*.js
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
	PORT_TO_USE="$(PORT)"; \
	if lsof -nP -iTCP:$$PORT_TO_USE -sTCP:LISTEN >/dev/null 2>&1; then \
		if [ "$(PORT_AUTO)" = "1" ]; then \
			BASE_PORT="$$PORT_TO_USE"; \
			MAX_PORT="$$((BASE_PORT + $(PORT_SCAN_LIMIT)))"; \
			while [ "$$PORT_TO_USE" -le "$$MAX_PORT" ] && lsof -nP -iTCP:$$PORT_TO_USE -sTCP:LISTEN >/dev/null 2>&1; do \
				PORT_TO_USE="$$((PORT_TO_USE + 1))"; \
			done; \
			if lsof -nP -iTCP:$$PORT_TO_USE -sTCP:LISTEN >/dev/null 2>&1; then \
				echo "No open port found between $(PORT) and $$MAX_PORT."; \
				echo "Set PORT manually, for example: make dev PORT=8080"; \
				exit 1; \
			fi; \
			echo "Port $(PORT) is already in use. Using $$PORT_TO_USE instead."; \
		else \
			echo "Port $(PORT) is already in use."; \
			echo "Use a different port, for example: make dev PORT=8080"; \
			echo "Or enable auto port selection: make dev PORT_AUTO=1"; \
			exit 1; \
		fi; \
	fi; \
	LOCAL_URL_HOST="$(LOCAL_HOST)"; \
	if [ "$$LOCAL_URL_HOST" = "localhost" ]; then \
		MAC_LOCAL_NAME="$$(scutil --get LocalHostName 2>/dev/null || true)"; \
		if [ -n "$$MAC_LOCAL_NAME" ]; then LOCAL_URL_HOST="$$MAC_LOCAL_NAME.local"; fi; \
		if [ "$$LOCAL_URL_HOST" = "localhost" ] || [ -z "$$LOCAL_URL_HOST" ]; then \
			MAC_HOST_NAME="$$(scutil --get HostName 2>/dev/null || true)"; \
			if [ -n "$$MAC_HOST_NAME" ]; then LOCAL_URL_HOST="$$MAC_HOST_NAME"; fi; \
		fi; \
		if [ "$$LOCAL_URL_HOST" = "localhost" ] || [ -z "$$LOCAL_URL_HOST" ]; then \
			SHELL_HOST_NAME="$$(hostname -s 2>/dev/null || hostname 2>/dev/null || true)"; \
			if [ -n "$$SHELL_HOST_NAME" ]; then LOCAL_URL_HOST="$$SHELL_HOST_NAME"; fi; \
		fi; \
		if [ "$$LOCAL_URL_HOST" = "localhost" ] || [ -z "$$LOCAL_URL_HOST" ]; then \
			MAC_COMPUTER_NAME="$$(scutil --get ComputerName 2>/dev/null || true)"; \
			if [ -n "$$MAC_COMPUTER_NAME" ]; then LOCAL_URL_HOST="$$(echo "$$MAC_COMPUTER_NAME" | tr ' ' '-')"; fi; \
		fi; \
		case "$$LOCAL_URL_HOST" in \
			""|localhost) LOCAL_URL_HOST="localhost" ;; \
			*.*) ;; \
			*) LOCAL_URL_HOST="$$LOCAL_URL_HOST.local" ;; \
		esac; \
	fi; \
	DEFAULT_IFACE="$$(route -n get default 2>/dev/null | awk '/interface:/{print $$2; exit}')"; \
	LAN_IP="$$( [ -n "$$DEFAULT_IFACE" ] && ipconfig getifaddr "$$DEFAULT_IFACE" 2>/dev/null || true )"; \
	if [ -z "$$LAN_IP" ]; then LAN_IP="$$(ifconfig | awk '/inet / && $$2 !~ /^127\./ {print $$2; exit}')"; fi; \
	if [ -z "$$LAN_IP" ]; then LAN_IP="$$LOCAL_URL_HOST"; fi; \
	if [ "$$LIVE_MODE" = "1" ]; then \
		echo "Live reload on this Mac: http://$$LOCAL_URL_HOST:$$PORT_TO_USE"; \
		echo "Live reload on your network: http://$$LAN_IP:$$PORT_TO_USE"; \
		echo "(Ctrl+C to stop)"; \
		(sleep 0.8; open "http://$$LOCAL_URL_HOST:$$PORT_TO_USE/") >/dev/null 2>&1 & \
		npx browser-sync start --server . --files '$(LIVE_FILES)' --host $(BIND) --port $$PORT_TO_USE --no-open; \
	else \
		echo "Serving on this Mac: http://$$LOCAL_URL_HOST:$$PORT_TO_USE"; \
		echo "Serving on your network: http://$$LAN_IP:$$PORT_TO_USE"; \
		echo "(Ctrl+C to stop)"; \
		(sleep 0.8; open "http://$$LOCAL_URL_HOST:$$PORT_TO_USE/") >/dev/null 2>&1 & \
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
	PORT_TO_USE="$(PORT)"; \
	if lsof -nP -iTCP:$$PORT_TO_USE -sTCP:LISTEN >/dev/null 2>&1; then \
		if [ "$(PORT_AUTO)" = "1" ]; then \
			BASE_PORT="$$PORT_TO_USE"; \
			MAX_PORT="$$((BASE_PORT + $(PORT_SCAN_LIMIT)))"; \
			while [ "$$PORT_TO_USE" -le "$$MAX_PORT" ] && lsof -nP -iTCP:$$PORT_TO_USE -sTCP:LISTEN >/dev/null 2>&1; do \
				PORT_TO_USE="$$((PORT_TO_USE + 1))"; \
			done; \
			if lsof -nP -iTCP:$$PORT_TO_USE -sTCP:LISTEN >/dev/null 2>&1; then \
				echo "No open local port found between $(PORT) and $$MAX_PORT."; \
				echo "Set PORT manually, for example: make dev-local PORT=8080"; \
				exit 1; \
			fi; \
			echo "Port $(PORT) is already in use. Using $$PORT_TO_USE instead."; \
		else \
			echo "Port $(PORT) is already in use."; \
			echo "Use a different port, for example: make dev-local PORT=8080"; \
			echo "Or enable auto port selection: make dev-local PORT_AUTO=1"; \
			exit 1; \
		fi; \
	fi; \
	LOCAL_URL_HOST="$(LOCAL_HOST)"; \
	if [ "$$LOCAL_URL_HOST" = "localhost" ]; then \
		MAC_LOCAL_NAME="$$(scutil --get LocalHostName 2>/dev/null || true)"; \
		if [ -n "$$MAC_LOCAL_NAME" ]; then LOCAL_URL_HOST="$$MAC_LOCAL_NAME.local"; fi; \
		if [ "$$LOCAL_URL_HOST" = "localhost" ] || [ -z "$$LOCAL_URL_HOST" ]; then \
			MAC_HOST_NAME="$$(scutil --get HostName 2>/dev/null || true)"; \
			if [ -n "$$MAC_HOST_NAME" ]; then LOCAL_URL_HOST="$$MAC_HOST_NAME"; fi; \
		fi; \
		if [ "$$LOCAL_URL_HOST" = "localhost" ] || [ -z "$$LOCAL_URL_HOST" ]; then \
			SHELL_HOST_NAME="$$(hostname -s 2>/dev/null || hostname 2>/dev/null || true)"; \
			if [ -n "$$SHELL_HOST_NAME" ]; then LOCAL_URL_HOST="$$SHELL_HOST_NAME"; fi; \
		fi; \
		if [ "$$LOCAL_URL_HOST" = "localhost" ] || [ -z "$$LOCAL_URL_HOST" ]; then \
			MAC_COMPUTER_NAME="$$(scutil --get ComputerName 2>/dev/null || true)"; \
			if [ -n "$$MAC_COMPUTER_NAME" ]; then LOCAL_URL_HOST="$$(echo "$$MAC_COMPUTER_NAME" | tr ' ' '-')"; fi; \
		fi; \
		case "$$LOCAL_URL_HOST" in \
			""|localhost) LOCAL_URL_HOST="localhost" ;; \
			*.*) ;; \
			*) LOCAL_URL_HOST="$$LOCAL_URL_HOST.local" ;; \
		esac; \
	fi; \
	if [ "$$LIVE_MODE" = "1" ]; then \
		echo "Live reload local-only: http://$$LOCAL_URL_HOST:$$PORT_TO_USE (Ctrl+C to stop)"; \
		(sleep 0.8; open "http://$$LOCAL_URL_HOST:$$PORT_TO_USE/") >/dev/null 2>&1 & \
		npx browser-sync start --server . --files '$(LIVE_FILES)' --host localhost --port $$PORT_TO_USE --no-open; \
	else \
		echo "Serving local-only: http://$$LOCAL_URL_HOST:$$PORT_TO_USE (Ctrl+C to stop)"; \
		(sleep 0.8; open "http://$$LOCAL_URL_HOST:$$PORT_TO_USE/") >/dev/null 2>&1 & \
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
