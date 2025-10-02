return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",                    desc = "Bufferline Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>",         desc = "Bufferline Delete Non-Pinned Buffers" },
    { "fj",         "<Cmd>BufferLinePick<CR>",                         desc = "Bufferline Pick Buffer" },
    { "fg",         "<Cmd>BufferLinePickClose<CR>",                    desc = "Bufferline Pick Buffer Close" },
    { "<leader>1",  "<Cmd>lua require'bufferline'.go_to(1, true)<CR>", desc = "Bufferline Go to buffer[1]" },
    { "<leader>2",  "<Cmd>lua require'bufferline'.go_to(2, true)<CR>", desc = "Bufferline Go to buffer[2]" },
    { "<leader>3",  "<Cmd>lua require'bufferline'.go_to(3, true)<CR>", desc = "Bufferline Go to buffer[3]" },
    { "<leader>4",  "<Cmd>lua require'bufferline'.go_to(4, true)<CR>", desc = "Bufferline Go to buffer[4]" },
    { "<leader>5",  "<Cmd>lua require'bufferline'.go_to(5, true)<CR>", desc = "Bufferline Go to buffer[5]" },
    { "<leader>6",  "<Cmd>lua require'bufferline'.go_to(6, true)<CR>", desc = "Bufferline Go to buffer[6]" },
    { "<leader>7",  "<Cmd>lua require'bufferline'.go_to(7, true)<CR>", desc = "Bufferline Go to buffer[7]" },
    { "<leader>8",  "<Cmd>lua require'bufferline'.go_to(8, true)<CR>", desc = "Bufferline Go to buffer[8]" },
    { "<leader>9",  "<Cmd>lua require'bufferline'.go_to(9, true)<CR>", desc = "Bufferline Go to buffer[9]" },
  },
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup {
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        indicator = {
          icon = '⏽', -- this should be omitted if indicator style is not 'icon'
          style = 'icon',
        },
        diagnostics = false,
        -- numbers = "ordinal",  -- Comment this to disable show number in bufferline
        show_buffer_close_icons = false,
        always_show_bufferline = true,
        truncate_names = false,
        max_name_length = 25,
        max_prefix_length = 25,          -- prefix used when a buffer is de-duplicated
        show_duplicate_prefix = false,   -- whether to show duplicate buffer prefix

        separator_style = "thick",
        sort_by = 'id',
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = false
          },
          {
            filetype = "vista_kind",
            text = "Symbol Outline",
            text_align = "center",
            separator = false
          },
          {
            filetype = "undotree",
            text = "UndoTree",
            text_align = "center",
            separator = false
          },
          {
            filetype = "vista_markdown",
            text = "Table of contents",
            text_align = "center",
            separator = false
          }
        },
        groups = {
          items = {
            require('bufferline.groups').builtin.pinned:with({ icon = "󰐃" })
          }
        },
        pick = {
          alphabet = "abcdefghijklmopqrstuvwxyz12345",
        },
      }
    }

    vim.api.nvim_set_hl(0, 'BufferLineIndicatorSelected', { bold = true, fg = '#3498DB' })
  end
}
