.PHONY: dev dev-lan dev-local

PORT ?= 8000
BIND ?= 0.0.0.0
LOCAL_HOST ?= localhost
PORT_AUTO ?= 1
PORT_SCAN_LIMIT ?= 25

.DEFAULT_GOAL := dev

dev:
	@PORT_TO_USE="$(PORT)"; \
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
		case "$$MAC_LOCAL_NAME" in \
			Niederbook-Air-M4|Niederstudio) LOCAL_URL_HOST="$$MAC_LOCAL_NAME.local" ;; \
		esac; \
	fi; \
	DEFAULT_IFACE="$$(route -n get default 2>/dev/null | awk '/interface:/{print $$2; exit}')"; \
	LAN_IP="$$( [ -n "$$DEFAULT_IFACE" ] && ipconfig getifaddr "$$DEFAULT_IFACE" 2>/dev/null || true )"; \
	if [ -z "$$LAN_IP" ]; then LAN_IP="$$(ifconfig | awk '/inet / && $$2 !~ /^127\./ {print $$2; exit}')"; fi; \
	if [ -z "$$LAN_IP" ]; then LAN_IP="$$LOCAL_URL_HOST"; fi; \
	echo "Serving on this Mac: http://$$LOCAL_URL_HOST:$$PORT_TO_USE"; \
	echo "Serving on your network (Niederstudio): http://$$LAN_IP:$$PORT_TO_USE"; \
	echo "(Ctrl+C to stop)"; \
	(sleep 0.8; open "http://$$LOCAL_URL_HOST:$$PORT_TO_USE/") >/dev/null 2>&1 & \
	python3 -m http.server $$PORT_TO_USE --bind $(BIND)

dev-lan: dev

dev-local:
	@PORT_TO_USE="$(PORT)"; \
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
		case "$$MAC_LOCAL_NAME" in \
			Niederbook-Air-M4|Niederstudio) LOCAL_URL_HOST="$$MAC_LOCAL_NAME.local" ;; \
		esac; \
	fi; \
	echo "Serving local-only: http://$$LOCAL_URL_HOST:$$PORT_TO_USE (Ctrl+C to stop)"; \
	(sleep 0.8; open "http://$$LOCAL_URL_HOST:$$PORT_TO_USE/") >/dev/null 2>&1 & \
	python3 -m http.server $$PORT_TO_USE --bind localhost
