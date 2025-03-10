return {
  {
    "hrsh7th/nvim-cmp",
    enabled = not require("configs.utils").is_diff_mode(),
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      --- snippets plugins
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
          vim.keymap.set({ "i" }, "<C-j>", function() ls.expand() end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(1) end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-k>", function() ls.jump(-1) end, { silent = true })
        end
      },
    },
    config = function()
      local cmp = require 'cmp'
      local compare = require("cmp.config.compare")

      local options = {
        snippet = {
          expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
          end,
        },

        window = {
          completion = {
            max_width = 70,
            scrollbar = false,
            border = "none",
          },
          documentation = {
            max_width = 120,
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
          },
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>']  = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- use super tab uncomment below
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
        }),

        sources = cmp.config.sources(
          {
            {
              name = 'nvim_lsp',
              keyword_length = 2,
              -- remove lsp snippet item from completion list
              entry_filter = function(entry)
                return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
              end
            },
            { name = 'luasnip', },
            { name = 'nvim_lua' },
          },

          {
            { name = 'buffer', keyword_length = 3 },
          },

          {
            { name = 'path', keyword_length = 3 },
          },

          {
            { name = 'render-markdown' },
          }
        ),

        formatting = {
          fields = { "abbr", "menu", "kind" },
          format = function(entry, item)
            local icons = require "nvchad.icons.lspkind"
            local icon = icons[item.kind] or ""
            local kind = item.kind or ""

            item.kind = icon .. " " .. kind

            local widths = {
              abbr = 30,
              menu = 40,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
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
      }
      cmp.setup(options)

      -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        completion = { autocomplete = false },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          })
      })
    end
  },
}
