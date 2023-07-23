local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

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

keymap("n", "<ESC>", ":nohl<CR>", opts)
-- Resize with arrows
keymap("n", "<up>", ":resize -5<CR>", opts)
keymap("n", "<down>", ":resize +5<CR>", opts)
keymap("n", "<left>", ":vertical resize -5<CR>", opts)
keymap("n", "<right>", ":vertical resize +5<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to exit insert mode 
keymap("i", "<C-k>", "<ESC>", opts)

keymap("n", "<leader>d", ":bd<CR>", opts)

keymap("t", "<Esc>", "<C-\\><C-n>", opts)
vim.cmd[[autocmd TermOpen * setlocal statusline=%{b:term_title}]]

