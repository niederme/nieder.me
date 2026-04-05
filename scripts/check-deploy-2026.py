#!/usr/bin/env python3
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
DEPLOY_SCRIPT = ROOT / "scripts" / "deploy-2026.sh"

contents = DEPLOY_SCRIPT.read_text()
public_dirs = sorted(path.parent.name for path in ROOT.glob("*/index.html"))

required_tokens = [
    'cp index.html "$STAGING_DIR/"',
    'cp -R assets "$STAGING_DIR/"',
    'PUBLIC_DIRS=(',
    'for dir in "${PUBLIC_DIRS[@]}"; do',
    'if [[ -d "$dir" ]]; then',
    'cp -R "$dir" "$STAGING_DIR/"',
    'if [[ -d "$STAGING_DIR/$dir" ]]; then',
    'SYNC_PATHS+=("$STAGING_DIR/$dir")',
]

for token in required_tokens:
    if token not in contents:
        print(f"missing expected deploy token: {token}")
        sys.exit(1)

match = re.search(r"PUBLIC_DIRS=\(\n(?P<body>.*?)\n\)", contents, re.DOTALL)
if not match:
    print("missing PUBLIC_DIRS block in deploy script")
    sys.exit(1)

listed_dirs = []
for line in match.group("body").splitlines():
    stripped = line.strip()
    if not stripped or stripped.startswith("#"):
        continue
    listed_dirs.append(stripped)

listed_set = set(listed_dirs)
public_set = set(public_dirs)

missing_dirs = sorted(public_set - listed_set)
extra_dirs = sorted(listed_set - public_set)

if missing_dirs:
    print("deploy allowlist is missing top-level public directories:")
    for directory in missing_dirs:
        print(f"- {directory}")
    sys.exit(1)

if extra_dirs:
    print("deploy allowlist includes directories that are not top-level public pages:")
    for directory in extra_dirs:
        print(f"- {directory}")
    sys.exit(1)

print("deploy-2026 verifier passed")
