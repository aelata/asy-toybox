({
  // Please visit the URL below for more information:
  // https://shd101wyy.github.io/markdown-preview-enhanced/#/extend-parser

  onWillParseMarkdown: async function(markdown) {
    markdown = markdown.replace(
      /\[([^\]]+)\]\(([^)]+).md\)/g, "[$1]($2.html)");
    return markdown;
  },

  onDidParseMarkdown: async function(html) {
    return html;
  },
})