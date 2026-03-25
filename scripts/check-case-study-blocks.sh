#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PILOT_PAGE="work/resy-discovery/index.html"

expect_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q --fixed-strings "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

expect_pattern "$PILOT_PAGE" 'class="case-study-story"' "Resy pilot should define the shared case-study story wrapper."
expect_pattern "$PILOT_PAGE" "case-study-block case-study-block-hero" "Resy pilot should use the hero block."
expect_pattern "$PILOT_PAGE" "case-study-block case-study-block-meta" "Resy pilot should use the meta block."
expect_pattern "$PILOT_PAGE" "case-study-block case-study-block-lede" "Resy pilot should use the lede block."

echo "case-study block checks passed"
