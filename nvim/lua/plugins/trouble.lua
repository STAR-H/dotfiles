return {
  "folke/trouble.nvim",
  keys = {
    { "gr",         "<cmd>Trouble lsp_references focus=true<cr>",       desc = "LSP Go to References" },
    { "gd",         "<cmd>Trouble lsp_definitions focus=true<cr>",      desc = "LSP Go to Definitions" },
    -- NOTE:gi is conflict with original vim command (jump to the last into insert mode location),
    -- and go to implementation is not use often, so commented this key mapping
    -- { "gi",         "<cmd>Trouble lsp_implementations focus=true<cr>",  desc = "LSP Go to Implementations" },
    { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics list diagnostics info(current buffer)" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    auto_close = false,      -- auto close when there are no items
    auto_refresh = false,    -- auto refresh when open
    warn_no_results = false, -- show a warning when there are no results
  },
}
