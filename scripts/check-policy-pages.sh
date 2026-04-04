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

echo "Policy pages and footer utility links look good."
