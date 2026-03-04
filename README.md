# nieder.me

## Local dev

Run this from the repo root:

```bash
make
```

That starts a static server on all interfaces (`0.0.0.0`), prints:
- `http://<this-mac>.local:8000` for this Mac (for example `http://niederbook-air-m4.local:8000`)
- a LAN URL like `http://192.168.x.x:8000` for other devices on the same network (for example, Niederstudio)

It also opens the `.local` URL on this Mac.

If port `8000` is already in use, `make dev` automatically picks the next available port and prints the exact URLs.

Use a different port if needed:

```bash
make dev PORT=8080
```

`make dev-lan` is available as an alias of `make dev`.

## Local-only mode

Run:

```bash
make dev-local
```

That binds to localhost only.

`make dev-local` also auto-selects the next available port when the requested one is already in use.

## Current mobile behavior

- The homepage includes a mobile-specific case-study nav that appears after the topper and tracks the active section.
- The mobile topper and case-study stack now use responsive width rules between narrower and wider phone viewports instead of a fixed 375px-only layout.
- The mobile horizontal scrollers no longer force `pan-x` only, which reduces vertical scroll lock/jumping during touch interactions.
- CSS and JS assets use cache-busting query params in `index.html`; if Safari looks stale after changes, do a hard refresh.
