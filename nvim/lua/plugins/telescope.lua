return {
    -- TODO: add picker for search in current buffer
    -- and optimate the live grep behavior
    "nvim-telescope/telescope.nvim", branch = '0.1.x',
    keys = {
        {"<leader>ff"},
        {"<leader>fg"},
        {"<leader>fb"},
        {"<leader>ft"},
        {"<leader>fc"},
        -- {"<leader>ff", "<cmd>lua require('telescope.builtin).find_files<cr>", desc = 'telescope find files'},
        -- {"<leader>fg", "<cmd>lua require('telescope.builtin).live_grep<cr>", desc = 'telescope live grep'},
        -- {"<leader>fb", "<cmd>lua require('telescope.builtin).buffers<cr>", desc = 'telescope list buffers'},
        -- {"<leader>ft", "<cmd>lua require('telescope.builtin).current_buffer_fuzzy_find<cr>", desc = 'telescope fuzzy search'},
        -- {"<leader>fc", "<cmd>lua require('telescope.builtin).commands<cr>", desc = 'telescope list available commands'},
    },
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local actions = require "telescope.actions"
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>ff', builtin.find_files, { noremap = true, nowait = true, desc = 'telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { noremap = true, nowait = true, desc = 'telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers,    { noremap = true, nowait = true, desc = 'telescope list buffers' })
        vim.keymap.set('n', '<leader>ft', builtin.current_buffer_fuzzy_find, { noremap = true, nowait = true, desc = 'telescope fuzzy search' })
        vim.keymap.set('n', '<leader>fc', builtin.commands, { noremap = true, nowait = true, desc = 'telescope list available commands' })
        require("telescope").load_extension("fzf")
        require('telescope').setup ({
            defaults = {
                git_worktrees = vim.g.git_worktrees,
                color_devicons = false,
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
                    width = 0.9,
                    height = 0.9,
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
            pickers = {
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    ignore_current_buffer=true,
                },
                commands = {
                    theme = "dropdown",
                    previewer = false,
                },
                live_grep = {
                    disable_coordinates =false,
                },
                current_buffer_fuzzy_find = {
                    skip_empty_lines = true,
                }
            },
        })
    end
}
