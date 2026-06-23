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

RSYNC_DELETE_ARGS=(
  -avz
  --delete
  --exclude .git/
  --exclude .DS_Store
)

RSYNC_UPDATE_ARGS=(
  -avz
  --exclude .git/
  --exclude .DS_Store
)

# Keep every top-level public section here so deploy scope stays explicit.
PUBLIC_DIRS=(
  about
  accessibility
  admin
  blog
  design-system
  privacy
  work
)

ROOT_PUBLIC_FILES=(
  404.html
  apple-touch-icon-precomposed.png
  apple-touch-icon.png
  favicon.ico
  favicon.png
  feed.xml
  llms.txt
  robots.txt
  sitemap.xml
)

if [[ "$DRY_RUN" == "1" ]]; then
  RSYNC_DELETE_ARGS+=(--dry-run)
  RSYNC_UPDATE_ARGS+=(--dry-run)
fi

STAGING_DIR="$(mktemp -d "${TMPDIR:-/tmp}/deploy-2026.XXXXXX")"
ssh_control_id="$(printf '%s' "${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PORT}:${DEPLOY_PATH}" | shasum -a 256 | awk '{print substr($1, 1, 12)}')"
SSH_CONTROL_PATH="${TMPDIR:-/tmp}/nieder-deploy-${ssh_control_id}.sock"
cleanup() {
  if [[ -n "${RSYNC_SSH_CMD:-}" ]]; then
    "${SSH_CMD[@]}" -O exit "${DEPLOY_USER}@${DEPLOY_HOST}" >/dev/null 2>&1 || true
  fi
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

cp index.html "$STAGING_DIR/"
cp -R assets "$STAGING_DIR/"
site_path="$(python3 - "$SITE_URL" <<'PY'
from urllib.parse import urlparse
import sys

path = urlparse(sys.argv[1]).path.rstrip("/")
print(path)
PY
)"
error_document_path="${site_path}/404.html"
if [[ "$error_document_path" != /* ]]; then
  error_document_path="/${error_document_path}"
fi
design_system_redirect_path="${site_path}/design-system/"
styleguide_redirect_path="${site_path}/design-system/#principles"
cat > "$STAGING_DIR/.htaccess" <<HTACCESS
RewriteEngine On
RewriteCond %{HTTP_HOST} ^www\.nieder\.me$ [NC]
RewriteRule ^ https://nieder.me%{REQUEST_URI} [R=301,L,NE]
RewriteRule ^portfolio/?$ /2016/portfolio/ [R=301,L]
RewriteRule ^portfolio/nyt-invisible-child/?$ /2016/portfolio/nyt-invisible-child/ [R=301,L]
RewriteRule ^portfolio/buzzfeed-social-mission-control/?$ /2016/portfolio/buzzfeed-social-mission-control/ [R=301,L]
RewriteRule ^work/somm-ai/?$ ${site_path}/work/resy-search-ai/ [R=301,L]
RewriteRule ^resy-ai-demo\.html$ ${site_path}/work/resy-search-ai/ [R=301,L]
RewriteRule ^sendmoi/?$ https://send.moi/ [R=301,L,NE]
RewriteRule ^sendmoi/(accessibility|privacy|terms)/?$ https://send.moi/\$1/ [R=301,L,NE]
RewriteRule ^mailmoi/?$ https://send.moi/ [R=301,L,NE]
RewriteRule ^mailmoi/(accessibility|privacy|terms)/?$ https://send.moi/\$1/ [R=301,L,NE]
RewriteRule ^colophon/?$ ${design_system_redirect_path} [R=301,L]
RewriteRule ^colophon-style-guide/?$ ${design_system_redirect_path} [R=301,L]
RewriteRule ^styleguide/?$ ${styleguide_redirect_path} [R=301,L,NE]
ErrorDocument 404 ${error_document_path}
HTACCESS
for file in "${ROOT_PUBLIC_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    cp "$file" "$STAGING_DIR/"
  fi
done
# Build deploy metadata in staging so routine sitemap drift never blocks a deploy
# or modifies the working tree.
./scripts/update-sitemap.py --site-url "$SITE_URL" --output "$STAGING_DIR/sitemap.xml"
if [[ -n "$site_path" && -f "$STAGING_DIR/404.html" ]]; then
  python3 - "$STAGING_DIR/404.html" "$site_path" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
prefix = sys.argv[2].rstrip("/")
html = path.read_text()

def prefix_root_url(match):
    attr, url = match.groups()
    if url.startswith(prefix + "/"):
        return match.group(0)
    return f'{attr}="{prefix}{url}"'

html = re.sub(r'(href|src)="(/(?:assets|favicon|apple-touch-icon)[^"]*)"', prefix_root_url, html)
html = re.sub(r'(href)="(/(?:work|about|design-system)/?)"', prefix_root_url, html)
html = html.replace('href="/"', f'href="{prefix}/"')
path.write_text(html)
PY
fi
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
  -o ControlMaster=auto
  -o ControlPersist=120
  -o ControlPath="$SSH_CONTROL_PATH"
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

# Sync managed site paths from staging so deploy does not delete unrelated
# root-level server files such as host-managed config.
SYNC_PATHS=("$STAGING_DIR/.htaccess" "$STAGING_DIR/index.html" "$STAGING_DIR/assets")
for file in "${ROOT_PUBLIC_FILES[@]}"; do
  if [[ -f "$STAGING_DIR/$file" ]]; then
    SYNC_PATHS+=("$STAGING_DIR/$file")
  fi
done
for dir in "${PUBLIC_DIRS[@]}"; do
  if [[ "$dir" == "work" ]]; then
    continue
  fi
  if [[ -d "$STAGING_DIR/$dir" ]]; then
    SYNC_PATHS+=("$STAGING_DIR/$dir")
  fi
done

rsync "${RSYNC_DELETE_ARGS[@]}" -e "$RSYNC_SSH_CMD" \
  "${SYNC_PATHS[@]}" \
  "$REMOTE"

if [[ -d "$STAGING_DIR/work" ]]; then
  # Sync work/ without --delete so remote-only work material is preserved.
  rsync "${RSYNC_UPDATE_ARGS[@]}" -e "$RSYNC_SSH_CMD" \
    "$STAGING_DIR/work" \
    "$REMOTE"
fi

echo "Deploy complete -> $REMOTE"
