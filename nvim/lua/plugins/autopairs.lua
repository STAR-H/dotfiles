return {
    "windwp/nvim-autopairs",
    lazy = true,
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            enable_check_bracket_line = false,
            disable_filetype = { "TelescopePrompt" , "vim" },
        })
        local npairs = require('nvim-autopairs')
        npairs.setup({map_cr=false})

        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        local cmp_status_ok, cmp = pcall(require, "cmp")
        if not cmp_status_ok then
            return
        end
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end
}
