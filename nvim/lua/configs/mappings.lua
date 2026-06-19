---Global key mappings.
---All mappings use `,` as leader key (set in init.lua).
---Mode abbreviations: n=normal, i=insert, v=visual, x=visual_block, t=terminal, c=command
local keymap = vim.keymap.set

-- =============================================================================
-- Window Navigation (Ctrl + hjkl)
-- =============================================================================

keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "NavigateWindow Left" })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "NavigateWindow Down" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "NavigateWindow Up" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "NavigateWindow Right" })

-- =============================================================================
-- Window Resize (Arrow Keys)
-- =============================================================================

keymap("n", "<up>", "<Cmd>resize -5<CR>", { noremap = true, silent = true })
keymap("n", "<down>", "<Cmd>resize +5<CR>", { noremap = true, silent = true })
keymap("n", "<left>", "<Cmd>vertical resize -5<CR>", { noremap = true, silent = true })
keymap("n", "<right>", "<Cmd>vertical resize +5<CR>", { noremap = true, silent = true })

-- =============================================================================
-- Buffer Navigation
-- =============================================================================

keymap("n", "<S-l>", "<Cmd>bnext<CR>", { noremap = true, silent = true, desc = "NavigateBuffer Next" })
keymap("n", "<S-h>", "<Cmd>bprevious<CR>", { noremap = true, silent = true, desc = "NavigateBuffer Prev" })

-- close buffer (or window if splits exist)
keymap("n", "<leader>d",
  function()
    require("configs.utils").close_buffer()
  end,
  { silent = true, noremap = true, desc = "Close buffer" })

-- close all other buffers
keymap("n", "<leader>D",
  function()
    require("snacks").bufdelete.other()
  end,
  { silent = true, noremap = true, desc = "Close all other buffers" })

-- =============================================================================
-- Insert Mode
-- =============================================================================

-- jk / kj to exit insert mode
keymap("i", "jk", "<ESC>", { noremap = true, silent = true })
keymap("i", "kj", "<ESC>", { noremap = true, silent = true })

-- =============================================================================
-- Search Navigation (center screen after jump)
-- =============================================================================

keymap("n", "n", "nzzzv", { noremap = true, silent = true })
keymap("n", "N", "Nzzzv", { noremap = true, silent = true })

-- clear search highlight on Escape
keymap("n", "<ESC>",
  function()
    vim.cmd("nohlsearch")
    vim.fn.setreg("/", "")
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", false
    )
  end,
  { noremap = true, silent = true })

-- =============================================================================
-- Visual Mode
-- =============================================================================

keymap("v", "q", "<Esc>", { noremap = true, silent = true, desc = "Quit visual mode" })

keymap("x", "<C-a>",
  function()
    require("configs.utils").copy_line_reference()
  end,
  { noremap = true, silent = true, desc = "Copy selected line reference" })

-- =============================================================================
-- Macro Recording: remap Q -> q, disable default q
-- =============================================================================

keymap("n", "q", "<NOP>", { noremap = true, silent = true })
keymap("n", "Q", "q", { noremap = true, silent = true, desc = "start/stop macro recording" })

-- =============================================================================
-- Diagnostics Toggle
-- =============================================================================

keymap("n", "dt",
  function()
    require("configs.utils").toggle_diagnostics()
  end,
  { silent = true, noremap = true, desc = "Toggle diagnostics on/off" })

-- =============================================================================
-- Toggle Line Numbers
-- =============================================================================

keymap("n", "<leader>ul",
  function()
    local number = vim.o.number
    local relativenumber = vim.o.relativenumber
    if number or relativenumber then
      vim.o.number = false
      vim.o.relativenumber = false
    else
      vim.o.number = true
      vim.o.relativenumber = true
    end
  end,
  { desc = "Toggle line number and relativenumber" })

-- =============================================================================
-- Terminal Mode
-- =============================================================================

keymap("t", "jk", "<C-\\><C-n>",    { noremap = true, silent = true })
keymap("t", "kj", "<C-\\><C-n>",    { noremap = true, silent = true })
keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })

-- =============================================================================
-- Visual Line Navigation (wrap-aware j/k)
-- =============================================================================

keymap("n", "j", "gj", { noremap = true, silent = true })
keymap("n", "k", "gk", { noremap = true, silent = true })

-- =============================================================================
-- Tmux Compatibility: disable backtick in normal mode
-- (backtick is used as tmux prefix key)
-- =============================================================================

keymap("n", "`", "<NOP>", { noremap = true, silent = true })
