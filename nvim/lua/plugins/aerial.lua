---Code outline sidebar for skimming and quick navigation (LSP + tree-sitter).
return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>t", "<cmd>AerialToggle!<cr>", desc = "Toggle Aerial Outline" },
  },
  opts = {
    backends = {
      ['_']    = {"lsp", "treesitter"},
      markdown = {"treesitter"},
      cpp      = {"lsp"},
      c        = {"lsp"},
    },
    layout = {
      width = 40,
      default_direction = "left",
      placement = "window",
      resize_to_content = false,
      win_opts = {
        cursorline = true,
      }
    },
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Struct",
    },
    close_on_select = false,
    disable_max_lines = 30000,
    disable_max_size = 2000000, -- 2MB
    highlight_on_jump = 300,
    post_jump_cmd = "normal! zz",
    update_events = "TextChanged,InsertLeave",
    show_guides = true,
    guides = {
      mid_item    = "├─",
      last_item   = "└─",
      nested_top  = "│ ",
      whitespace  = "  ",
    },
  },
  config = function(_, opts)
    require("aerial").setup(opts)

    vim.api.nvim_set_hl(0, "AerialLine", { bg = "#504945", bold = true })
  end,
}
