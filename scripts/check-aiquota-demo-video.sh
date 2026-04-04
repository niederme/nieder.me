#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PAGE="work/ai-quota/index.html"
ASSET="assets/videos/aiquota-demo-inline.mp4"
STYLESHEET="assets/css/work-case-study.css"

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
  echo "FAIL: missing AIQuota demo asset at $ASSET"
  exit 1
fi

expect_pattern "$PAGE" 'case-study-block case-study-block-full-media case-study-block-aiquota-demo' \
  "AIQuota should include a dedicated first inline demo block."
expect_pattern "$PAGE" '../../assets/videos/aiquota-demo-inline.mp4' \
  "AIQuota demo block should reference the web-ready MP4 asset."
expect_pattern "$PAGE" 'data-case-study-demo-video' \
  "AIQuota demo video should use the shared case-study demo video behavior."
expect_pattern "$PAGE" 'case-study-aiquota-demo-mobile' \
  "AIQuota demo block should keep a mobile fallback treatment."
expect_pattern "$STYLESHEET" '--aiquota-stage-bg:' \
  "AIQuota demo stage should use the product-specific background treatment."
expect_pattern "$STYLESHEET" 'width: min(100%, 460px);' \
  "AIQuota demo shell should stay close to the new source asset's native size on retina displays."
expect_pattern "$STYLESHEET" 'aspect-ratio: 16 / 9;' \
  "AIQuota demo stage should keep a 16:9 footprint on desktop."
expect_pattern "$STYLESHEET" 'aspect-ratio: 1534 / 862;' \
  "AIQuota desktop video frame should match the current source asset's dimensions."

first_text_line="$(rg -n 'case-study-block case-study-block-text' "$PAGE" | head -n1 | cut -d: -f1)"
demo_line="$(rg -n 'case-study-block case-study-block-full-media case-study-block-aiquota-demo' "$PAGE" | head -n1 | cut -d: -f1)"
second_text_line="$(rg -n 'case-study-block case-study-block-text' "$PAGE" | sed -n '2p' | cut -d: -f1)"

if [ -z "$first_text_line" ] || [ -z "$demo_line" ] || [ -z "$second_text_line" ]; then
  echo "FAIL: could not resolve AIQuota block ordering."
  exit 1
fi

if [ "$first_text_line" -ge "$demo_line" ] || [ "$demo_line" -ge "$second_text_line" ]; then
  echo "FAIL: AIQuota demo block should sit between the first and second text blocks."
  exit 1
fi

echo "aiquota demo video check passed"
