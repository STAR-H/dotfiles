return {
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<C-h>", mode = "v", [[:<C-u>lua MiniSurround.add('visual')<CR>`]], { slient = true, desc = "Markdown highlight color" } }
    },
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = 'gsa',            -- Add surrounding in Normal and Visual modes
          delete = 'gsd',         -- Delete surrounding
          find = 'gsf',           -- Find surrounding (to the right)
          find_left = 'gsF',      -- Find surrounding (to the left)
          highlight = 'gsh',      -- Highlight surrounding
          replace = 'gsr',        -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`

          suffix_last = 'l',      -- Suffix to search with "prev" method
          suffix_next = 'n',      -- Suffix to search with "next" method
        },
        silent = true
      })
    end
  },
  {
    "echasnovski/mini.cursorword",
    enabled = not require("configs.utils").is_diff_mode(),
    ft = { "c", "cpp", "h", "hpp", "lua" },
    version = "*",
    init = function()
      -- NOTE: disable mini cursorword for some file type
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "NvimTree", "vista_kind", "vista_markdown", "markdown" },
        callback = function()
          vim.b.minicursorword_disable = true
        end,
      })
    end,
    config = function()
      require("mini.cursorword").setup({ delay = 500 })

      vim.api.nvim_set_hl(0, 'MiniCursorword', { bg = "#504945", bold = true })
      vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { underline = true })
    end
  },
  { 'nvim-mini/mini.comment', version = '*' },
}
