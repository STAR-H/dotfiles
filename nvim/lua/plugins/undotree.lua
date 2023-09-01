return {
    "mbbill/undotree",
    config = function()
        local function opts(descs)
            return { desc = descs, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, opts("[u]ndotreeToggle"))
        vim.g.undotree_WindowLayout = 2
    end,
}
