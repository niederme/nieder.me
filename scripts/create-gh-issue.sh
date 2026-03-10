#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat <<'EOF'
Usage:
  scripts/create-gh-issue.sh --title "Issue title" [--body-file path] [--repo owner/name]
  cat body.md | scripts/create-gh-issue.sh --title "Issue title"

Notes:
  - Prefer --body-file or stdin over inline --body text to avoid shell quoting issues.
  - If neither --body-file nor stdin is provided, gh will open its editor flow.
EOF
}

title=""
body_file=""
repo=""

while [[ $# -gt 0 ]]; do
	case "$1" in
	--title)
		shift
		title="${1:-}"
		;;
	--body-file)
		shift
		body_file="${1:-}"
		;;
	--repo)
		shift
		repo="${1:-}"
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "Unknown argument: $1" >&2
		usage >&2
		exit 1
		;;
	esac
	shift || true
done

if [[ -z "$title" ]]; then
	echo "--title is required" >&2
	usage >&2
	exit 1
fi

cmd=(gh issue create --title "$title")

cleanup_file=""
if [[ -n "$repo" ]]; then
	cmd+=(--repo "$repo")
fi

if [[ -n "$body_file" ]]; then
	if [[ ! -f "$body_file" ]]; then
		echo "Body file does not exist: $body_file" >&2
		exit 1
	fi
	cmd+=(--body-file "$body_file")
elif [[ ! -t 0 ]]; then
	cleanup_file="$(mktemp)"
	cat >"$cleanup_file"
	if [[ -s "$cleanup_file" ]]; then
		cmd+=(--body-file "$cleanup_file")
	fi
fi

trap '[[ -n "$cleanup_file" && -f "$cleanup_file" ]] && rm -f "$cleanup_file"' EXIT

"${cmd[@]}"
