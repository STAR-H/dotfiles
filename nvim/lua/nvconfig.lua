---Minimal nvconfig stub for base46.
---Replaces NvChad/ui's nvconfig.lua.
---@class NvConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  transparency = false,
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
  -- prevent unused highlight groups from being compiled (cosmetic only)
  excluded = {
    "nvcheatsheet",
    "statusline",
    "tbline",
    "blankline",
    "blink",
    "devicons",
    "git",
  },
  hl_override = {},
  hl_add = {},
  changed_themes = {},
  theme_toggle = { "gruvbox", "gruvbox" },
}
-- required by base46/integrations/nvcheatsheet.lua (nvconfig.cheatsheet)
M.cheatsheet = { theme = "grid" }
-- required by base46/integrations/cmp.lua (nvconfig.ui.cmp)
-- required by base46/integrations/telescope.lua (nvconfig.ui.telescope)
M.ui = {
  cmp = { style = "default" },
  telescope = { style = "bordered" },
  statusline = {
    theme = "default",
    separator_style = "default",
  },
}

return M
