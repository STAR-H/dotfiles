return {
  "nvim-telescope/telescope.nvim",
  branch = '0.1.x',
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = 'telescope find files' },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = 'telescope live grep' },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = 'telescope list buffers' },
    { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = 'telescope fuzzy search' },
    { "<leader>ft", "<cmd>Telescope lsp_document_symbols<cr>",      desc = 'telescope current buffer tags' },
    { "<leader>z=",         "<cmd>Telescope spell_suggest<cr>",     { desc = 'telescope spell suggest', noremap = true } }
  },
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    local actions = require "telescope.actions"
    require('telescope').setup({
      defaults = {
        git_worktrees = vim.g.project_root_dir, -- use project.nvim update root dir
        color_devicons = false,
        prompt_prefix = "  ",
        selection_caret = "  ",
        path_display = { shorten = { len = 2, exclude = { -1, -2 } } },
        sorting_strategy = "descending",
        vimgrep_arguments = { -- use by live grep and grep string
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim"                    --remove indentation
        },
        layout_strategy = 'vertical', -- horizontal or vertical
        layout_config = {
          horizontal = {
            prompt_position = "bottom",
            preview_width = 0.6,
            width = 0.9,
            height = 0.8,
            preview_cutoff = 120
          },
          vertical = {
            mirror = false,
            preview_height = 0.75,
            width = 0.7,
            height = 0.9,
            preview_cutoff = 40
          },
        },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-e>"] = actions.close,
          },
          n = {
            ["<C-e>"] = actions.close,
            ["q"]     = actions.close,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          cwd = vim.g.project_root_dir,
          prompt_title = "Find Files at (" .. vim.fn.fnamemodify(vim.g.project_root_dir, ':t') .. ")"
        },
        buffers = {
          prompt_title = "Switch Buffers",
          sort_lastused = true,
          theme = "dropdown",
          previewer = false,
          ignore_current_buffer = false,
        },
        commands = {
          theme = "dropdown",
          previewer = false,
        },
        live_grep = {
          disable_coordinates = true,
          cwd = vim.g.project_root_dir,
          prompt_title = "Live Grep at (" .. vim.fn.fnamemodify(vim.g.project_root_dir, ':t') .. ")"
        },
        current_buffer_fuzzy_find = {
          skip_empty_lines = true,
          results_ts_highlight = false,
        },
        spell_suggest = {
          prompt_title = "Spell Suggestion",
          theme = "cursor",
          layout_config = {
            width = 0.2,
            height = 0.1
          }
        },
        lsp_document_symbols = {
          symbol_width = 60,
          symbol_type_width = 10,
        }
      },
    })

    -- load the extension here
    require('telescope').load_extension('bookmarks')
    require("telescope").load_extension("fzf")
  end
}
