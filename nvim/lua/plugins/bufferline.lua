return {
    "akinsho/bufferline.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup {
            options = {
                mode = "buffers", -- set to "tabs" to only show tabpages instead
                indicator = {
                    style = 'underline',
                },
                diagnostics = false,
                numbers = "ordinal",
                show_buffer_close_icons = false,
                always_show_bufferline = true,
                truncate_names = false,
                max_name_length = 25,
                max_prefix_length = 25,        -- prefix used when a buffer is de-duplicated
                show_duplicate_prefix = false, -- whether to show duplicate buffer prefix

                separator_style = "thick",
                sort_by = 'id',
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true
                    },
                    {
                        filetype = "vista_kind",
                        text = "Symbol Outline",
                        text_align = "center",
                        separator = true
                    },
                    {
                        filetype = "undotree",
                        text = "UndoTree",
                        text_align = "center",
                        separator = true
                    }
                },
                groups = {
                    items = {
                        require('bufferline.groups').builtin.pinned:with({ icon = "" })
                    }
                }
            }
        }

        local keymap = vim.keymap.set
        local function opts(descs)
            return { desc = descs, noremap = true, silent = true, nowait = true }
        end
        keymap("n", "<leader>1", ":lua require'bufferline'.go_to(1, true)<CR>", opts("Go to buffer[1]"))
        keymap("n", "<leader>2", ":lua require'bufferline'.go_to(2, true)<CR>", opts("Go to buffer[2]"))
        keymap("n", "<leader>3", ":lua require'bufferline'.go_to(3, true)<CR>", opts("Go to buffer[3]"))
        keymap("n", "<leader>4", ":lua require'bufferline'.go_to(4, true)<CR>", opts("Go to buffer[4]"))
        keymap("n", "<leader>5", ":lua require'bufferline'.go_to(5, true)<CR>", opts("Go to buffer[5]"))
        keymap("n", "<leader>6", ":lua require'bufferline'.go_to(6, true)<CR>", opts("Go to buffer[6]"))
        keymap("n", "<leader>7", ":lua require'bufferline'.go_to(7, true)<CR>", opts("Go to buffer[7]"))
        keymap("n", "<leader>8", ":lua require'bufferline'.go_to(8, true)<CR>", opts("Go to buffer[8]"))
        keymap("n", "<leader>9", ":lua require'bufferline'.go_to(9, true)<CR>", opts("Go to buffer[9]"))
        keymap("n", "bp", ":BufferLineTogglePin<CR>", opts("Toggle [b]uffer [p]in"))
    end
}
