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
  "design-system/index.html"
  "privacy/index.html"
  "work/index.html"
  "work/resy-discovery/index.html"
  "work/resy-search-ai/index.html"
  "work/ai-quota/index.html"
  "work/sendmoi/index.html"
)

for page in "${public_pages[@]}"; do
  [[ -f "$page" ]] || fail "Expected public page '$page' to exist."
done

[[ ! -e "work/somm-ai" ]] || fail "Legacy Somm AI slug should stay out of the public work directory."
[[ -d "drafts" ]] || fail "Expected preserved drafts framework."
[[ -f "work/sendmoi/index.html" ]] || fail "Expected published SendMoi case study."

for project in aiquota girolle resy-discovery sendmoi note-ferry parcel-scanner daily-milly niederdaily; do
  rg -q --fixed-strings "href=\"#gallery/$project\"" index.html || fail "Missing homepage gallery link for $project."
  rg -q --fixed-strings "id=\"gallery-$project\"" index.html || fail "Missing homepage gallery for $project."
done

for path in work/ai-quota/ work/sendmoi/; do
  rg -q --fixed-strings "href=\"$path\"" index.html || fail "Missing case-study link in a project gallery: $path"
done

for page in "work/resy-discovery/index.html" "work/ai-quota/index.html" "work/resy-search-ai/index.html"; do
  for token in \
    'href="../../work/sendmoi/"' \
    'id="case-study-sendmoi-title"'; do
    rg -q --fixed-strings "$token" "$page" || fail "Expected recirculation teaser token in '$page': $token"
  done

  if rg -q --fixed-strings 'id="case-study-sendmoi-status"' "$page"; then
    fail "Recirculation on '$page' should link to the live SendMoi case study."
  fi
done

for page in "work/resy-discovery/index.html" "work/ai-quota/index.html"; do
  for token in \
    'href="../../work/resy-search-ai/"' \
    'id="case-study-sommai-title"'; do
    rg -q --fixed-strings "$token" "$page" || fail "Expected live Somm AI recirculation token in '$page': $token"
  done
done

if rg -n 'href="[^"]*(drafts/work|work/somm-ai)/' "${public_pages[@]}"; then
  fail "Public pages should not link to draft or legacy case studies."
fi

echo "launch case-study surface check passed"
