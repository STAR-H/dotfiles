---Improved vim.ui.select and vim.ui.input.
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = { enabled = false },
    select = {
      enabled = true,
      get_config = function(opts)
        if opts.kind == "codeaction" then
          return {
            telescope = require("telescope.themes").get_cursor({}),
          }
        end
      end,
    },
  },
  config = function(_, opts)
    require("dressing").setup(opts)
  end,
}
