return {
    "MattesGroeger/vim-bookmarks",
    config = function()
        vim.g.bookmark_no_default_key_mappings = 1
        vim.g.bookmark_show_toggle_warning = 0
        vim.g.bookmark_highlight_lines = 1
        vim.g.bookmark_location_list = 1
        vim.g.bookmark_disable_ctrlp = 1
        vim.g.bookmark_show_warning = 0
        vim.g.bookmark_auto_close = 1
        vim.g.bookmark_auto_save = 0
        vim.g.bookmark_center = 1
        vim.g.bookmark_sign = ''
        vim.g.bookmark_annotation_sign = '﭅'

        -- vim.cmd[[:highlight BookmarkSign guifg=#00ffff guibg=#3c3836]]
        -- vim.cmd[[:highlight BookmarkAnnotationSign guifg=#00ffff guibg=#3c3836]]

        local opts = {noremap = true, noremap = true, silent = true, nowait = true}
        vim.keymap.set('n', 'bb', ":BookmarkToggle<CR>",   opts)
        vim.keymap.set('n', 'bi', ":BookmarkAnnotate<CR>", opts)
        vim.keymap.set('n', 'bj', ":BookmarkNext<CR>",     opts)
        vim.keymap.set('n', 'bk', ":BookmarkPrev<CR>",     opts)
        vim.keymap.set('n', 'ba', ":BookmarkShowAll<CR>",  opts)
        vim.keymap.set('n', 'bc', ":BookmarkClearAll<CR>", opts)
    end
}
