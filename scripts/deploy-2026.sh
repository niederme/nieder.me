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

# Auto-bump asset cache-bust query string in index.html:
# assets/css/styles.css?v=YYYYMMDD-###
# assets/js/main.js?v=YYYYMMDD-###
today="$(date +%Y%m%d)"
existing_version="$(grep -Eo 'assets/css/styles\.css\?v=[0-9]{8}-[0-9]{3}' index.html | head -n1 | sed -E 's#.*\?v=##' || true)"
next_seq=1

if [[ "$existing_version" =~ ^([0-9]{8})-([0-9]{3})$ ]]; then
  existing_date="${BASH_REMATCH[1]}"
  existing_seq="${BASH_REMATCH[2]}"
  if [[ "$existing_date" == "$today" ]]; then
    next_seq=$((10#$existing_seq + 1))
  fi
fi

new_css_version="$(printf "%s-%03d" "$today" "$next_seq")"
perl -0pi -e "s#href=\"assets/css/styles\\.css(?:\\?v=[0-9]{8}-[0-9]{3})?\"#href=\"assets/css/styles.css?v=${new_css_version}\"#g" index.html
perl -0pi -e "s#src=\"assets/js/main\\.js(?:\\?v=[0-9]{8}-[0-9]{3})?\"#src=\"assets/js/main.js?v=${new_css_version}\"#g" index.html
echo "Using asset cache-bust version: ${new_css_version}"

REMOTE="${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH%/}/"

# Ensure remote target exists.
ssh -p "$DEPLOY_PORT" "${DEPLOY_USER}@${DEPLOY_HOST}" "mkdir -p '${DEPLOY_PATH%/}'"

# Sync site root file and assets folder.
rsync "${RSYNC_ARGS[@]}" -e "ssh -p $DEPLOY_PORT" \
  index.html assets \
  "$REMOTE"

echo "Deploy complete -> $REMOTE"
