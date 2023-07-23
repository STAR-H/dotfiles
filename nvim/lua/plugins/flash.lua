return {
    "folke/flash.nvim",
    config = function()
        vim.keymap.set("n", 's', function() require("flash").jump() end, {noremap = true, silent = true})
        require("flash").setup({
            jump = {
                -- save location in the jumplist
                jumplist = false,
                -- jump position
                pos = "start", ---@type "start" | "end" | "range"
                -- add pattern to search history
                history = false,
                -- add pattern to search register
                register = false,
                -- clear highlight after jump
                nohlsearch = false,
                -- automatically jump when there is only one match
                autojump = false,
                -- You can force inclusive/exclusive jumps by setting the
                -- `inclusive` option. By default it will be automatically
                -- set based on the mode.
                inclusive = nil, ---@type boolean?
                -- jump position offset. Not used for range jumps.
                -- 0: default
                -- 1: when pos == "end" and pos < current position
                offset = nil, ---@type number
            },
            label = {
                -- allow uppercase labels
                uppercase = true,
                -- add any labels with the correct case here, that you want to exclude
                exclude = "",
                -- add a label for the first match in the current window.
                -- you can always jump to the first match with `<CR>`
                current = false,
                -- show the label after the match
                after = true, ---@type boolean|number[]
                -- show the label before the match
                before = false, ---@type boolean|number[]
                -- position of the label extmark
                style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
                -- flash tries to re-use labels that were already assigned to a position,
                -- when typing more characters. By default only lower-case labels are re-used.
                reuse = "lowercase", ---@type "lowercase" | "all" | "none"
                -- for the current window, label targets closer to the cursor first
                distance = true,
                -- minimum pattern length to show labels
                -- Ignored for custom labelers.
                min_pattern_length = 0,
                -- Enable this to use rainbow colors to highlight labels
                -- Can be useful for visualizing Treesitter ranges.
                rainbow = {
                    enabled = false,
                    -- number between 1 and 9
                    shade = 5,
                },
            },
        })

        vim.cmd[[:hi FlashLabel cterm=bold gui=bold guifg=#FFFFFF guibg=#D80835]]
    end
}
