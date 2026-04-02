#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

HOME_STYLESHEET="assets/css/styles.css"
SUBPAGE_STYLESHEET="assets/css/work-case-study.css"

expect_pcre() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q -U -P -- "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

check_stylesheet() {
  local file="$1"

  expect_pcre \
    "$file" \
    '(?s)@media \(min-width: 1101px\) \{.*?\.site-footer-column-work \.site-footer-links \{.*?grid-template-rows: repeat\(3, auto\);.*?grid-auto-flow: column;.*?column-gap: 36px;.*?row-gap: 8px;.*?\}.*?\}' \
    "${file} should split the footer work links into two desktop columns."
}

check_stylesheet "$HOME_STYLESHEET"
check_stylesheet "$SUBPAGE_STYLESHEET"

echo "footer work column checks passed"
