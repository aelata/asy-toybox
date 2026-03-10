({
  // Please visit the URL below for more information:
  // https://shd101wyy.github.io/markdown-preview-enhanced/#/extend-parser

  onWillParseMarkdown: async function(markdown) {
    // rewrite .md to .html
    markdown = markdown.replace(
      /\[([^\]]+)\]\(([^)]+).md(#.*)?\)/g, "[$1]($2.html$3)");
    return markdown;
  },

  onDidParseMarkdown: async function(html) {
    // for CVE-2025-65716
    const re = new RegExp(
      '<iframe\\b[^>]*(?:"[^"]*")*[^>]*\\bsandbox\ *=\ *"' +
        '(?=[^"]*\\ballow-scripts\\b)' +
        '(?=[^"]*\\ballow-same-origin\\b)' +
        '.*?".*?>.*?</iframe>',
      "gis"); // Global, IgnoreCase, DotAll
    html = html.replace(re, " !!! IFRAME REMOVED !!! ");
    return html;
  },
})
