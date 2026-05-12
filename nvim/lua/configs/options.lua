-- =============================================================================
-- Editor Options
-- =============================================================================

vim.opt.backup = false            -- disable backup files
vim.opt.clipboard = "unnamedplus" -- sync system clipboard with unnamed register
vim.opt.swapfile = false          -- disable swap files
vim.opt.undofile = true           -- enable persistent undo history
vim.opt.writebackup = true        -- protect against concurrent edits
vim.opt.confirm = true            -- confirm before abandoning unsaved changes
vim.opt.autowrite = false         -- don't auto-write before certain commands

vim.opt.timeoutlen = 500          -- key sequence timeout (ms)
vim.opt.updatetime = 100          -- faster CursorHold trigger (default 4000)
vim.opt.showcmd = false           -- hide partial command in statusline
vim.opt.showmode = false          -- hide -- INSERT -- (statusline shows mode)

-- =============================================================================
-- UI Options
-- =============================================================================

vim.opt.termguicolors = true   -- enable 24-bit RGB color
vim.opt.laststatus = 3         -- global statusline across all windows
vim.opt.showtabline = 0        -- never show tab bar
vim.opt.cursorline = true      -- highlight current line
vim.opt.number = false         -- no absolute line numbers
vim.opt.relativenumber = false -- no relative line numbers
vim.opt.numberwidth = 2        -- line number column width
vim.opt.signcolumn = "yes"     -- always show sign column (avoids shift)
vim.opt.wrap = true            -- soft-wrap long lines
vim.opt.linebreak = true       -- wrap at word boundaries
vim.opt.scrolloff = 10         -- keep 10 lines visible above/below cursor
vim.opt.sidescrolloff = 10     -- keep 10 cols visible left/right of cursor
vim.opt.smoothscroll = true    -- smooth scrolling with virtual lines
vim.opt.pumheight = 10         -- popup menu max height

vim.opt.list = true            -- show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = "│",
  diff = " ",
}
vim.opt.foldcolumn = "0" -- no fold column by default (dynamic)

-- =============================================================================
-- Indentation
-- =============================================================================

vim.opt.expandtab = true                        -- use spaces instead of tabs
vim.opt.shiftwidth = 4                          -- indent width 4 spaces (default)
vim.opt.tabstop = 4                             -- tab display width 4 spaces
vim.opt.softtabstop = 4                         -- soft tab width
vim.opt.smarttab = true                         -- use shiftwidth at line start, tabstop elsewhere
vim.opt.smartindent = true                      -- auto-indent based on syntax
vim.opt.cindent = true                          -- C-style indentation
vim.opt.cinoptions = "g0,:0,N-s,(0"             -- C indentation options
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- disable auto comment continuation

-- =============================================================================
-- Search
-- =============================================================================

vim.opt.hlsearch = true       -- highlight all search matches
vim.opt.ignorecase = true     -- case-insensitive search
vim.opt.smartcase = true      -- case-sensitive when uppercase used
vim.opt.showmatch = true      -- briefly jump to matching bracket
vim.opt.matchtime = 1         -- match highlight duration (100ms)
vim.opt.shortmess:append("c") -- suppress completion messages

-- =============================================================================
-- Window / Split Behavior
-- =============================================================================

vim.opt.splitbelow = true      -- horizontal split opens below
vim.opt.splitright = true      -- vertical split opens to the right
vim.opt.whichwrap = "bs<>[]hl" -- keys that can wrap across lines

-- =============================================================================
-- Completion
-- =============================================================================

vim.opt.completeopt = { "menu", "menuone", "noselect" } -- completion popup behavior
vim.opt.conceallevel = 0                                -- show all concealed text (markdown inline code)

-- =============================================================================
-- Misc
-- =============================================================================

vim.opt.mouse = "n"                                   -- mouse support in normal mode
vim.opt.tags = "./.tags;,.tags"                       -- tags file search path
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- isolate from system vim plugins

vim.opt.diffopt:append({ "foldcolumn:1", "indent-heuristic", "algorithm:minimal", "linematch:60"})

-- =============================================================================
-- Disable Built-in Providers (not needed, speed up startup)
-- =============================================================================

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- disable netrw (use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- speed up diff syntax highlighting
vim.g.diff_translations = 0

-- =============================================================================
-- Diagnostics: disabled by default, toggle with `dt`
-- =============================================================================

vim.diagnostic.enable(false)

-- =============================================================================
-- PATH: prepend mason binaries
-- =============================================================================
local is_windows = require("configs.platform").is_windows
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
