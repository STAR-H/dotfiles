return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        position = "bottom",
        height = 10,
        icons = true,
        padding = false,
        cycle_results = false,
    },
    config = function ()
        vim.keymap.set("n", "gr", function() require("trouble").open("lsp_references") end)
        vim.keymap.set("n", "dl", function ()
            vim.diagnostic.setloclist({open = false})
            vim.cmd('TroubleToggle loclist')
        end)
    end
}
