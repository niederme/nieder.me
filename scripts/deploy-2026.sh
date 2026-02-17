#!/usr/bin/env bash
set -euo pipefail

# Deploy static site files to a remote /2026 directory over SSH + rsync.
# Required env vars:
#   DEPLOY_HOST   e.g. example.com
#   DEPLOY_USER   e.g. myuser
#   DEPLOY_PATH   e.g. /home/myuser/public_html/2026
# Optional env vars:
#   DEPLOY_PORT   e.g. 22 (default: 22)
#   DRY_RUN       set to 1 for preview mode

: "${DEPLOY_HOST:?DEPLOY_HOST is required}"
: "${DEPLOY_USER:?DEPLOY_USER is required}"
: "${DEPLOY_PATH:?DEPLOY_PATH is required}"

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

# Sync site root files and assets folder.
rsync "${RSYNC_ARGS[@]}" -e "ssh -p $DEPLOY_PORT" \
  index.html assets/ \
  "$REMOTE"

echo "Deploy complete -> $REMOTE"
