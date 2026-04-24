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
  "work/resy-search-ai/index.html"
  "work/ai-quota/index.html"
)

for page in "${public_pages[@]}"; do
  [[ -f "$page" ]] || fail "Expected public page '$page' to exist."
done

[[ ! -e "work/sendmoi" ]] || fail "SendMoi should stay out of the public work directory."
[[ ! -e "work/somm-ai" ]] || fail "Legacy Somm AI slug should stay out of the public work directory."
[[ -f "drafts/work/sendmoi/index.html" ]] || fail "Expected preserved SendMoi draft."

for token in \
  'id="case-study-sendmoi"' \
  'class="case-study-promo case-study-promo-sendmoi is-disabled"' \
  'id="case-study-sommai"' \
  'href="work/resy-search-ai/"'; do
  rg -q --fixed-strings "$token" index.html || fail "Expected homepage teaser token: $token"
done

if rg -q --fixed-strings 'class="case-study-promo case-study-promo-sommai is-disabled"' index.html; then
  fail "Homepage Somm AI promo should be live, not disabled."
fi

for token in \
  'href="../work/resy-search-ai/"' \
  'id="work-index-sendmoi-title"' \
  'id="work-index-sommai-title"' \
  'class="work-index-card is-disabled"'; do
  rg -q --fixed-strings "$token" work/index.html || fail "Expected work-index teaser token: $token"
done

if rg -q --fixed-strings 'id="work-index-sommai-status"' work/index.html; then
  fail "Work index Somm AI card should be live, not marked Coming Soon."
fi

for page in "work/resy-discovery/index.html" "work/ai-quota/index.html"; do
  for token in \
    'href="../../work/resy-search-ai/"' \
    'id="case-study-sendmoi-title"' \
    'id="case-study-sommai-title"' \
    'class="work-index-card is-disabled"'; do
    rg -q --fixed-strings "$token" "$page" || fail "Expected recirculation teaser token in '$page': $token"
  done

  if rg -q --fixed-strings 'id="case-study-sommai-status"' "$page"; then
    fail "Recirculation on '$page' should link to the live Somm AI case study."
  fi
done

if rg -n 'href="[^"]*work/(sendmoi|somm-ai)/' "${public_pages[@]}"; then
  fail "Public pages should not link to draft case studies."
fi

echo "launch case-study surface check passed"
