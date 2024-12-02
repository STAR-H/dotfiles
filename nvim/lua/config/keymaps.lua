local opts = { noremap = true, silent = true }
-- Shorten function name
local keymap = vim.keymap.set

vim.g.mapleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Clear search hightlight
keymap("n", "<ESC>", ":nohl<CR>", opts)

-- Resize with arrows
keymap("n", "<up>", ":resize -5<CR>",             opts)
keymap("n", "<down>", ":resize +5<CR>",           opts)
keymap("n", "<left>", ":vertical resize -5<CR>",  opts)
keymap("n", "<right>", ":vertical resize +5<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>",     opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

keymap("n", "q", "<NOP>", opts)

-- Use q to quit visual selection
keymap("v", "q", "<Esc>", opts)

-- Remap Q to q for macro recording
keymap("n", "Q", "q", opts)

keymap("n", "dt", ToggleDiagnostics, {silent = true, noremap = true, desc = "[d]iagnostics [t]oggle"})

keymap("n", "<leader>d", CloseBuffer, { noremap = true, silent = true, desc = "[d]elete buffer"})

-- Exit in terminal mode
keymap("t", "jk", "<C-\\><C-n>", opts)
keymap("t", "kj", "<C-\\><C-n>", opts)

