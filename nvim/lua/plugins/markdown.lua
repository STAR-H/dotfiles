return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown", "Avante" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = { { "<C-e>", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "RenderMarkdown toggle" } },
    opts = {
      enabled = true,
      file_types = { "markdown", "Avante" },
      completions = { lsp = { enabled = true } },

      sign = { enabled = false },

      heading = {
        icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' },
        width = 'block',
        position = 'inline',
      },

      checkbox = {
        position = 'overlay',
        checked = { scope_highlight = '@markup.strikethrough' }
      },
      pipe_table = {
        cell = 'trimmed',
        preset = 'round',
      },

      anti_conceal = { enabled = true },

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
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
    },

    opts = {
      disable_frontmatter = true,
      workspaces = {
        {
          name = "obsidian",
          path = "~/Personal/obsidian",
          overrides = {
            notes_subdir = "00-Inbox",
          },
        },
      },

      ui = {
        enable = false, -- conflict with render-markdown.nvim, and render-markdown have better ui
        -- only use the below two checkboxes style, can use <CR> to toggle the status
        checkboxes = {
          [" "] = {},
          ["x"] = {},
        },
      },

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "00-Inbox/dailies",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = 'dailies.md'
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d %H:%M",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {
          id = function()
            return os.date("%Y%m%d%H%M")
          end,
          title_date = function()
            return os.date("%B %-d, %Y")
          end
        },
      },

      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
      },
    },
  }
}
