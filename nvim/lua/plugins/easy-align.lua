return {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    config = function()
        local opts = {desc = "Easy[A]lign", noremap = true, silent = true, nowait = true}
        vim.keymap.set('n', 'ga', ":EasyAlign<CR>", opts)
        vim.keymap.set('x', 'ga', ":EasyAlign<CR>", opts)
    end
}
