#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

export DEPLOY_PATH="${DEPLOY_PATH:-/home2/suckahs/public_html/nieder}"
export SITE_URL="${SITE_URL:-https://nieder.me}"

exec "$SCRIPT_DIR/deploy-2026.sh"
