# Handoff

## Branch
- `codex/fix-gh-issue-quoting`

## Last Pushed
- `265552a` `Merge pull request #9 from niederme/codex/make-hostname-open-fix`
- `be9e2ab` `Fix dev auto-open host detection across Macs`
- `4898fd4` `Merge pull request #7 from niederme/codex/work-experience-feature`

## Current Focus
- Fix first-attempt `gh issue create` failures caused by shell quoting and backtick substitution in `zsh`.
- Keep an explicit, repeatable issue-creation path that preserves Markdown as-is.

## What Changed
- Created tracking issue: [#10](https://github.com/niederme/nieder.me/issues/10) `Fix shell quoting for gh issue create with Markdown backticks`.
- Added `scripts/create-gh-issue.sh`:
  - requires `--title`
  - supports `--body-file`
  - supports piped stdin (captured to temp file)
  - always uses `--body-file` when body text is provided
- Added `make issue-create` with:
  - required `ISSUE_TITLE`
  - optional `ISSUE_BODY_FILE`
- Updated `README.md` with `GitHub issue workflow` examples for file/stdin usage.

## Investigation Notes
- Root cause reproduced with `zsh` command substitution on backticks inside double-quoted inline body text.
- Wrapper approach validated: avoids inline `--body "..."` interpolation and preserves literal Markdown backticks.
- Accidental validation issue `#11` was created during testing and immediately closed.

## Open Items
- Merge PR `#12` after conflict resolution.
- Use `make issue-create ...` for future issue creation to avoid shell quoting pitfalls.

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
5. Use `make issue-create ...` for new issue creation
