#!/usr/bin/env node
// Places the generated blog artifacts from the gitignored _site/ scratch dir
// into the repo root, where the existing deploy pipeline expects them.
import { cp, rm, access } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, join, resolve } from "node:path";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const SITE = join(ROOT, "_site");

const ARTIFACTS = ["blog", "admin", "feed.xml"];

async function exists(p) {
  try {
    await access(p);
    return true;
  } catch {
    return false;
  }
}

for (const entry of ARTIFACTS) {
  const from = join(SITE, entry);
  const to = join(ROOT, entry);
  if (!(await exists(from))) continue;
  await rm(to, { recursive: true, force: true });
  await cp(from, to, { recursive: true });
}

await rm(SITE, { recursive: true, force: true });
console.log(`Placed blog output at repo root: ${ARTIFACTS.join(", ")}`);
