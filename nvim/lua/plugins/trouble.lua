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
        vim.keymap.set("n", "gr", function() require("trouble").open("lsp_references") end, {desc = "[g]o to [r]eference"})
        vim.keymap.set("n", "<leader>ld", function ()
            vim.diagnostic.setloclist({open = false})
            vim.cmd('TroubleToggle loclist')
        end, {desc = "[d]iagnostic [l]ist"})
    end
}
