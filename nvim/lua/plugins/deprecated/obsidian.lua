---Obsidian vault integration (deprecated).
---Disabled: conflicts with render-markdown.nvim.
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  enabled = false,
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
        path = "~/Documents/OneDrive/obsidian",
        overrides = {
          notes_subdir = "00-Inbox",
        },
      },
    },
    ui = {
      enable = false,
      checkboxes = {
        [" "] = {},
        ["x"] = {},
      },
    },
    daily_notes = {
      folder = "00-Inbox/dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = "dailies.md",
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d %H:%M",
      time_format = "%H:%M",
      substitutions = {
        id = function()
          return os.date("%Y%m%d%H%M")
        end,
        title_date = function()
          return os.date("%B %-d, %Y")
        end,
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,
    picker = {
      name = "telescope.nvim",
    },
  },
}
