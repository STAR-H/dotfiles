return {
  'stevearc/dressing.nvim',
  event = "VeryLazy",
  opts = {
    input = {
      enabled = false,
    },
    select = {
      enabled = true,
      -- change codeaction telescope theme to get_cursor
      get_config = function(opts)
        if opts.kind == 'codeaction' then
          return {
            telescope = require('telescope.themes').get_cursor({})
          }
        end
      end,
    }
  },
  config = function(_, opts)
    require("dressing").setup(opts)
  end
}
