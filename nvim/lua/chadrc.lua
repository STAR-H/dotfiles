-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  integrations = {
    "defaults",
    "telescope",
    "flash",
    "dap",
    "cmp",
    "lsp",
    "mason",
    "nvcheatsheet",
    "nvimtree",
    "syntax",
    "treesitter",
    "trouble",
    "whichkey",
    "codeactionmenu",
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "                            ",
    "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
    "   ▄▀███▄     ▄██ █████▀    ",
    "   ██▄▀███▄   ███           ",
    "   ███  ▀███▄ ███           ",
    "   ███    ▀██ ███           ",
    "   ███      ▀ ███           ",
    "   ▀██ █████▄▀█▀▄██████▄    ",
    "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    "                            ",
    "     Powered By  eovim    ",
    "                            ",
  },

  buttons = {
    { txt = "  Find File", keys = ", ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = ", fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = ", fg", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = ", th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = ", ch", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

M.ui = {
  -- disable nvchad bufferline and statusline
  tabufline = {
    enabled = false,
  },
  statusline = {
    enabled = false,
  },
  telescope = { style = "bordered" }
}

M.cheatsheet = {
  theme = "grid",                                                                                        -- simple/grid
  excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens", ":help", "Show", "toggle", "jump" }, -- can add group name or with mode
}

M.lsp = {
  -- conflict with noice signature help
  signature = false,
}
return M
