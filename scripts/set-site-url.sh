#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <site-url> [html-file]" >&2
  exit 1
fi

site_url="${1%/}"
html_file="${2:-index.html}"
page_url="${site_url}/"
image_url="${site_url}/assets/images/og/og-image-1200x630.png"

perl -0pi -e "s#<link rel=\"canonical\" href=\"[^\"]*\" />#<link rel=\"canonical\" href=\"${page_url}\" />#g" "$html_file"
perl -0pi -e "s#<meta property=\"og:url\" content=\"[^\"]*\" />#<meta property=\"og:url\" content=\"${page_url}\" />#g" "$html_file"
perl -0pi -e "s#<meta property=\"og:image\" content=\"[^\"]*\" />#<meta property=\"og:image\" content=\"${image_url}\" />#g" "$html_file"
perl -0pi -e "s#<meta property=\"og:image:secure_url\" content=\"[^\"]*\" />#<meta property=\"og:image:secure_url\" content=\"${image_url}\" />#g" "$html_file"
perl -0pi -e "s#<meta name=\"twitter:url\" content=\"[^\"]*\" />#<meta name=\"twitter:url\" content=\"${page_url}\" />#g" "$html_file"
perl -0pi -e "s#<meta name=\"twitter:image\" content=\"[^\"]*\" />#<meta name=\"twitter:image\" content=\"${image_url}\" />#g" "$html_file"

echo "Updated ${html_file} metadata for ${page_url}"
