---Shows available keymaps when leader (,) is pressed.
---Groups are defined in spec for categorization, with helix preset icons.
return {
  "folke/which-key.nvim",
  enabled = not require("configs.utils").is_diff_mode(),
  event = "VeryLazy",
  keys = {
    {
      "<leader><leader>",
      function() require("which-key").show() end,
      desc = "Which-Key Popup",
    },
  },
  opts_extend = { "spec" },
  opts = {
    preset = "classic",
    delay = 1000,
    icons = {
      mappings = false, -- disable Nerd Font mapping icons
    },
    spec = {
      {
        mode = { "n", "x" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diagnostics" },
        { "[",         group = "prev" },
        { "]",         group = "next" },
        { "g",         group = "goto" },
        { "z",         group = "fold" },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function() return require("which-key.extras").expand.win() end,
        },
      },
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)
  end,
}
