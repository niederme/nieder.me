#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

expect_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "Expected file '$path' to exist."
}

expect_pattern() {
  local path="$1"
  local pattern="$2"
  local message="$3"
  grep -q "$pattern" "$path" || fail "$message"
}

expect_file "accessibility/index.html"
expect_file "privacy/index.html"
expect_file "assets/css/work-case-study.css"

policy_pages=(
  "accessibility/index.html"
  "privacy/index.html"
)

home_pages=(
  "index.html"
)

one_level_pages=(
  "about/index.html"
  "colophon/index.html"
  "work/index.html"
  "styleguide/index.html"
  "accessibility/index.html"
  "privacy/index.html"
)

two_level_pages=(
  "work/resy-discovery/index.html"
  "work/sendmoi/index.html"
  "work/somm-ai/index.html"
  "work/ai-quota/index.html"
)

for page in "${home_pages[@]}"; do
  expect_pattern "$page" "site-footer-utility-links" "Expected footer utility links in '$page'."
  expect_pattern "$page" 'href="accessibility/"' "Expected '$page' to link to accessibility/."
  expect_pattern "$page" 'href="privacy/"' "Expected '$page' to link to privacy/."
done

for page in "${one_level_pages[@]}"; do
  expect_pattern "$page" "site-footer-utility-links" "Expected footer utility links in '$page'."
  expect_pattern "$page" 'href="../accessibility/"' "Expected '$page' to link to ../accessibility/."
  expect_pattern "$page" 'href="../privacy/"' "Expected '$page' to link to ../privacy/."
done

for page in "${two_level_pages[@]}"; do
  expect_pattern "$page" "site-footer-utility-links" "Expected footer utility links in '$page'."
  expect_pattern "$page" 'href="../../accessibility/"' "Expected '$page' to link to ../../accessibility/."
  expect_pattern "$page" 'href="../../privacy/"' "Expected '$page' to link to ../../privacy/."
done

for page in "${policy_pages[@]}"; do
  expect_pattern "$page" 'class="[^"]*policy-page' "Expected '$page' to opt into the policy-page layout."
  expect_pattern "$page" 'work-article-meta case-study-block case-study-block-meta' \
    "Expected '$page' to use the case-study-style metadata rail."
  expect_pattern "$page" 'case-study-block-inner' \
    "Expected '$page' to wrap policy metadata in the case-study inner container."
done

expect_pattern "assets/css/work-case-study.css" '.policy-page .work-article-meta {' \
  "Expected policy pages to scope the narrower metadata rail in work-case-study.css."
expect_pattern "assets/css/work-case-study.css" '.policy-page .work-article-grid {' \
  "Expected policy pages to add the case-study-style top rule and spacing in work-case-study.css."
expect_pattern "assets/css/work-case-study.css" '.policy-page .work-article-body {' \
  "Expected policy pages to scope the matching article-body alignment in work-case-study.css."

echo "Policy pages and footer utility links look good."
