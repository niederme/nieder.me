#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PAGE="work/resy-discovery/index.html"
STYLESHEET="assets/css/work-case-study.css"
ASSET="assets/videos/resy-editorial-integration.mp4"
POSTER="assets/images/case-studies/resy-discovery/article/resy-editorial-integration-poster.jpg"

expect_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q --fixed-strings -- "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

if [ ! -f "$ASSET" ]; then
  echo "FAIL: missing editorial integration asset at $ASSET"
  exit 1
fi

if [ ! -f "$POSTER" ]; then
  echo "FAIL: missing editorial integration poster at $POSTER"
  exit 1
fi

expect_pattern "$PAGE" 'case-study-block case-study-block-aside-media case-study-block-aside-right case-study-block-resy-editorial-rail' \
  "Resy case study should include a dedicated right-rail editorial integration video block."
expect_pattern "$PAGE" '../../assets/videos/resy-editorial-integration.mp4' \
  "Resy editorial rail block should reference the editorial integration MP4 asset."
expect_pattern "$PAGE" '../../assets/images/case-studies/resy-discovery/article/resy-editorial-integration-poster.jpg' \
  "Resy editorial rail block should reference the editorial integration poster."
expect_pattern "$PAGE" 'Existing WordPress editorial reframed inside the app browser,' \
  "Resy editorial rail block should explain the web-to-app editorial reframing."
expect_pattern "$PAGE" 'with web chrome stripped back so native' \
  "Resy editorial rail block should explain that native actions stay close."
expect_pattern "$PAGE" 'data-case-study-demo-video' \
  "Resy editorial rail block should use the shared case-study demo video behavior."
expect_pattern "$STYLESHEET" '.case-study-block-resy-editorial-rail .case-study-media {' \
  "Work case-study stylesheet should size the editorial rail video stage."
expect_pattern "$STYLESHEET" '.case-study-block-resy-editorial-rail .case-study-resy-device-shell {' \
  "Work case-study stylesheet should size the editorial rail device shell."

split_line="$(rg -n --fixed-strings 'That gave us a meaningful operational advantage.' "$PAGE" | head -n1 | cut -d: -f1)"
block_line="$(rg -n 'case-study-block case-study-block-aside-media case-study-block-aside-right case-study-block-resy-editorial-rail' "$PAGE" | head -n1 | cut -d: -f1)"
next_line="$(rg -n '<h2>Designing for the Mobile Moment</h2>' "$PAGE" | head -n1 | cut -d: -f1)"

if [ -z "$split_line" ] || [ -z "$block_line" ] || [ -z "$next_line" ]; then
  echo "FAIL: could not resolve editorial rail block ordering."
  exit 1
fi

if [ "$split_line" -ge "$block_line" ] || [ "$block_line" -ge "$next_line" ]; then
  echo "FAIL: Resy editorial rail block should sit after the operational-advantage paragraph and before Designing for the Mobile Moment."
  exit 1
fi

echo "resy editorial rail video check passed"
