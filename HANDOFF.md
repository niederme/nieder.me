# Handoff

## Branch
- `codex/fix-gh-issue-quoting`

## Last Pushed
- `4898fd4` `Merge pull request #7 from niederme/codex/work-experience-feature`
- `7c506d9` `Pivot homepage to Work Experience-first architecture`
- `0d2d949` `Merge pull request #4 from niederme/codex/css-grid-toggle-pr`

## Current Focus
- Fix first-attempt `gh issue create` failures caused by shell quoting and backtick substitution in `zsh`.
- Provide a repeatable local workflow for creating GitHub issues with Markdown safely.

## What Changed
- Created tracking issue: [#10](https://github.com/niederme/nieder.me/issues/10) `Fix shell quoting for gh issue create with Markdown backticks`.
- Added `scripts/create-gh-issue.sh`:
  - requires `--title`
  - accepts `--body-file`
  - accepts piped stdin and writes it to a temp file
  - always calls `gh issue create` with `--body-file` when body content is provided
- Added `make issue-create` target with:
  - `ISSUE_TITLE` required
  - optional `ISSUE_BODY_FILE`
- Updated `README.md` with a new `GitHub issue workflow` section showing safe file/stdin usage for Markdown containing backticks.

## Investigation Notes
- Reproduced root cause:
  - `zsh -lc 'echo "Use \`code\` formatting in body"'` triggers command substitution for `` `code` ``, which can fail before `gh` receives the intended text.
- Confirmed the wrapper approach avoids this by bypassing inline `--body "..."` shell interpolation.
- Accidental validation issue `#11` was created during testing and immediately closed.

## Open Items
- Run the new flow against a real issue body as needed:
  - `make issue-create ISSUE_TITLE="..." ISSUE_BODY_FILE=/tmp/issue.md`
- If desired, add a PR checklist item to prefer `--body-file` over inline `--body`.

## Local Run
- Create issue from file:
  - `make issue-create ISSUE_TITLE="Fix shell quoting" ISSUE_BODY_FILE=/tmp/issue.md`
- Create issue from stdin:
  - `cat /tmp/issue.md | ./scripts/create-gh-issue.sh --title "Fix shell quoting"`

## Resume Checklist
1. `git fetch --all`
2. `git checkout codex/fix-gh-issue-quoting`
3. `git pull --ff-only`
4. Review issue context in [#10](https://github.com/niederme/nieder.me/issues/10)
5. Use `make issue-create ...` for new issue creation to avoid shell quoting pitfalls
