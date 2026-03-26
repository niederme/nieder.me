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
#   SITE_URL      defaults to https://nieder.me/2026

DEPLOY_HOST="${DEPLOY_HOST:-ssh.suckahs.org}"
DEPLOY_USER="${DEPLOY_USER:-suckahs}"
DEPLOY_PATH="${DEPLOY_PATH:-/home2/suckahs/public_html/nieder/2026}"

DEPLOY_PORT="${DEPLOY_PORT:-22}"
DRY_RUN="${DRY_RUN:-0}"
SITE_URL="${SITE_URL:-https://nieder.me/2026}"

RSYNC_ARGS=(
  -avz
  --delete
  --exclude .git/
  --exclude .DS_Store
)

if [[ "$DRY_RUN" == "1" ]]; then
  RSYNC_ARGS+=(--dry-run)
fi

STAGING_DIR="$(mktemp -d "${TMPDIR:-/tmp}/deploy-2026.XXXXXX")"
cleanup() {
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

cp index.html "$STAGING_DIR/"
cp -R assets "$STAGING_DIR/"
if [[ -d about ]]; then
  cp -R about "$STAGING_DIR/"
fi
if [[ -d colophon ]]; then
  cp -R colophon "$STAGING_DIR/"
fi
if [[ -d work ]]; then
  cp -R work "$STAGING_DIR/"
fi

./scripts/set-site-url.sh "$SITE_URL" "$STAGING_DIR/index.html"

css_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/css/styles.css" | awk '{print substr($1, 1, 12)}')"
work_css_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/css/work-case-study.css" | awk '{print substr($1, 1, 12)}')"
js_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/js/main.js" | awk '{print substr($1, 1, 12)}')"
find "$STAGING_DIR" -name '*.html' -print0 | xargs -0 perl -0pi -e \
  "s#href=\"((?:\\.\\./)*/?assets/css/styles\\.css)(?:\\?v=[^\"]+)?\"#href=\"\$1?v=${css_cache_bust}\"#g;
   s#href=\"((?:\\.\\./)*/?assets/css/work-case-study\\.css)(?:\\?v=[^\"]+)?\"#href=\"\$1?v=${work_css_cache_bust}\"#g;
   s#src=\"((?:\\.\\./)*/?assets/js/main\\.js)(?:\\?v=[^\"]+)?\"#src=\"\$1?v=${js_cache_bust}\"#g"
echo "Using staged asset cache-bust versions: styles.css?v=${css_cache_bust}, work-case-study.css?v=${work_css_cache_bust}, main.js?v=${js_cache_bust}"

REMOTE="${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH%/}/"

# Ensure remote target exists.
ssh -p "$DEPLOY_PORT" "${DEPLOY_USER}@${DEPLOY_HOST}" "mkdir -p '${DEPLOY_PATH%/}'"

# Sync only the managed site paths from staging so deploy does not delete
# unrelated root-level server files such as host-managed config.
SYNC_PATHS=("$STAGING_DIR/index.html" "$STAGING_DIR/assets")
if [[ -d "$STAGING_DIR/about" ]]; then
  SYNC_PATHS+=("$STAGING_DIR/about")
fi
if [[ -d "$STAGING_DIR/colophon" ]]; then
  SYNC_PATHS+=("$STAGING_DIR/colophon")
fi
if [[ -d "$STAGING_DIR/work" ]]; then
  SYNC_PATHS+=("$STAGING_DIR/work")
fi

rsync "${RSYNC_ARGS[@]}" -e "ssh -p $DEPLOY_PORT" \
  "${SYNC_PATHS[@]}" \
  "$REMOTE"

echo "Deploy complete -> $REMOTE"
