return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Create some toggle mappings
        Snacks.toggle.dim():map("<leader>ud")
      end,
    })
  end,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = { enabled = true },
    bufdelete = { enabled = true },
    bigfile = { enabled = true },
    image = {
      enabled = true,
      doc = {
        inline = true,   -- use float window show the image
      },
      convert = {
        notify = false,   -- show a notification on error
      }
    },
    indent = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = true },
    profiler = { enabled = true },

    dashboard = { enabled = false },
    explorer = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    lazygit = { enabled = false },

    zen = {
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        -- inlay_hints = false,
      },
      win = {
        backdrop = { transparent = false, blend = 0, bg = '#282828' },
      },
    }
  },
  keys = {
    { "<Space><Space>", function() Snacks.zen.zoom() end, desc = "Snacks Zen Toggle Zoom" },
    { "<leader>uz",     function() Snacks.zen() end,      desc = "Toggle Zen Mode" },
  }
}
