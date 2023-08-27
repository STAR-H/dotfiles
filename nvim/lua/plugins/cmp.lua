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
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "saadparwaiz1/cmp_luasnip",
                "STAR-H/vim-snippets",
            },
            config = function()
                local snippetpath = vim.fn.stdpath("data") .. "/lazy/vim-snippets/snippets"
                require("luasnip.loaders.from_snipmate").lazy_load({ paths = snippetpath })
                local ls = require('luasnip')
                vim.keymap.set({ "i" }, "<Tab>", function() ls.expand() end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<Tab>", function() ls.jump(1) end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<S-Tab>", function() ls.jump(-1) end, { silent = true })
            end
        },
    },
    config = function()
        local cmp = require 'cmp'
        local compare = require("cmp.config.compare")
        local kind_icons = {
            Text          = "󰉿「Text」",
            Method        = "ƒ「Method」",
            Function      = "󰊕「Function」",
            Constructor   = "「Constructor」",
            Field         = "󰮄「Field」",
            Variable      = "󰀫「Variable」",
            Class         = "󰠱「Class」",
            Interface     = "「Interface」",
            Module        = "「Module」",
            Property      = "󰜢「Property」",
            Unit          = "󰑭「Unit」",
            Value         = "󰎠「Value」",
            Enum          = "「Enum」",
            Keyword       = "󰌋「Keyword」",
            Snippet       = "「Snippet」",
            Color         = "󰏘「Color」",
            File          = "󰈙「File」",
            Reference     = "「Reference」",
            Folder        = "󰉋「Folder」",
            EnumMember    = "「EnumMember」",
            Constant      = "󰏿「Constant」",
            Struct        = "󰆧「Struct」",
            Event         = "「Event」",
            Operator      = "󰆕「Operator」",
            TypeParameter = "「TypeParameter」",
            Misc          = "「Misc」",
        }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require 'luasnip'.lsp_expand(args.body)
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                completion = { max_width = 80 },
                documentation = {
                    max_width = 120,
                },
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                -- ["<Tab>"]   = cmp.mapping({
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
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>']  = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        keyword_length = 3,
                        -- remove lsp snippet item from completion list
                        entry_filter = function(entry)
                            return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
                        end
                    },
                    { name = 'luasnip',  keyword_length = 3 },
                    { name = 'nvim_lua' },
                },
                {
                    { name = 'buffer', keyword_length = 3 },
                },
                {
                    { name = 'path' },
                }),
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                    -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip  = "[SINP]",
                        buffer   = "[BUF]",
                        path     = "[PATH]",
                        nvim_lua = "[API]",
                    })[entry.source.name]
                    local function trim(text)
                        local max_width = 50
                        if text and text:len() > max_width then
                            text = text:sub(1, max_width) .. "..."
                        end
                        return text
                    end
                    vim_item.abbr = trim(vim_item.abbr)
                    return vim_item
                end,
            },
            view = {
                entries = { name = 'custom', selection_order = 'near_cursor' }
            },
            sorting = {
                comparators = {
                    compare.exact,
                    compare.length,
                },
            },
            matching = {
                disallow_fuzzy_matching         = true,
                disallow_fullfuzzy_matching     = true,
                disallow_partial_fuzzy_matching = true,
                disallow_partial_matching       = false,
                disallow_prefix_unmatching      = false,
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
