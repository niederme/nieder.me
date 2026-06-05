#!/usr/bin/env python3
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import argparse
import os


class SiteRequestHandler(SimpleHTTPRequestHandler):
    def send_head(self):
        translated_path = Path(self.translate_path(self.path))
        if not translated_path.exists():
            return self.send_site_404()

        return super().send_head()

    def send_site_404(self):
        error_path = Path(os.getcwd()) / "404.html"
        if not error_path.is_file():
            self.send_error(404, "File not found")
            return None

        body = error_path.read_bytes()
        self.send_response(404)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()

        if self.command != "HEAD":
            self.wfile.write(body)

        return None


def main():
    parser = argparse.ArgumentParser(description="Serve the static site with project 404 fallback.")
    parser.add_argument("port", type=int)
    parser.add_argument("--bind", default="0.0.0.0")
    args = parser.parse_args()

    server = ThreadingHTTPServer((args.bind, args.port), SiteRequestHandler)
    print(f"Serving HTTP on {args.bind} port {args.port} (http://{args.bind}:{args.port}/) ...", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
