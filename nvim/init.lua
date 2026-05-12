-- Set base46 cache directory (must be set before base46 loads)
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
-- Set leader key (must be set before mappings are defined)
vim.g.mapleader = ","

-- version check: this config targets Neovim 0.11.x
if vim.fn.has("nvim-0.11") == 0 then
  vim.schedule(function()
    local version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    local lines = {
      "This dotfiles config is built for Neovim 0.11.x.",
      "Recommended version: v0.11.7",
      "Your version: " .. version,
      "",
      "Some features may not work correctly.",
    }

    local width = 0
    for _, line in ipairs(lines) do
      width = math.max(width, #line)
    end
    width = math.min(width + 4, vim.o.columns - 4)
    local height = math.min(#lines + 2, vim.o.lines - 4)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = "wipe"

    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = math.max(0, math.floor((vim.o.columns - width) / 2)),
      row = math.max(0, math.floor((vim.o.lines - height) / 2)),
      style = "minimal",
      border = "rounded",
      title = " Neovim Version Warning ",
      title_pos = "center",
    })
  end)
end

-- bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load all plugins
require("lazy").setup({
  -- base46: theme/color engine (standalone, no NvChad core needed)
  -- Config is in nvconfig.lua (gruvbox theme, integrations list)
  {
    "NvChad/base46",
    lazy = false,
    branch = "v3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- import all plugin specs from lua/plugins/
  { import = "plugins" },
}, lazy_config)

-- load base46 theme highlights (compile + apply)
require("base46").load_all_highlights()

-- diff highlight override (gruvbox-inspired, with word-diff bold)
vim.api.nvim_set_hl(0, "DiffAdd",      { bg = "#333e26", })
vim.api.nvim_set_hl(0, "DiffChange",   { bg = "#32373c", fg = "#ebdbb2" })
vim.api.nvim_set_hl(0, "DiffDelete",   { bg = "#352928",  italic = true })
vim.api.nvim_set_hl(0, "DiffModified", { bg = "#3c3526", })
vim.api.nvim_set_hl(0, "DiffText",     { bg = "#4a3d28", fg = "#fabd2f", bold = true })

-- diff line number highlight
vim.api.nvim_set_hl(0, "DiffAddNr",      { fg = "#b8bb26", bold = true })
vim.api.nvim_set_hl(0, "DiffChangeNr",   { fg = "#fabd2f", bold = true })
vim.api.nvim_set_hl(0, "DiffDeleteNr",   { fg = "#fb4934", bold = true })
vim.api.nvim_set_hl(0, "DiffModifiedNr", { fg = "#fe8019", bold = true })

-- general UI highlight overrides
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#808080" })
vim.api.nvim_set_hl(0, "NonText",      { fg = "#808080" })
vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#3a3a3a" })

-- treesitter comment highlight override
vim.api.nvim_set_hl(0, "@comment", { fg = "#808080", italic = true })

-- load core configuration
require("configs.options")
require("configs.autocmds")

-- load mappings after UI is fully initialized
vim.schedule(function()
  require("configs.mappings")
end)
