# nieder.me

Static portfolio site for John Niedermeyer. This repo holds the 2026 homepage, work index, case-study pages, shared assets, and lightweight local-preview/deploy tooling.

Preview commands in this repo use the shared Codex helper at `/Users/niederme/.codex/bin/codex-preview-env` for hostname resolution, LAN URL discovery, and next-open-port selection. The canonical global convention lives at `/Users/niederme/.codex/docs/web-preview-convention.md`.

## What is in this repo

Current site surfaces:

- `/` homepage with work highlights and a short About section
- `/about/` full biography page
- `/colophon/` standalone colophon page
- `/accessibility/` accessibility statement
- `/privacy/` privacy notice
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

Default port is `8000`. If that port is already in use, `make dev` automatically picks the next available port.

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

`make dev-thread` starts from `8001` so the main checkout can keep `8000`.

Project worktrees should live under repo-local `.worktrees/`.

## Live reload

Use `make dev-live` for the standard live-reload preview. The underlying switch is `LIVE=1`, which is also available for the thread and local-only variants:

```bash
make dev-live
make dev-live-thread
make dev-local LIVE=1
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

Merging to `main` triggers the GitHub Actions deploy workflow automatically. The workflow:

- installs `lightningcss` and `terser` and minifies all CSS and JS with source maps
- syncs the managed site files to the server over SSH using the `SSH_PRIVATE_KEY` secret

For manual or local deploys, use the shell script directly:

```bash
./scripts/deploy-2026.sh
```

The script:

- stages a temporary copy of `index.html` and `assets/`
- includes allowlisted top-level sections when present
- rewrites the staged homepage site URL
- cache-busts staged CSS and JS asset URLs across all HTML files
- syncs only managed paths to the remote target
- is checked by `scripts/check-deploy-2026.py`, which fails if a top-level section exists but is missing from the allowlist

Default settings in `scripts/deploy-2026.sh` can be overridden with environment variables:

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
- Shared rail navigation and the column-grid toggle are used across the homepage, About, Colophon, and work pages.
- The README should describe the current repo shape and workflows, not act as a running change log. If a feature ships, update the relevant section above instead of appending historical bullets.
