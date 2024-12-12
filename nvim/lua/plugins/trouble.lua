return {
    "folke/trouble.nvim",
    keys = {
        {"gr", "<cmd>lua require('trouble').open('lsp_references')<cr>", desc = "lsp reference"},
        {"<leader>ld", function() vim.diagnostic.setloclist({open = false}) vim.cmd('TroubleToggle loclist') end, desc = "diagnostic list"},
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        position = "bottom",
        height = 10,
        icons = true,
        padding = false,
        cycle_results = false,
    },
}
