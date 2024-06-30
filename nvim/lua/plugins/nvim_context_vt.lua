return {
    "andersevenrud/nvim_context_vt",
    event = "VeryLazy",
    config = function()
        require('nvim_context_vt').setup({
            enabled = true,

            prefix = ' 𝓮𝓷𝓭 𝓸𝓯',

            highlight = 'markdownLinkText',

            disable_ft = { 'markdown' },

            disable_virtual_lines = false,

            disable_virtual_lines_ft = { 'yaml' },

            min_rows = 10,
        })


    end,
}
