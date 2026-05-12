---Markdown preview in browser (deprecated).
---Disabled: use render-markdown.nvim for in-editor preview instead.
return {
  "iamcco/markdown-preview.nvim",
  enabled = false,
  ft = { "markdown" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  config = function()
    vim.g.mkdp_theme = "light"
    vim.g.mkdp_markdown_css = vim.fn.stdpath("config")
      .. "/lua/configs/markdown/notion-light-enhanced.css"
  end,
}
