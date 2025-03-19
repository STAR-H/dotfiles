vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = ","

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "STAR-H/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
-- Load all cached colors in prevent
local base46_cache = require "chadrc".base46.integrations or {}
for _, v in ipairs(base46_cache) do
  dofile(vim.g.base46_cache .. v)
end

-- diff highlight override
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#b8bb26', fg = '#232323', })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#444444' })
vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#fb4934' })
vim.api.nvim_set_hl(0, 'DiffModified', { fg = '#f18019' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#fabd2f', fg = '#232323', bold = true })

-- lualine diff status highlight override
vim.api.nvim_set_hl(0, 'stlDiffAdd', { fg = '#b8bb26', bg = '#32302f' })
vim.api.nvim_set_hl(0, 'stlDiffDelete', { fg = '#fb4934', bg = '#32302f' })
vim.api.nvim_set_hl(0, 'stlDiffModified', { fg = '#f18019', bg = '#32302f' })

-- nvim-tree highlight override
vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { bg = '#2e2e2e', bold = true })

-- treesitter highlight override
vim.api.nvim_set_hl(0, '@comment', { fg = '#808080', italic = true })

require "configs.options"
require "configs.autocmds"

vim.schedule(function()
  require "configs.mappings"
end)

-- WARNING:  the whole configuration is need nvim V0.10.4
