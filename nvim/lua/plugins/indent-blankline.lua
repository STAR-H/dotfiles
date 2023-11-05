return {
    "lukas-reineke/indent-blankline.nvim",
    tag = "v2.20.8",
    config = function()
        require("indent_blankline").setup {
            -- for example, context is off by default, use this to turn it on
            show_current_context = false,
            show_current_context_start = false,
            show_first_indent_level = false,
            use_treesitter_scope = true,
        }
        vim.g.indent_blankline_filetype = {'c', 'cpp', 'h', 'lua'}

    end
}
