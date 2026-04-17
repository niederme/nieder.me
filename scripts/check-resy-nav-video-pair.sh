#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PAGE="work/resy-discovery/index.html"
STYLESHEET="assets/css/work-case-study.css"
TAB_ASSET="assets/videos/resy-navigation-tabs.mp4"
SHEET_ASSET="assets/videos/resy-navigation-sheets.mp4"
TAB_POSTER="assets/images/case-studies/resy-discovery/article/resy-navigation-tabs-poster.jpg"
SHEET_POSTER="assets/images/case-studies/resy-discovery/article/resy-navigation-sheets-poster.jpg"

expect_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q --fixed-strings -- "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

if [ ! -f "$TAB_ASSET" ]; then
  echo "FAIL: missing tabs demo asset at $TAB_ASSET"
  exit 1
fi

if [ ! -f "$SHEET_ASSET" ]; then
  echo "FAIL: missing sheets demo asset at $SHEET_ASSET"
  exit 1
fi

if [ ! -f "$TAB_POSTER" ]; then
  echo "FAIL: missing tabs poster asset at $TAB_POSTER"
  exit 1
fi

if [ ! -f "$SHEET_POSTER" ]; then
  echo "FAIL: missing sheets poster asset at $SHEET_POSTER"
  exit 1
fi

expect_pattern "$PAGE" 'case-study-block case-study-block-full-media case-study-block-resy-demo case-study-block-resy-nav-demo-pair' \
  "Resy case study should include a dedicated full-width paired navigation demo block."
expect_pattern "$PAGE" '../../assets/videos/resy-navigation-tabs.mp4' \
  "Resy paired demo block should reference the tabs MP4 asset."
expect_pattern "$PAGE" '../../assets/videos/resy-navigation-sheets.mp4' \
  "Resy paired demo block should reference the sheets MP4 asset."
expect_pattern "$PAGE" '../../assets/images/case-studies/resy-discovery/article/resy-navigation-tabs-poster.jpg' \
  "Resy paired demo block should reference the tabs poster image."
expect_pattern "$PAGE" '../../assets/images/case-studies/resy-discovery/article/resy-navigation-sheets-poster.jpg' \
  "Resy paired demo block should reference the sheets poster image."
expect_pattern "$PAGE" 'Tabs clarify the top-level jobs while sheets keep venue detail and booking context close at hand.' \
  "Resy paired demo block should use one combined caption describing the tabs-to-sheets relationship."
expect_pattern "$PAGE" 'data-case-study-demo-video' \
  "Resy paired demo videos should use the shared case-study demo video behavior."
expect_pattern "$STYLESHEET" '.case-study-resy-nav-stage {' \
  "Work case-study stylesheet should define the shared paired Resy navigation stage."
expect_pattern "$STYLESHEET" '.case-study-resy-nav-demo {' \
  "Work case-study stylesheet should define the per-phone layout inside the shared stage."
expect_pattern "$STYLESHEET" 'grid-template-columns: repeat(12, minmax(0, 1fr));' \
  "Resy paired navigation stage should align the phones to the shared 12-column shell."
expect_pattern "$STYLESHEET" '.case-study-block-resy-nav-demo-pair .case-study-caption {' \
  "Work case-study stylesheet should size the combined detached caption for the paired Resy block."

if rg -q --fixed-strings -- 'case-study-resy-nav-demo-label' "$PAGE"; then
  echo "FAIL: Resy paired demo block should no longer use inline per-phone labels."
  exit 1
fi

nav_line="$(rg -n '<h2>Navigation &amp; Architecture</h2>' "$PAGE" | head -n1 | cut -d: -f1)"
pair_line="$(rg -n 'case-study-block case-study-block-full-media case-study-block-resy-demo case-study-block-resy-nav-demo-pair' "$PAGE" | head -n1 | cut -d: -f1)"
editorial_line="$(rg -n '<h2>Building on the Existing Editorial Stack</h2>' "$PAGE" | head -n1 | cut -d: -f1)"

if [ -z "$nav_line" ] || [ -z "$pair_line" ] || [ -z "$editorial_line" ]; then
  echo "FAIL: could not resolve Resy navigation pair block ordering."
  exit 1
fi

if [ "$nav_line" -ge "$pair_line" ] || [ "$pair_line" -ge "$editorial_line" ]; then
  echo "FAIL: Resy paired navigation demo block should sit after Navigation & Architecture and before the editorial stack section."
  exit 1
fi

echo "resy nav video pair check passed"
