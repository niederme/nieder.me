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
DEPLOY_IDENTITY_FILE="${DEPLOY_IDENTITY_FILE:-}"

RSYNC_ARGS=(
  -avz
  # Delete stale files from managed deploy paths, but never remote-only /work
  # material. The protect filter below is deliberate; do not remove it just
  # because work/ is in PUBLIC_DIRS.
  --delete
  --filter "P work/***"
  --exclude .git/
  --exclude .DS_Store
)

# Keep every top-level public section here so deploy scope stays explicit.
PUBLIC_DIRS=(
  about
  accessibility
  colophon
  colophon-style-guide
  privacy
  styleguide
  work
)

ROOT_PUBLIC_FILES=(
  404.html
  apple-touch-icon-precomposed.png
  apple-touch-icon.png
  favicon.ico
  favicon.png
  llms.txt
  robots.txt
  sitemap.xml
)

if [[ "$DRY_RUN" == "1" ]]; then
  RSYNC_ARGS+=(--dry-run)
fi

./scripts/update-sitemap.py --check

STAGING_DIR="$(mktemp -d "${TMPDIR:-/tmp}/deploy-2026.XXXXXX")"
cleanup() {
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

cp index.html "$STAGING_DIR/"
cp -R assets "$STAGING_DIR/"
for file in "${ROOT_PUBLIC_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    cp "$file" "$STAGING_DIR/"
  fi
done
for dir in "${PUBLIC_DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    cp -R "$dir" "$STAGING_DIR/"
  fi
done

css_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/css/styles.css" | awk '{print substr($1, 1, 12)}')"
work_css_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/css/work-case-study.css" | awk '{print substr($1, 1, 12)}')"
styleguide_css_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/css/styleguide.css" | awk '{print substr($1, 1, 12)}')"
js_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/js/main.js" | awk '{print substr($1, 1, 12)}')"
resume_pdf_cache_bust="$(shasum -a 256 "$STAGING_DIR/assets/files/John-Niedermeyer-Resume.pdf" | awk '{print substr($1, 1, 12)}')"
find "$STAGING_DIR" -name '*.html' -print0 | xargs -0 perl -0pi -e \
  "s#href=\"((?:\\.\\./)*/?assets/css/styles\\.css)(?:\\?v=[^\"]+)?\"#href=\"\$1?v=${css_cache_bust}\"#g;
   s#href=\"((?:\\.\\./)*/?assets/css/work-case-study\\.css)(?:\\?v=[^\"]+)?\"#href=\"\$1?v=${work_css_cache_bust}\"#g;
   s#href=\"((?:\\.\\./)*/?assets/css/styleguide\\.css)(?:\\?v=[^\"]+)?\"#href=\"\$1?v=${styleguide_css_cache_bust}\"#g;
   s#src=\"((?:\\.\\./)*/?assets/js/main\\.js)(?:\\?v=[^\"]+)?\"#src=\"\$1?v=${js_cache_bust}\"#g;
   s#href=\"((?:\\.\\./)*/?assets/files/John-Niedermeyer-Resume\\.pdf)(?:\\?v=[^\"]+)?\"#href=\"\$1?v=${resume_pdf_cache_bust}\"#g"
echo "Using staged asset cache-bust versions: styles.css?v=${css_cache_bust}, work-case-study.css?v=${work_css_cache_bust}, styleguide.css?v=${styleguide_css_cache_bust}, main.js?v=${js_cache_bust}, John-Niedermeyer-Resume.pdf?v=${resume_pdf_cache_bust}"

REMOTE="${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH%/}/"
SSH_CMD=(
  ssh
  -p "$DEPLOY_PORT"
  -o IdentitiesOnly=yes
)

if [[ -n "$DEPLOY_IDENTITY_FILE" ]]; then
  SSH_CMD+=(-i "$DEPLOY_IDENTITY_FILE")
elif [[ -f "${HOME}/.ssh/nieder_me_deploy" ]]; then
  SSH_CMD+=(-i "${HOME}/.ssh/nieder_me_deploy")
fi

printf -v RSYNC_SSH_CMD '%q ' "${SSH_CMD[@]}"
RSYNC_SSH_CMD="${RSYNC_SSH_CMD% }"

# Ensure remote target exists.
"${SSH_CMD[@]}" "${DEPLOY_USER}@${DEPLOY_HOST}" "mkdir -p '${DEPLOY_PATH%/}'"

# Sync only the managed site paths from staging so deploy does not delete
# unrelated root-level server files such as host-managed config. Remote-only
# files under work/ are protected too; that tree can contain non-repo work.
SYNC_PATHS=("$STAGING_DIR/index.html" "$STAGING_DIR/assets")
for file in "${ROOT_PUBLIC_FILES[@]}"; do
  if [[ -f "$STAGING_DIR/$file" ]]; then
    SYNC_PATHS+=("$STAGING_DIR/$file")
  fi
done
for dir in "${PUBLIC_DIRS[@]}"; do
  if [[ -d "$STAGING_DIR/$dir" ]]; then
    SYNC_PATHS+=("$STAGING_DIR/$dir")
  fi
done

rsync "${RSYNC_ARGS[@]}" -e "$RSYNC_SSH_CMD" \
  "${SYNC_PATHS[@]}" \
  "$REMOTE"

echo "Deploy complete -> $REMOTE"
