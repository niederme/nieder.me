#!/usr/bin/env bash
set -euo pipefail

# Deploy static site files to a remote /2026 directory over SSH + rsync.
# Defaults are set for this project and can be overridden via env vars:
#   DEPLOY_HOST
#   DEPLOY_USER
#   DEPLOY_PATH
# Optional env vars:
#   DEPLOY_PORT   e.g. 22 (default: 22)
#   DRY_RUN       set to 1 for preview mode

DEPLOY_HOST="${DEPLOY_HOST:-suckahs.org}"
DEPLOY_USER="${DEPLOY_USER:-suckahs}"
DEPLOY_PATH="${DEPLOY_PATH:-/home/suckahs/public_html/nieder/2026}"

DEPLOY_PORT="${DEPLOY_PORT:-22}"
DRY_RUN="${DRY_RUN:-0}"

RSYNC_ARGS=(
  -avz
  --delete
  --exclude .git/
  --exclude .DS_Store
)

if [[ "$DRY_RUN" == "1" ]]; then
  RSYNC_ARGS+=(--dry-run)
fi

REMOTE="${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH%/}/"

# Ensure remote target exists.
ssh -p "$DEPLOY_PORT" "${DEPLOY_USER}@${DEPLOY_HOST}" "mkdir -p '${DEPLOY_PATH%/}'"

# Sync site root files and public asset folders.
rsync "${RSYNC_ARGS[@]}" -e "ssh -p $DEPLOY_PORT" \
  index.html css js icons fonts \
  "$REMOTE"

echo "Deploy complete -> $REMOTE"
