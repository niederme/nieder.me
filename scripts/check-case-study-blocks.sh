#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

PILOT_PAGE="work/resy-discovery/index.html"
WORK_STYLESHEET="assets/css/work-case-study.css"
MAIN_SCRIPT="assets/js/main.js"
CASE_STUDY_PAGES=(
  "work/resy-discovery/index.html"
  "work/sendmoi/index.html"
  "work/somm-ai/index.html"
  "work/ai-quota/index.html"
)

expect_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q --fixed-strings -- "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

expect_regex() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q -U -- "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

for page in "${CASE_STUDY_PAGES[@]}"; do
  expect_pattern "$page" 'case-study-page' "${page} should declare the case-study page shell."
  expect_pattern "$page" 'class="case-study-story"' "${page} should define the shared case-study story wrapper."
  expect_pattern "$page" "case-study-block case-study-block-hero" "${page} should use the hero block."
  expect_pattern "$page" "case-study-block case-study-block-meta" "${page} should use the meta block."
  expect_pattern "$page" "case-study-block case-study-block-lede" "${page} should use the lede block."
  expect_pattern "$page" "case-study-recirculation" "${page} should include the shared recirculation wrapper."
  expect_pattern "$page" "work-index-case-study-block" "${page} should reuse the case-study promo block."
  expect_pattern "$page" "work-index-card" "${page} should include at least one recirculation promo."

  if rg -q --fixed-strings '<aside class="rail">' "$page"; then
    echo "FAIL: ${page} should use the lighter case-study side-nav shell instead of the legacy rail wrapper."
    exit 1
  fi

  if rg -q --fixed-strings '.work-article-visuals' "$page"; then
    echo "FAIL: ${page} should not keep the legacy visuals gallery once the block conversion lands."
    exit 1
  fi

  lede_line="$(rg -n 'case-study-block case-study-block-lede' "$page" | head -n1 | cut -d: -f1)"
  grid_line="$(rg -n '<section class=\"work-article-grid\">' "$page" | head -n1 | cut -d: -f1)"
  if [ -z "$lede_line" ] || [ -z "$grid_line" ] || [ "$lede_line" -ge "$grid_line" ]; then
    echo "FAIL: ${page} should place the lede block above the article grid."
    exit 1
  fi
done

expect_pattern "$PILOT_PAGE" "case-study-block case-study-block-two-up" "Resy pilot should use the two-up block."
expect_pattern "$PILOT_PAGE" "case-study-block case-study-block-aside-media" "Resy pilot should use the aside-media block."
expect_pattern "$PILOT_PAGE" "case-study-block case-study-block-carousel" "Resy pilot should use the carousel block."
expect_pattern "$WORK_STYLESHEET" ".case-study-story" "Work stylesheet should define the shared case-study story namespace."
expect_pattern "$WORK_STYLESHEET" ".case-study-story > .work-article-grid" "Case-study grid rule should apply only to the story grid, not recirculation grids."
expect_regex "$WORK_STYLESHEET" "\\.case-study-story \\{[[:space:][:print:]]*gap: 0;" "Story wrapper should not add extra flex gap above the first article rule."
expect_pattern "$WORK_STYLESHEET" "width: var(--case-study-hero-width);" "Hero copy should use the wider grid-based title measure."
expect_pattern "$WORK_STYLESHEET" "padding-top: 50px;" "Story grid should preserve the Figma spacing below the first horizontal rule."
expect_pattern "$WORK_STYLESHEET" "margin-top: 18px;" "Lede block should own the tightened hero-to-lede spacing once the story wrapper gap is removed."
expect_pattern "$WORK_STYLESHEET" "margin-bottom: 50px;" "Lede block should preserve the Figma spacing above the first horizontal rule."
expect_pattern "$WORK_STYLESHEET" "top: 100%;" "Full-media captions should sit tight to the image per the detached-caption design."
expect_pattern "$WORK_STYLESHEET" "margin-bottom: 24px;" "Full-media media blocks should keep the caption closer to the image."
expect_pattern "$WORK_STYLESHEET" "width: 198px;" "Full-media captions should use the narrow detached caption width from Figma."
expect_pattern "$WORK_STYLESHEET" '.case-study-block-full-media .case-study-caption::before' "Full-media captions should render the detached arrow marker."
expect_pattern "$WORK_STYLESHEET" 'background-color: var(--fg);' "Full-media caption arrows should render in white."
expect_pattern "$WORK_STYLESHEET" 'mask: url("../icons/arrow-case-study-red.svg") center / 18px 14px no-repeat;' "Full-media captions should use the shared case-study arrow asset at the larger design size."
expect_pattern "$WORK_STYLESHEET" ".work-article-body > .case-study-block-full-media + .case-study-block-text," "Text blocks after full-media should resume beside the detached caption."
expect_regex "$WORK_STYLESHEET" "\\.work-article-grid \\{[[:space:][:print:]]*align-items: start;" "Work article grid should top-align columns so the meta divider does not stretch through the full story."
expect_pattern "$WORK_STYLESHEET" ".case-study-block {" "Work stylesheet should define the base case-study block."
expect_pattern "$WORK_STYLESHEET" "--case-study-shell-width" "Work stylesheet should define the shared case-study shell width variable."
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
expect_pattern "$WORK_STYLESHEET" ".case-study-recirculation" "Work stylesheet should define the recirculation module."
expect_pattern "$MAIN_SCRIPT" '.case-study-block-carousel' "Main script should enhance case-study carousels when present."
expect_pattern "$MAIN_SCRIPT" "data-carousel-prev" "Main script should look for case-study carousel previous controls."
expect_pattern "$MAIN_SCRIPT" "data-carousel-next" "Main script should look for case-study carousel next controls."

echo "case-study block checks passed"
