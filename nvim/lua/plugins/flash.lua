return {
    "folke/flash.nvim",
    config = function()
        vim.keymap.set("n", '<leader>s', function() require("flash").jump() end, {noremap = true, silent = true})
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
            labels = "asdfghjklqwertyuiopzxcvbnm",
            label = {
                -- allow uppercase labels
                uppercase = false,
                -- add any labels with the correct case here, that you want to exclude
                exclude = "",
                -- add a label for the first match in the current window.
                -- you can always jump to the first match with `<CR>`
                current = true,
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
            modes = {
                -- options used when flash is activated through
                -- a regular search with `/` or `?`
                search = {
                    -- when `true`, flash will be activated during regular search by default.
                    -- You can always toggle when searching with `require("flash").toggle()`
                    enabled = false,
                    highlight = { backdrop = false },
                    jump = { history = true, register = true, nohlsearch = true },
                    search = {
                        -- `forward` will be automatically set to the search direction
                        -- `mode` is always set to `search`
                        -- `incremental` is set to `true` when `incsearch` is enabled
                    },
                },
                -- options used when flash is activated through
                -- `f`, `F`, `t`, `T`, `;` and `,` motions
                char = {
                    enabled = true,
                    -- dynamic configuration for ftFT motions
                    config = function(opts)
                        -- autohide flash when in operator-pending mode
                        opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

                        -- disable jump labels when enabled and when using a count
                        opts.jump_labels = opts.jump_labels and vim.v.count == 0

                        -- Show jump labels only in operator-pending mode
                        -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
                    end,
                    -- hide after jump when not using jump labels
                    autohide = false,
                    -- show jump labels
                    jump_labels = true,
                    -- set to `false` to use the current line only
                    multi_line = false,
                    -- When using jump labels, don't use these keys
                    -- This allows using those keys directly after the motion
                    label = { exclude = "hjkliardc" },
                    -- by default all keymaps are enabled, but you can disable some of them,
                    -- by removing them from the list.
                    -- If you rather use another key, you can map them
                    -- to something else, e.g., { [";"] = "L", [","] = H }
                    keys = { "f", "F", },
                    ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
                    -- The direction for `prev` and `next` is determined by the motion.
                    -- `left` and `right` are always left and right.
                    char_actions = function(motion)
                        return {
                            ["j"] = "next", -- set to `right` to always go right
                            ["k"] = "prev", -- set to `left` to always go left
                            -- clever-f style
                            [motion:lower()] = "next",
                            [motion:upper()] = "prev",
                            -- jump2d style: same case goes next, opposite case goes prev
                            -- [motion] = "next",
                            -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
                        }
                    end,
                    search = { wrap = true },
                    highlight = { backdrop = true },
                    jump = { register = false },
                },
            },
        })

        vim.cmd[[:hi FlashLabel cterm=bold gui=bold guifg=#FFFFFF guibg=#D80835]]
    end
}
