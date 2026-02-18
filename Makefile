.PHONY: dev

PORT ?= 8000
HOST ?= localhost

.DEFAULT_GOAL := dev

dev:
	@echo "Serving http://$(HOST):$(PORT) (Ctrl+C to stop)"
	@(sleep 0.8; open "http://$(HOST):$(PORT)/") >/dev/null 2>&1 &
	python3 -m http.server $(PORT) --bind $(HOST)
