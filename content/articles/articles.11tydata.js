// Directory data for blog articles. `draft: true` is the build-time publishing
// gate: drafts are excluded from output and collections unless
// ELEVENTY_INCLUDE_DRAFTS is set (local authoring via `npm run dev`).
export default {
  layout: "post.njk",
  tags: ["posts"],
  pageType: "post",
  eleventyComputed: {
    permalink(data) {
      if (data.draft && !process.env.ELEVENTY_INCLUDE_DRAFTS) return false;
      return `/blog/${data.page.fileSlug}/index.html`;
    },
    eleventyExcludeFromCollections(data) {
      return Boolean(data.draft && !process.env.ELEVENTY_INCLUDE_DRAFTS);
    },
    slug(data) {
      return data.page.fileSlug;
    },
  },
};
