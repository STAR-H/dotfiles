return {
    "andersevenrud/nvim_context_vt",
    event = "VeryLazy",
    ft = { 'c', 'cpp', 'lua', 'python' },
    config = function()
        vim.api.nvim_set_hl(0, 'CustomContextVt', { fg = '#928374', bold = true, italic = true })
        require('nvim_context_vt').setup({
            enabled = true,
            prefix = '󰞘 𝓮𝓷𝓭 𝓸𝓯',
            highlight = 'CustomContextVt',
            disable_ft = { 'markdown' },
            disable_virtual_lines = false,
            disable_virtual_lines_ft = { 'yaml' },
            min_rows = 10,
        })
    end,
}
