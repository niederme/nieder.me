.PHONY: dev dev-local

PORT ?= 8000
HOST ?= localhost
BIND ?= 0.0.0.0

.DEFAULT_GOAL := dev

dev:
	@LAN_IP="$$(ipconfig getifaddr en1 2>/dev/null || ipconfig getifaddr en0 2>/dev/null || echo localhost)"; \
	echo "Serving on LAN: http://$$LAN_IP:$(PORT) (Ctrl+C to stop)"; \
	(sleep 0.8; open "http://localhost:$(PORT)/") >/dev/null 2>&1 & \
	python3 -m http.server $(PORT) --bind $(BIND)

dev-local:
	@echo "Serving http://$(HOST):$(PORT) (Ctrl+C to stop)"
	@(sleep 0.8; open "http://$(HOST):$(PORT)/") >/dev/null 2>&1 &
	python3 -m http.server $(PORT) --bind $(HOST)
