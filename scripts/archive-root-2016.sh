#!/usr/bin/env bash
set -euo pipefail

# Preserve the current root site into /2016 before replacing root with the
# managed 2026 portfolio. Refuses to overwrite an existing archive unless
# FORCE=1 is provided.

DEPLOY_HOST="${DEPLOY_HOST:-ssh.suckahs.org}"
DEPLOY_USER="${DEPLOY_USER:-suckahs}"
ROOT_PATH="${ROOT_PATH:-/home2/suckahs/public_html/nieder}"
ARCHIVE_PATH="${ARCHIVE_PATH:-${ROOT_PATH%/}/2016}"

DEPLOY_PORT="${DEPLOY_PORT:-22}"
DEPLOY_IDENTITY_FILE="${DEPLOY_IDENTITY_FILE:-}"
FORCE="${FORCE:-0}"

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

printf -v ROOT_PATH_Q '%q' "$ROOT_PATH"
printf -v ARCHIVE_PATH_Q '%q' "$ARCHIVE_PATH"
printf -v FORCE_Q '%q' "$FORCE"

"${SSH_CMD[@]}" "${DEPLOY_USER}@${DEPLOY_HOST}" \
  "ROOT_PATH=${ROOT_PATH_Q} ARCHIVE_PATH=${ARCHIVE_PATH_Q} FORCE=${FORCE_Q} bash -s" <<'REMOTE'
set -euo pipefail

root="${ROOT_PATH%/}"
archive="${ARCHIVE_PATH%/}"

if [[ -e "$archive" && "$FORCE" != "1" ]]; then
  echo "Archive already exists at $archive. Set FORCE=1 to refresh it." >&2
  exit 1
fi

mkdir -p "$archive"
rsync -a --delete \
  --exclude '/2016/' \
  --exclude '/2026/' \
  "$root"/ \
  "$archive"/

date -u +"%Y-%m-%dT%H:%M:%SZ" > "$archive/.nieder-root-archive-created"
echo "Archive complete -> $archive"
REMOTE
