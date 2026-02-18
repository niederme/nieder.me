# nieder.me

## Local dev

Run this from the repo root:

```bash
make
```

That starts a static server on your local network and prints a URL like `http://192.168.x.x:8000` for other devices. It also opens `http://localhost:8000` on your Mac.

Use a different port if needed:

```bash
make dev PORT=8080
```

## Local-only mode

Run:

```bash
make dev-local
```

That binds to localhost only.
