return {
    "liuchengxu/vista.vim",
    keys = {
        { "<leader>t", "<cmd>Vista!!<cr>", desc = "[t]agbar Toggle" },
    },
    ft = {"cpp", "c", "python"},
    config = function()
        vim.g.vista_default_executive = 'ctags'
        vim.cmd("let g:vista_executive_for = {'cpp': 'ctags'}")
        vim.cmd("let g:vista#renderer#enable_icon = 1")
        vim.g.vista_sidebar_position = "vertical left"
        vim.g.vista_sidebar_open_cmd = 'leftabove 40vsplit'
        vim.g.vista_sidebar_width = 40
        vim.g.vista_echo_cursor = 0
        vim.g.vista_disable_statusline = 1
        vim.g.vista_blink = {0, 0}
        vim.cmd("highlight VistaTag guifg=#ebdbb2")
        vim.cmd("let g:vista#render#ctags = 'kind'")
        vim.cmd("let g:vista#renderer#ctags = 'kind'")
        vim.cmd("let g:vista#renderer#default#vlnum_offset = 3")
    end
}
