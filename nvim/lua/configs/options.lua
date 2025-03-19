vim.opt.backup = false                                  -- creates a backup file
vim.opt.clipboard = "unnamedplus"                       -- allows neovim to access the system clipboard
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                                -- so that `` is visible in markdown files
vim.opt.hlsearch = true                                 -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                               -- ignore case in search patterns
vim.opt.mouse = "n"                                     -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                                  -- pop up menu height
vim.opt.showcmd = false
vim.opt.showmode = false                                -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                                 -- never show tabs
vim.opt.smartcase = true                                -- smart case
vim.opt.smartindent = true                              -- make indenting smarter again
vim.opt.splitbelow = true                               -- force all horizontal splits to go below current window
vim.opt.splitright = true                               -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                                -- creates a swapfile
vim.opt.termguicolors = true                            -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 500                                -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                                 -- enable persistent undo
vim.opt.updatetime = 100                                -- faster completion (4000ms default)
vim.opt.writebackup = true                              -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                                -- convert tabs to spaces
vim.opt.shiftwidth = 2                                  -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4                                     -- insert 4 spaces for a tab
vim.opt.cursorline = true                               -- highlight the current line
vim.opt.number = true                                   -- set numbered lines
vim.opt.relativenumber = true                           -- set relative numbered lines
vim.opt.numberwidth = 4                                 -- set number column width to 2 {default 4}

vim.opt.signcolumn = "yes"                              -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = true                                     -- display lines as one long line
vim.opt.linebreak = true                                -- companion to wrap, don't split words
vim.opt.scrolloff = 10                                  -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 10                              -- minimal number of screen columns either side of cursor if wrap is `false`
vim.opt.whichwrap = "bs<>[]hl"                          -- which "horizontal" keys are allowed to travel to prev/next line

vim.opt.ruler = false
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.magic = true
vim.opt.redrawtime = 300
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.tags = "./.tags;,.tags"
vim.opt.cindent = true
vim.opt.cinoptions = "g0,:0,N-s,(0"
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.autowrite = false
vim.opt.confirm = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.g.diff_translations = 0 -- To disable localisations and speed up the syntax highlighting

vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = "│",
}
vim.opt.foldcolumn = '0'
vim.opt.smoothscroll = true

vim.diagnostic.enable(false)                          -- disable diagnostic by default

vim.opt.shortmess:append "c"                          -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                          -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })       -- don't insert the current comment leader automatically
-- for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use
-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
