return {
    "STAR-H/vim-mark",
    branch = "master",
    dependencies = "inkarkat/vim-ingo-library",
    -- do not add mark words to the search(/)  and input(@) history
    config = function()
        vim.g.mwHistAdd = ' '
        -- let marks to be case-insensitive
        vim.g.mwIgnoreCase = 0
        vim.g.mwMaxMatchPriority = 10
        vim.g.mw_no_mappings = 1

        local opts = {silent = true, nowait = true}
        vim.keymap.set('n', 'mm', "<Plug>MarkSet",            opts)
        vim.keymap.set('x', 'mm', "<Plug>MarkSet",            opts)
        vim.keymap.set('n', 'mr', "<Plug>MarkRegex",          opts)
        vim.keymap.set('n', 'mc', "<Plug>MarkAllClear",       opts)
        vim.keymap.set('n', '*', "<Plug>MarkSearchOrCurNext", opts)
        vim.keymap.set('n', '#', "<Plug>MarkSearchOrCurPrev", opts)
    end
}
