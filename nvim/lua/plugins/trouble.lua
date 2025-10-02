return {
  "folke/trouble.nvim",
  keys = {
    { "gr",         "<cmd>Trouble lsp_references focus=true<cr>",       desc = "LSP Go to References" },
    { "gd",         "<cmd>Trouble lsp_definitions focus=true<cr>",      desc = "LSP Go to Definitions" },
    { "gi",         "<cmd>Trouble lsp_implementations focus=true<cr>",  desc = "LSP Go to Implementations" },
    { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics list diagnostics info(current buffer)" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    auto_close = true,       -- auto close when there are no items
    warn_no_results = false, -- show a warning when there are no results
  },
}
