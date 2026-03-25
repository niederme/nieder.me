#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PILOT_PAGE="work/resy-discovery/index.html"
WORK_STYLESHEET="assets/css/work-case-study.css"

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
expect_pattern "$WORK_STYLESHEET" ".case-study-story" "Work stylesheet should define the shared case-study story namespace."
expect_pattern "$WORK_STYLESHEET" ".case-study-block {" "Work stylesheet should define the base case-study block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-hero" "Work stylesheet should style the hero block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-meta" "Work stylesheet should style the meta block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-lede" "Work stylesheet should style the lede block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-text" "Work stylesheet should style the text block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-results" "Work stylesheet should style the results block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-full-media" "Work stylesheet should style the full-media block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-aside-media" "Work stylesheet should style the aside-media block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-two-up" "Work stylesheet should style the two-up block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-callout" "Work stylesheet should style the callout block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-divider" "Work stylesheet should style the divider block."
expect_pattern "$WORK_STYLESHEET" ".case-study-block-carousel" "Work stylesheet should style the carousel block."
expect_pattern "$WORK_STYLESHEET" ".case-study-caption" "Work stylesheet should define the shared case-study caption."

echo "case-study block checks passed"
