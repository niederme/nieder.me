#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

failures=0

expect_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if ! rg -q --fixed-strings "$pattern" "$file"; then
    echo "FAIL: $message"
    failures=1
  fi
}

reject_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if rg -q --fixed-strings "$pattern" "$file"; then
    echo "FAIL: $message"
    failures=1
  fi
}

expect_pattern "assets/css/styles.css" ".text-link," "Homepage styles should expose the shared text-link helper."
expect_pattern "assets/css/styles.css" ".topper-company-link," "Homepage company links should use the shared text-link treatment."
expect_pattern "assets/css/styles.css" ".experience-bullets a {" "Homepage experience bullets should use the shared text-link treatment."
expect_pattern "assets/css/styles.css" "text-decoration-color: transparent;" "Homepage text links should hide underline until interaction."
reject_pattern "assets/css/styles.css" ".topper-company-link:focus-visible {" "Homepage company links should no longer use a one-off focus-only underline rule."
reject_pattern "assets/css/styles.css" ".experience-item .experience-company a:focus-visible {" "Homepage experience company links should no longer use a one-off focus-only underline rule."

expect_pattern "assets/css/work-case-study.css" ".text-link," "Work styles should expose the shared text-link helper."
expect_pattern "assets/css/work-case-study.css" ".resume-inline-link," "Resume inline links should use the shared text-link treatment."
expect_pattern "assets/css/work-case-study.css" ".resume-company a," "Workplace/company links should use the shared text-link treatment on /work."
expect_pattern "assets/css/work-case-study.css" ".work-article-body a {" "Case-study body links should use the shared text-link treatment."
expect_pattern "assets/css/work-case-study.css" "text-decoration-color: transparent;" "Work text links should hide underline until interaction."
reject_pattern "assets/css/work-case-study.css" ".resume-company a:visited {" "Workplace/company links on /work should not keep a separate one-off visited rule."

expect_pattern "assets/css/styleguide.css" ".styleguide-element-body a {" "Styleguide body links should document the shared text-link treatment."
expect_pattern "assets/css/styleguide.css" "text-decoration-color: transparent;" "Styleguide examples should match the production text-link behavior."

if [ "$failures" -ne 0 ]; then
  exit 1
fi

echo "Text link audit passed."
