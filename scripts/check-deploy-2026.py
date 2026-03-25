#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
DEPLOY_SCRIPT = ROOT / "scripts" / "deploy-2026.sh"

contents = DEPLOY_SCRIPT.read_text()

required_tokens = [
    'if [[ -d about ]]; then',
    'cp -R about "$STAGING_DIR/"',
    'if [[ -d colophon ]]; then',
    'cp -R colophon "$STAGING_DIR/"',
    'if [[ -d "$STAGING_DIR/about" ]]; then',
    'SYNC_PATHS+=("$STAGING_DIR/about")',
    'if [[ -d "$STAGING_DIR/colophon" ]]; then',
    'SYNC_PATHS+=("$STAGING_DIR/colophon")',
]

for token in required_tokens:
    if token not in contents:
        print(f"missing expected deploy token: {token}")
        sys.exit(1)

for forbidden in [
    'if [[ -d sendmoi ]]; then',
    'cp -R sendmoi "$STAGING_DIR/"',
    'if [[ -d "$STAGING_DIR/sendmoi" ]]; then',
    'SYNC_PATHS+=("$STAGING_DIR/sendmoi")',
]:
    if forbidden in contents:
        print(f"stale deploy token still present: {forbidden}")
        sys.exit(1)

print("deploy-2026 verifier passed")
