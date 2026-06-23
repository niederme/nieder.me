#!/usr/bin/env node
// Removes only the generated blog build artifacts so a rebuild starts clean.
// Must never touch hand-authored source (work/, assets/, root pages) or 11ty
// source folders (content/, blog-source/, cms/).
import { rm } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join, resolve } from "node:path";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");

const GENERATED = ["blog", "admin", "feed.xml", "_site"];

for (const entry of GENERATED) {
  const target = join(ROOT, entry);
  await rm(target, { recursive: true, force: true });
}

console.log(`Cleaned generated blog output: ${GENERATED.join(", ")}`);
