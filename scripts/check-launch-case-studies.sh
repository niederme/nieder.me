#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

public_pages=(
  "index.html"
  "about/index.html"
  "accessibility/index.html"
  "colophon-style-guide/index.html"
  "privacy/index.html"
  "work/index.html"
  "work/resy-discovery/index.html"
  "work/ai-quota/index.html"
)

for page in "${public_pages[@]}"; do
  [[ -f "$page" ]] || fail "Expected public page '$page' to exist."
done

[[ ! -e "work/sendmoi" ]] || fail "SendMoi should stay out of the public work directory."
[[ ! -e "work/somm-ai" ]] || fail "Somm AI should stay out of the public work directory."
[[ -f "drafts/work/sendmoi/index.html" ]] || fail "Expected preserved SendMoi draft."
[[ -f "drafts/work/somm-ai/index.html" ]] || fail "Expected preserved Somm AI draft."

for token in \
  'id="case-study-sendmoi"' \
  'id="case-study-sommai"' \
  'class="case-study-promo case-study-promo-sendmoi is-disabled"' \
  'class="case-study-promo case-study-promo-sommai is-disabled"'; do
  rg -q --fixed-strings "$token" index.html || fail "Expected homepage teaser token: $token"
done

for token in \
  'id="work-index-sendmoi-title"' \
  'id="work-index-sommai-title"' \
  'class="work-index-card is-disabled"'; do
  rg -q --fixed-strings "$token" work/index.html || fail "Expected work-index teaser token: $token"
done

for page in "work/resy-discovery/index.html" "work/ai-quota/index.html"; do
  for token in \
    'id="case-study-sendmoi-title"' \
    'id="case-study-sommai-title"' \
    'class="work-index-card is-disabled"'; do
    rg -q --fixed-strings "$token" "$page" || fail "Expected recirculation teaser token in '$page': $token"
  done
done

if rg -n 'href="[^"]*work/(sendmoi|somm-ai)/' "${public_pages[@]}"; then
  fail "Public pages should not link to draft case studies."
fi

echo "launch case-study surface check passed"
