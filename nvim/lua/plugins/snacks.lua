---Collection of small QoL plugins for Neovim.
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- dim mode toggle (reduces brightness of inactive windows)
        Snacks.toggle.dim():map("<leader>ud")
      end,
    })
  end,
  ---@type snacks.Config
  opts = {
    -- enabled modules
    animate = { enabled = true },   -- smooth animations for UI transitions
    bufdelete = { enabled = true }, -- buffer delete with window handling
    bigfile = { enabled = true },   -- disable heavy features for large files
    image = {
      enabled = true,
      doc = {
        inline = true, -- show images inline in floating window
      },
      convert = {
        notify = false, -- suppress error notifications on image convert
      },
    },
    indent = { enabled = false },   -- disabled (use snacks.indent per-filetype instead)
    quickfile = { enabled = true }, -- quick file open on startup
    scope = { enabled = false },    -- scope-based text objects
    scroll = { enabled = true },    -- smooth scrolling
    profiler = { enabled = true },  -- startup profiler

    dashboard = { enabled = true },

    -- disabled modules
    explorer = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    lazygit = { enabled = false },

    -- zen mode: distraction-free editing
    zen = {
      toggles = {
        dim = false,             -- don't dim other windows in zen mode
        git_signs = false,       -- hide git signs in zen mode
        mini_diff_signs = false, -- hide mini diff signs in zen mode
        diagnostics = false,     -- hide diagnostics in zen mode
      },
      win = {
        backdrop = { transparent = false, blend = 0, bg = "#282828" },
      },
    },
  },
  keys = {
    { "<Space><Space>", function() Snacks.zen.zoom() end, desc = "Snacks Zen Toggle Zoom" },
    { "<leader>uz",     function() Snacks.zen() end,      desc = "Toggle Zen Mode" },
  },
}
