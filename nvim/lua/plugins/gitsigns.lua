---Git integration: gutter signs, blame, hunk navigation.
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  enabled = function()
    -- TODO: add is unix to combiand mocos or linux
    local platform = require("configs.platform")

    return not require("configs.utils").is_diff_mode()
        and platform.is_unix
  end,
  config = function()
    require("gitsigns").setup {
      signs                        = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "-", show_count = true },
        topdelete    = { text = "▔", show_count = true },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      count_chars                  = {
        [1] = "₁",
        [2] = "₂",
        [3] = "₃",
        [4] = "₄",
        [5] = "₅",
        [6] = "₆",
        [7] = "₇",
        [8] = "₈",
        [9] = "₉",
        ['+'] = "₊",
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      attach_to_untracked          = true,
      -- PERF: disabel line blame by default  for performance
      current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = true,
      },
      -- current_line_blame_formatter = '<author> (<author_time:%R>):<summary>',
      current_line_blame_formatter = "<abbrev_sha> <author> · <author_time:%Y-%m-%d> · <summary>",
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
      },
      on_attach                    = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end
        -- Navigation
        map('n', ']g', "&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
        map('n', '[g', "&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
        map('n', 'gs', '<Cmd>Gitsigns preview_hunk<CR>')
        map('n', 'gu', '<Cmd>Gitsigns reset_hunk<CR>')
        map('v', 'gu', '<Cmd>Gitsigns reset_hunk<CR>')
        map('n', '<leader>gb', '<Cmd>Gitsigns toggle_current_line_blame<CR>')
      end
    }
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#a89984" })
  end
}
