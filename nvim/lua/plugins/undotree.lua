return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { noremap = true, silent = true })
        vim.g.undotree_WindowLayout = 2
    end,
}