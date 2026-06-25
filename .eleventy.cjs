const fs = require("node:fs");
const path = require("node:path");
const { feedPlugin } = require("@11ty/eleventy-plugin-rss");
const markdownItAttrs = require("markdown-it-attrs");

const ROOT = __dirname;
const PROD_URL = "https://nieder.me";

// Environment-aware base. Staging default matches the rest of the repo.
function siteUrl() {
  return (process.env.SITE_URL || "https://nieder.me/2026").replace(/\/+$/, "");
}

function absUrl(p) {
  if (!p) return siteUrl() + "/";
  if (/^https?:\/\//.test(p)) return p;
  return siteUrl() + "/" + String(p).replace(/^\/+/, "");
}

// Read intrinsic pixel dimensions + mime for a local PNG/JPEG, mirroring the
// logic in scripts/check-social-metadata.py so emitted og:image metadata always
// matches the real file.
function imageMeta(rootRelativePath) {
  const clean = String(rootRelativePath).replace(/^\/+/, "");
  const filePath = path.join(ROOT, clean);
  const data = fs.readFileSync(filePath);

  if (data.slice(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) {
    return { width: data.readUInt32BE(16), height: data.readUInt32BE(20), type: "image/png" };
  }
  if (data[0] === 0xff && data[1] === 0xd8) {
    let i = 2;
    while (i < data.length) {
      if (data[i] !== 0xff) { i += 1; continue; }
      const marker = data[i + 1];
      i += 2;
      if (marker === 0xd8 || marker === 0xd9) continue;
      const len = data.readUInt16BE(i);
      const isSOF =
        (marker >= 0xc0 && marker <= 0xc3) ||
        (marker >= 0xc5 && marker <= 0xc7) ||
        (marker >= 0xc9 && marker <= 0xcb) ||
        (marker >= 0xcd && marker <= 0xcf);
      if (isSOF) {
        const height = data.readUInt16BE(i + 3);
        const width = data.readUInt16BE(i + 5);
        return { width, height, type: "image/jpeg" };
      }
      i += len;
    }
  }
  throw new Error(`Unsupported social image format (PNG/JPEG only): ${clean}`);
}

module.exports = function (eleventyConfig) {
  const includeDrafts = Boolean(process.env.ELEVENTY_INCLUDE_DRAFTS);

  // Sveltia admin config ships next to the admin page.
  eleventyConfig.addPassthroughCopy({ "cms/config.yml": "admin/config.yml" });

  // Eleventy serves from _site during `make dev-blog`; copy the hand-authored
  // static shell so blog previews can load the same CSS, icons, and linked pages.
  for (const entry of [
    "assets",
    "about",
    "accessibility",
    "design-system",
    "privacy",
    "work",
    "index.html",
    "404.html",
    "apple-touch-icon-precomposed.png",
    "apple-touch-icon.png",
    "favicon.ico",
    "favicon.png",
    "llms.txt",
    "robots.txt",
  ]) {
    eleventyConfig.addPassthroughCopy(entry);
  }

  // Rebuild when content or CMS config changes during `npm run dev`.
  eleventyConfig.addWatchTarget("./content/articles/");
  eleventyConfig.addWatchTarget("./cms/config.yml");

  // Let post Markdown tag a paragraph as a lede with a trailing `{.lede}`.
  // Restricted to `class` so authoring can only attach styles, not arbitrary attributes.
  eleventyConfig.amendLibrary("md", (md) => md.use(markdownItAttrs, { allowedAttributes: ["class"] }));

  eleventyConfig.addGlobalData("buildSiteUrl", siteUrl);

  eleventyConfig.addFilter("absUrl", absUrl);
  eleventyConfig.addFilter("imageMeta", imageMeta);

  // Relative path from a page back to the site root, matching the hand-authored
  // pages' mount-agnostic `../` convention so blog pages work at root, /2026
  // staging, and production without a deploy-time path rewrite.
  eleventyConfig.addFilter("relRoot", (pageUrl) => {
    const depth = String(pageUrl).split("/").filter(Boolean).length;
    return depth === 0 ? "./" : "../".repeat(depth);
  });

  // Relative href from the current page to a root-absolute target URL (e.g. a
  // collection item's `url`), keeping links mount-agnostic.
  eleventyConfig.addFilter("relUrl", (target, fromPageUrl) => {
    const depth = String(fromPageUrl).split("/").filter(Boolean).length;
    const prefix = depth === 0 ? "./" : "../".repeat(depth);
    return prefix + String(target).replace(/^\/+/, "");
  });

  eleventyConfig.addFilter("dateDisplay", (value) => {
    const d = value instanceof Date ? value : new Date(value);
    return d.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric", timeZone: "UTC" });
  });
  eleventyConfig.addFilter("dateISO", (value) => {
    const d = value instanceof Date ? value : new Date(value);
    return d.toISOString().slice(0, 10);
  });
  // Full ISO timestamp for the `datetime` attribute when a time is shown.
  eleventyConfig.addFilter("dateISOFull", (value) => {
    const d = value instanceof Date ? value : new Date(value);
    return d.toISOString();
  });
  // New York Times-style date + time in Eastern Time, e.g. "June 24, 2026, 7:48 p.m. ET".
  eleventyConfig.addFilter("dateTimeDisplay", (value) => {
    const d = value instanceof Date ? value : new Date(value);
    const date = d.toLocaleDateString("en-US", {
      year: "numeric", month: "long", day: "numeric", timeZone: "America/New_York",
    });
    const time = d
      .toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit", timeZone: "America/New_York" })
      .replace(/\bAM\b/, "a.m.").replace(/\bPM\b/, "p.m.");
    return `${date}, ${time} ET`;
  });

  eleventyConfig.addFilter("tagSlug", (tag) =>
    String(tag).toLowerCase().trim().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "")
  );

  // Published, date-descending posts.
  eleventyConfig.addCollection("posts", (collectionApi) =>
    collectionApi
      .getFilteredByTag("posts")
      .sort((a, b) => new Date(b.data.date) - new Date(a.data.date))
  );

  // Unique tag list across published posts.
  eleventyConfig.addCollection("tagList", (collectionApi) => {
    const tags = new Set();
    for (const item of collectionApi.getFilteredByTag("posts")) {
      for (const tag of item.data.tags || []) {
        if (tag !== "posts") tags.add(tag);
      }
    }
    return [...tags].sort();
  });

  // Image-only media block for code-path authoring (v1). Video is raw HTML or v2.
  const escAttr = (s) =>
    String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
  eleventyConfig.addShortcode("fullMedia", (opts = {}) => {
    const { src, alt, caption = "", layout = "full", theme = "dark" } = opts;
    if (!src || alt === undefined) {
      throw new Error("fullMedia requires `src` and `alt`.");
    }
    const classes = ["blog-media", `blog-media-${escAttr(layout)}`, `blog-media-${escAttr(theme)}`].join(" ");
    const figcaption = caption
      ? `\n    <figcaption class="case-study-caption">${escAttr(caption)}</figcaption>`
      : "";
    return `<figure class="${classes}">
    <img src="${escAttr(src)}" alt="${escAttr(alt)}" loading="lazy" decoding="async" />${figcaption}
  </figure>`;
  });

  // Rewrite root-absolute internal links/images in generated blog HTML to
  // depth-relative paths, so author-written Markdown (e.g. /work/, /assets/...)
  // stays mount-agnostic on /2026 staging like the templated chrome.
  eleventyConfig.addTransform("relativizeBlogUrls", function (content) {
    const url = this.page && this.page.url;
    const outputPath = this.page && this.page.outputPath;
    if (!url || !outputPath || !outputPath.endsWith(".html") || !url.startsWith("/blog/")) {
      return content;
    }
    const depth = url.split("/").filter(Boolean).length;
    const prefix = depth === 0 ? "./" : "../".repeat(depth);
    // Match a single leading slash only (skip protocol-relative //, anchors, mailto, http).
    return content.replace(/\b(href|src)="\/(?!\/)([^"]*)"/g, (_m, attr, rest) => `${attr}="${prefix}${rest}"`);
  });

  // Build the JSON-LD graph for a page. @id values stay production-literal and
  // stable; location URLs (url/image/breadcrumb items) use the env-aware base.
  eleventyConfig.addFilter("jsonLd", (ctx) => {
    const graph = [];
    const personRef = { "@id": `${PROD_URL}/#person` };
    const websiteRef = { "@id": `${PROD_URL}/#website` };

    if (ctx.pageType === "post") {
      graph.push({
        "@type": "Article",
        "@id": `${PROD_URL}/blog/${ctx.slug}/#article`,
        url: ctx.url,
        mainEntityOfPage: ctx.url,
        headline: ctx.title,
        description: ctx.description,
        image: ctx.image,
        datePublished: ctx.datePublished,
        dateModified: ctx.dateModified,
        author: personRef,
        publisher: personRef,
        isPartOf: websiteRef,
      });
      graph.push({
        "@type": "BreadcrumbList",
        "@id": `${PROD_URL}/blog/${ctx.slug}/#breadcrumb`,
        itemListElement: [
          { "@type": "ListItem", position: 1, name: "Home", item: absUrl("/") },
          { "@type": "ListItem", position: 2, name: "Blog", item: absUrl("/blog/") },
          { "@type": "ListItem", position: 3, name: ctx.title, item: ctx.url },
        ],
      });
      graph.push({ "@type": "Person", "@id": `${PROD_URL}/#person`, name: "John Niedermeyer", url: absUrl("/") });
    } else {
      const isTag = ctx.pageType === "tag";
      // @id stays production-literal/stable; url is the environment-aware location.
      const idBase = `${PROD_URL}${ctx.path}`;
      graph.push({
        "@type": isTag ? "CollectionPage" : "Blog",
        "@id": `${idBase}#${isTag ? "collection" : "blog"}`,
        url: ctx.url,
        name: ctx.title,
        description: ctx.description,
        isPartOf: websiteRef,
        author: personRef,
      });
    }

    return `<script type="application/ld+json">\n${JSON.stringify({ "@context": "https://schema.org", "@graph": graph }, null, 2)}\n</script>`;
  });

  eleventyConfig.addPlugin(feedPlugin, {
    type: "rss",
    outputPath: "/feed.xml",
    collection: { name: "posts", limit: 20 },
    metadata: {
      language: "en",
      title: "NiederBlog — John Niedermeyer",
      subtitle: "Writing on product design, process, and craft.",
      base: siteUrl() + "/",
      author: { name: "John Niedermeyer" },
    },
  });

  return {
    // Render to a scratch dir; scripts/place-blog-output.mjs copies the
    // generated artifacts to the repo root. Input is the repo root, but
    // templateFormats below means only .njk/.md are ever treated as input,
    // so the hand-authored .html pages are untouched.
    dir: {
      input: ".",
      output: "_site",
      includes: "blog-source/_includes",
      data: "blog-source/_data",
    },
    templateFormats: ["njk", "md"],
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
  };
};
