return {
    "nvim-telescope/telescope.nvim", tag = '0.1.2',
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local actions = require "telescope.actions"
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true, nowait = true })
        vim.keymap.set('n', '<C-f>', builtin.live_grep,  { noremap = true, nowait = true })
        vim.keymap.set('n', '<C-b>', builtin.buffers,    { noremap = true, nowait = true })
        require("telescope").load_extension("fzf")
        require('telescope').setup ({
            defaults = {
                git_worktrees = vim.g.git_worktrees,
                color_devicons = true,
                prompt_prefix = "  ",
                selection_caret = "  ",
                path_display = { "truncate" },
                sorting_strategy = "descending",
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim" --remove indentation
                },
                layout_config = {
                    horizontal = { prompt_position = "bottom", preview_width = 0.6 },
                    vertical = { mirror = false },
                    width = 0.95,
                    height = 0.95,
                    preview_cutoff = 120,
                },
                mappings = {
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-e>"] = actions.close,
                    },
                    n = { ["<C-e>"] = actions.close },
                },
            },
        })
    end
}
