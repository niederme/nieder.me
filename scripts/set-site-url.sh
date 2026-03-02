#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <site-url>" >&2
  exit 1
fi

site_url="${1%/}"
page_url="${site_url}/"
image_url="${site_url}/assets/images/share/og-image-1200x630.png"

perl -0pi -e "s#<link rel=\"canonical\" href=\"[^\"]*\" />#<link rel=\"canonical\" href=\"${page_url}\" />#g" index.html
perl -0pi -e "s#<meta property=\"og:url\" content=\"[^\"]*\" />#<meta property=\"og:url\" content=\"${page_url}\" />#g" index.html
perl -0pi -e "s#<meta property=\"og:image\" content=\"[^\"]*\" />#<meta property=\"og:image\" content=\"${image_url}\" />#g" index.html
perl -0pi -e "s#<meta property=\"og:image:secure_url\" content=\"[^\"]*\" />#<meta property=\"og:image:secure_url\" content=\"${image_url}\" />#g" index.html
perl -0pi -e "s#<meta name=\"twitter:url\" content=\"[^\"]*\" />#<meta name=\"twitter:url\" content=\"${page_url}\" />#g" index.html
perl -0pi -e "s#<meta name=\"twitter:image\" content=\"[^\"]*\" />#<meta name=\"twitter:image\" content=\"${image_url}\" />#g" index.html

echo "Updated index.html metadata for ${page_url}"
