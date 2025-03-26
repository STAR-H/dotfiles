return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = { { "<C-e>", "<cmd>RenderMarkdown toggle<cr>", desc = "RenderMarkdown toggle" } },
    opts = {
      enabled = false, -- default not render the markdown file
      completions = { lsp = { enabled = true } },

      sign = { enabled = false },

      heading = {
        icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' },
        width = 'block',
        position = 'overlay',
      },

      checkbox = {
        position = 'overlay',
        checked = { scope_highlight = '@markup.strikethrough' }
      },

      anti_conceal = { enabled = false },

      indent = {enabled = false},

      preset = 'obsidian',
    },
  },
  -- install with yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install", -- need manually install
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
      vim.g.mkdp_theme = 'light' -- light or dark
      vim.g.mkdp_markdown_css = vim.fn.stdpath('config') .. "/lua/configs/markdown/notion-light-enhanced.css"
      -- vim.g.mkdp_theme = 'dark' -- light or dark
      -- vim.g.mkdp_markdown_css = vim.fn.stdpath('config') .. "/lua/configs/markdown/notion-dark-enhanced.css"

    end
  },

  {
    "HakonHarnes/img-clip.nvim",
    ft = { 'markdown' },
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  }
}
