function tagSlug(tag) {
  return String(tag).toLowerCase().trim().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
}

export default {
  layout: "base.njk",
  pageType: "tag",
  pagination: { data: "collections.tagList", size: 1, alias: "tag" },
  eleventyComputed: {
    title: (data) => `Posts tagged #${data.tag}`,
    description: (data) => `All NiederBlog posts tagged #${data.tag}.`,
    permalink: (data) => `/blog/tags/${tagSlug(data.tag)}/index.html`,
  },
};
