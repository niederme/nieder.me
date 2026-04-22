#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/release.sh <version> --prod [--title "Release title"] [--notes-file path] [--yes]
  ./scripts/release.sh <version> --staging [--title "Release title"] [--notes-file path]

Examples:
  ./scripts/release.sh 2026.04.22 --staging
  ./scripts/release.sh 2026.04.22 --prod --title "2026 Portfolio Launch"

Notes:
  - Staging mode does not create a GitHub release. It validates and previews.
  - Production mode creates an annotated git tag and GitHub release.
  - Run production releases only after the root production deploy has succeeded.
EOF
}

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  usage
  exit 1
fi
shift

ENVIRONMENT=""
TITLE=""
NOTES_FILE=""
ASSUME_YES="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prod)
      ENVIRONMENT="prod"
      shift
      ;;
    --staging|--stage)
      ENVIRONMENT="staging"
      shift
      ;;
    --title)
      TITLE="${2:-}"
      if [[ -z "$TITLE" ]]; then
        echo "Missing value for --title."
        exit 1
      fi
      shift 2
      ;;
    --notes-file)
      NOTES_FILE="${2:-}"
      if [[ -z "$NOTES_FILE" ]]; then
        echo "Missing value for --notes-file."
        exit 1
      fi
      shift 2
      ;;
    --yes|-y)
      ASSUME_YES="1"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$ENVIRONMENT" ]]; then
  echo "Choose --staging or --prod."
  exit 1
fi

TAG="$VERSION"
if [[ "$TAG" != v* ]]; then
  TAG="v${TAG}"
fi

if [[ -z "$TITLE" ]]; then
  TITLE="${TAG#v} Portfolio Release"
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    exit 1
  fi
}

require_command git
require_command gh
require_command python3

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated. Run: gh auth login"
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash changes before releasing."
  git status --short
  exit 1
fi

git fetch origin --prune >/dev/null

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "Releases must be cut from main. Current branch: ${CURRENT_BRANCH}"
  echo "Switch to main and pull the production commit first."
  exit 1
fi

if [[ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]]; then
  echo "Local main does not match origin/main. Run: git pull --ff-only origin main"
  exit 1
fi

if git rev-parse "$TAG" >/dev/null 2>&1 || git ls-remote --exit-code --tags origin "refs/tags/${TAG}" >/dev/null 2>&1; then
  echo "Tag already exists: ${TAG}"
  exit 1
fi

if gh release view "$TAG" >/dev/null 2>&1; then
  echo "GitHub release already exists: ${TAG}"
  exit 1
fi

STAGING_URL="${STAGING_URL:-https://nieder.me/2026/}"
PROD_URL="${PROD_URL:-https://nieder.me/}"
TARGET_URL="$STAGING_URL"
if [[ "$ENVIRONMENT" == "prod" ]]; then
  TARGET_URL="$PROD_URL"
fi

echo "Release target:"
echo "  Environment: ${ENVIRONMENT}"
echo "  Tag:         ${TAG}"
echo "  Title:       ${TITLE}"
echo "  Commit:      $(git rev-parse --short HEAD)"
echo "  URL:         ${TARGET_URL}"

python3 - "$TARGET_URL" <<'PY'
import sys
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

url = sys.argv[1]
try:
    with urlopen(Request(url, headers={"User-Agent": "Mozilla/5.0 Safari/605.1.15"}), timeout=20) as response:
        body = response.read(4096).decode("utf-8", "replace")
        title = body.split("<title>", 1)[1].split("</title>", 1)[0] if "<title>" in body else ""
        print(f"  URL check:   {response.status} {title}")
        if response.status != 200:
            raise SystemExit(1)
except HTTPError as error:
    print(f"URL check failed: HTTP {error.code}")
    raise SystemExit(1)
except URLError as error:
    print(f"URL check failed: {error}")
    raise SystemExit(1)
PY

LAST_TAG="$(git describe --tags --abbrev=0 2>/dev/null || true)"
NOTES_TMP="$(mktemp /tmp/nieder-release-notes.XXXXXX.md)"
cleanup() {
  rm -f "$NOTES_TMP"
}
trap cleanup EXIT

if [[ -n "$NOTES_FILE" ]]; then
  if [[ ! -f "$NOTES_FILE" ]]; then
    echo "Notes file not found: ${NOTES_FILE}"
    exit 1
  fi
  cp "$NOTES_FILE" "$NOTES_TMP"
else
  {
    echo "## ${TITLE}"
    echo ""
    if [[ -n "$LAST_TAG" ]]; then
      git log "${LAST_TAG}..HEAD" --pretty=format:"- %s" --no-merges
    else
      git log --pretty=format:"- %s" --no-merges | head -20
    fi
    echo ""
  } > "$NOTES_TMP"

  echo "Opening release notes for editing. Close the editor to continue."
  if [[ -n "${EDITOR:-}" ]]; then
    "$EDITOR" "$NOTES_TMP"
  else
    open -W -a TextEdit "$NOTES_TMP"
  fi
fi

echo ""
echo "Release notes:"
echo "--------------"
cat "$NOTES_TMP"
echo "--------------"

if [[ "$ENVIRONMENT" == "staging" ]]; then
  echo "Staging mode complete. No tag or GitHub release was created."
  exit 0
fi

if [[ "$ASSUME_YES" != "1" ]]; then
  echo ""
  read -r -p "Create production release ${TAG} from $(git rev-parse --short HEAD)? Type 'release' to continue: " CONFIRM
  if [[ "$CONFIRM" != "release" ]]; then
    echo "Release canceled."
    exit 1
  fi
fi

git tag -a "$TAG" -m "$TITLE"
git push origin "$TAG"

gh release create "$TAG" \
  --title "$TITLE" \
  --notes-file "$NOTES_TMP" \
  --target "$(git rev-parse HEAD)"

echo "Release ${TAG} is live."
