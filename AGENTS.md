# Repository Instructions

## Preview workflow

- This repo reserves `8000` as the default preview port.
- Worktree previews start at `8001` and auto-increment upward when needed.
- Project worktrees should live under repo-local `.worktrees/`.
- Preview commands in this repo use the shared Codex helper at `/Users/niederme/.codex/bin/codex-preview-env`.
- The canonical global convention lives at `/Users/niederme/.codex/docs/web-preview-convention.md`.

## Development workflow

- Do not develop on `main` unless explicitly asked.
- Prefer a dedicated `codex/*` branch per task.
- For parallel work, prefer a repo-local worktree under `.worktrees/`.
- When you change rendered site files, start or reuse a preview and include the exact URL when reporting the work.
