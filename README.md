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
