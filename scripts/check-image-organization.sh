#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SOURCE_PATHS=(
  "about/index.html"
  "index.html"
  "work"
  "assets/css"
  "scripts/set-site-url.sh"
)

expect_path() {
  local path="$1"
  local message="$2"
  if [ ! -e "$path" ]; then
    echo "FAIL: $message"
    exit 1
  fi
}

expect_missing_path() {
  local path="$1"
  local message="$2"
  if [ -e "$path" ]; then
    echo "FAIL: $message"
    exit 1
  fi
}

expect_reference() {
  local pattern="$1"
  local message="$2"
  if ! rg -q "$pattern" "${SOURCE_PATHS[@]}"; then
    echo "FAIL: $message"
    exit 1
  fi
}

expect_no_reference() {
  local pattern="$1"
  local message="$2"
  if rg -q "$pattern" "${SOURCE_PATHS[@]}"; then
    echo "FAIL: $message"
    exit 1
  fi
}

expect_path "assets/images/about" "Expected assets/images/about to exist."
expect_path "assets/images/og" "Expected assets/images/og to exist."
expect_path "assets/images/case-studies/resy-discovery/article" "Expected resy-discovery article assets."
expect_path "assets/images/case-studies/resy-discovery/promo" "Expected resy-discovery promo assets."
expect_path "assets/images/case-studies/somm-ai/article" "Expected somm-ai article assets."
expect_path "assets/images/case-studies/somm-ai/promo" "Expected somm-ai promo assets."
expect_path "assets/images/case-studies/ai-quota/article" "Expected ai-quota article assets."
expect_path "assets/images/case-studies/ai-quota/promo" "Expected ai-quota promo assets."
expect_path "assets/images/case-studies/sendmoi/article" "Expected sendmoi article assets."
expect_path "assets/images/case-studies/sendmoi/promo" "Expected sendmoi promo assets."

expect_missing_path "assets/images/home" "Old home image bucket should be removed."
expect_missing_path "assets/images/sendmoi" "Legacy sendmoi root should be removed."
expect_missing_path "assets/images/share" "Legacy share bucket should be removed."
expect_missing_path "assets/images/work" "Legacy work image bucket should be removed."

expect_reference 'assets/images/about/' "Expected at least one about image reference."
expect_reference 'assets/images/og/' "Expected OG image references."
expect_reference 'assets/images/case-studies/resy-discovery/article/' "Expected resy-discovery article references."
expect_reference 'assets/images/case-studies/resy-discovery/promo/' "Expected resy-discovery promo references."
expect_reference 'assets/images/case-studies/somm-ai/article/' "Expected somm-ai article references."
expect_reference 'assets/images/case-studies/somm-ai/promo/' "Expected somm-ai promo references."
expect_reference 'assets/images/case-studies/ai-quota/article/' "Expected ai-quota article references."
expect_reference 'assets/images/case-studies/ai-quota/promo/' "Expected ai-quota promo references."
expect_reference 'assets/images/case-studies/sendmoi/article/' "Expected sendmoi article references."
expect_reference 'assets/images/case-studies/sendmoi/promo/' "Expected sendmoi promo references."

expect_no_reference 'assets/images/home/' "Old home image references should be gone."
expect_no_reference 'assets/images/sendmoi/' "Legacy sendmoi references should be gone."
expect_no_reference 'assets/images/share/' "Legacy share references should be gone."
expect_no_reference 'assets/images/work/' "Legacy work references should be gone."

echo "image organization checks passed"
