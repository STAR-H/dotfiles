return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lua",
        "folke/neodev.nvim",
        "SirVer/ultisnips",
    },
    config = function()
        local cmp = require'cmp'
        local kind_icons = {
            Text          = "󰉿",
            Method        = "ƒ",
            Function      = "󰊕",
            Constructor   = "",
            Field         = "",
            Variable      = "󰀫",
            Class         = "󰠱",
            Interface     = "",
            Module        = "",
            Property      = "󰜢",
            Unit          = "󰑭",
            Value         = "󰎠",
            Enum          = "",
            Keyword       = "󰌋",
            Snippet       = "",
            Color         = "󰏘",
            File          = "󰈙",
            Reference     = "",
            Folder        = "󰉋",
            EnumMember    = "",
            Constant      = "󰏿",
            Struct        = "󰆧",
            Event         = "",
            Operator      = "󰆕",
            TypeParameter = "",
            Misc          = "",
        }
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                completion = {max_width = 80},
                documentation = {
                    max_width = 150,
                },
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"]     = cmp.mapping.select_prev_item(),
                ["<C-j>"]     = cmp.mapping.select_next_item(),
                -- ["<Tab>"] = cmp.mapping({
                --     c = function()
                --         if cmp.visible() then
                --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                --         else
                --             cmp.complete()
                --         end
                --     end,
                --     i = function(fallback)
                --         if cmp.visible() then
                --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                --         else
                --             fallback()
                --         end
                --     end,
                -- }),
                -- ["<S-Tab>"] = cmp.mapping({
                --     c = function()
                --         if cmp.visible() then
                --             cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                --         else
                --             cmp.complete()
                --         end
                --     end,
                --     i = function(fallback)
                --         if cmp.visible() then
                --             cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                --         else
                --             fallback()
                --         end
                --     end,
                -- }),
                ['<C-b>']     = cmp.mapping.scroll_docs(-4),
                ['<C-f>']     = cmp.mapping.scroll_docs(4),
                ['<C-e>']     = cmp.mapping.abort(),
                ['<CR>']      = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'nvim_lua'},
            }),
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                    -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip  = "[SINP]",
                        buffer   = "[BUF]",
                        path     = "[PATH]",
                        nvim_lua = "[Lua]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            view = {
                entries = {name = 'custom', selection_order = 'near_cursor' }
            },
        })
        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            completion = { autocomplete = false },
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })
    end
}