return {
  "folke/todo-comments.nvim",
  enabled = not require("configs.utils").is_diff_mode(),
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      after = "fg",   -- "fg" or "bg" or empty
      multiline = true
    },
  },
  keys = {
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                   desc = "Todo-Comments Trouble Toggle" },
    { "<leader>st", "<cmd>TodoTelescope<cr>",                         desc = "Todo-Comments Telescope Show" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo-Comments Telescope Keyword" },
  },
}
