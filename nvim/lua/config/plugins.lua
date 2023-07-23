local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"nvim-lua/plenary.nvim"},
    require("plugins.colorscheme"),
    require("plugins.autopairs"),
    require("plugins.indent-blankline"),
    require("plugins.nvim-web-devicons"),
    require("plugins.bufferline"),
    require("plugins.lualine"),
    require("plugins.scrollbar"),
    require("plugins.treesitter"),
    require("plugins.gitsigns"),
    require("plugins.telescope"),
    require("plugins.project"),
    require("plugins.tagbar"),
    require("plugins.nvimTree"),
    {"numToStr/Comment.nvim", config = function() require('Comment').setup() end },
    require("plugins.cellular-automaton"),
    require("plugins.easy-align"),
    require("plugins.vim-bookmark"),
    require("plugins.flash"),
    require("plugins.vim-mark"),
    require("plugins.coc-nvim"),

    {"STAR-H/vim-cppman", lazy = true},
    {"STAR-H/vim-snippets", lazy = true},
},
{
ui = {
    icons = {
        cmd = "",
        config = "",
        event = "",
        ft = " ",
        init = " ",
        import = " ",
        keys = " ",
        lazy = "",
        loaded = "●",
        not_loaded = "○",
        plugin = " ",
        runtime = " ",
        source = " ",
        start = "",
        task = "✔ ",
        list = {
            "●",
            "➜",
            "★",
            "‒",
        },
    },
}
}
)
