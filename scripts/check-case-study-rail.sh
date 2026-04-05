#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

CASE_STUDY_PAGES=(
  "work/resy-discovery/index.html"
  "work/sendmoi/index.html"
  "work/somm-ai/index.html"
  "work/ai-quota/index.html"
)

fail() {
  echo "FAIL: $1"
  exit 1
}

for page in "${CASE_STUDY_PAGES[@]}"; do
  if ! rg -q '<aside class="rail">' "$page"; then
    fail "$page should use the shared rail wrapper."
  fi

  if ! rg -q '<nav class="global-nav" aria-label="Primary navigation">' "$page"; then
    fail "$page should use the shared global-nav markup."
  fi

  if rg -q 'case-study-logo-link|case-study-side-nav' "$page"; then
    fail "$page should not use the miniature case-study rail classes."
  fi
done

if rg -q '\.case-study-page \.case-study-logo-link|\.case-study-page \.case-study-side-nav' assets/css/work-case-study.css; then
  fail "assets/css/work-case-study.css should not define case-study-only miniature rail selectors."
fi

echo "case-study rail check passed"
