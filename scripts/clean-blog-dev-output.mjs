#!/usr/bin/env node
// Removes only the 11ty live-preview output. Keep this separate from the build
// scratch dir so `npm run build` cannot delete an active `make dev-blog` server.
import { rm } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join, resolve } from "node:path";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const target = join(ROOT, ".eleventy-dev");

await rm(target, { recursive: true, force: true });
console.log("Cleaned blog preview output: .eleventy-dev");
