return {
    "junegunn/vim-easy-align",
    config = function()
        local opts = {noremap = true, silent = true, nowait = true}
        vim.keymap.set('n', 'ga', ":EasyAlign<CR>", opts)
        vim.keymap.set('x', 'ga', ":EasyAlign<CR>", opts)
    end
}
