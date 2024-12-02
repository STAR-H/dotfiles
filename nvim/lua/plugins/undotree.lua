return {
    "mbbill/undotree",
    enabled = not IsDiffMode(),
    keys = {"<leader>u", "<cmd>UndoTreeToggle<cr>", desc = "UndoTreeToggle"},
    config = function()
        vim.g.undotree_WindowLayout = 2
    end,
}
