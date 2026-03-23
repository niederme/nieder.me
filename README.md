# nieder.me

Static portfolio site for John Niedermeyer. This repo holds the 2026 homepage, work index, case-study pages, shared assets, and lightweight local-preview/deploy tooling.

## What is in this repo

Current site surfaces:

- `/` homepage with work highlights, About, and Colophon sections
- `/work/` full work experience and resume page
- `/work/resy-discovery/` Resy case study
- `/work/sendmoi/` SendMoi case study
- `/work/somm-ai/` Somm AI case study
- `/work/ai-quota/` AIQuota case study
- `/styleguide/` working foundations page for typography, color, spacing, and patterns

Core project files:

- `index.html` homepage entry point
- `work/**/*.html` work index and case-study pages
- `styleguide/index.html` style guide page
- `assets/css/styles.css` homepage and shared site styles
- `assets/css/work-case-study.css` work index and case-study styles
- `assets/js/main.js` shared client-side behavior
- `assets/` images, icons, fonts, and video
- `scripts/` local helpers for deploy and GitHub issue creation
- `Makefile` preview, live-reload, and helper commands

## Local dev

From the repo root:

```bash
make
```

That starts a static server on all interfaces (`0.0.0.0`), opens the site locally, and prints:

- a `.local` URL for this Mac
- a LAN URL for other devices on the same network

Default port is `7777`. If that port is already in use, `make dev` automatically picks the next available port.

Use a custom port when needed:

```bash
make dev PORT=8080
```

Localhost-only preview:

```bash
make dev-local
```

Worktree-friendly preview:

```bash
make dev-thread
```

`make dev-thread` starts from `7778` so the main checkout can keep `7777`.

## Live reload

Add `LIVE=1` to any preview target to use BrowserSync instead of the plain static server:

```bash
make dev LIVE=1
make dev-thread LIVE=1
make dev-local LIVE=1
```

Compatibility aliases:

```bash
make dev-live
make dev-live-thread
```

Live reload currently watches:

- `index.html`
- `work/**/*.html`
- `assets/css/**/*.css`
- `assets/js/**/*.js`

Requirements for live reload:

- Node.js with `npx` available
- a Node runtime that supports `node:path`
- recommended local version: Node 20

## Development workflow

Before editing:

```bash
git branch --show-current
```

Repo convention:

- do not develop on `main`
- prefer a dedicated feature branch
- for parallel threads, prefer a dedicated `git worktree`
- when working on rendered site changes, start or reuse a local preview and note the exact URL

Example branch:

```bash
git switch -c codex/my-feature
```

Example worktree:

```bash
git worktree add ../nieder-me-my-feature -b codex/my-feature
```

## Deploy

Primary deploy target is the `/2026` site:

```bash
./scripts/deploy-2026.sh
```

The deploy script:

- stages a temporary copy of `index.html` and `assets/`
- includes `work/` when present
- rewrites the staged homepage site URL
- cache-busts staged homepage CSS and JS asset URLs
- syncs only the managed staged paths to the remote target

Important default deploy settings live inside `scripts/deploy-2026.sh` and can be overridden with environment variables:

- `DEPLOY_HOST`
- `DEPLOY_USER`
- `DEPLOY_PATH`
- `DEPLOY_PORT`
- `DRY_RUN=1`
- `SITE_URL`

Site URL helpers:

```bash
make site-url-stage
make site-url-prod
```

## GitHub issue helper

To avoid shell-quoting problems with Markdown-heavy issue bodies:

```bash
make issue-create ISSUE_TITLE="Fix shell quoting" ISSUE_BODY_FILE=/tmp/issue.md
```

Or use stdin directly:

```bash
cat <<'EOF' | ./scripts/create-gh-issue.sh --title "Fix shell quoting"
Use `code` formatting safely in Markdown without zsh command substitution.
EOF
```

This helper requires the GitHub CLI (`gh`) to be installed and authenticated.

## Notes

- The site defaults to dark mode and includes a persistent manual `light` toggle.
- Shared rail navigation and the column-grid toggle are used across the homepage and work pages.
- The README should describe the current repo shape and workflows, not act as a running change log. If a feature ships, update the relevant section above instead of appending historical bullets.
