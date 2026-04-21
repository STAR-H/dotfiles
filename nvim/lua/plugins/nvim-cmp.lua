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
      {
        "uga-rosa/cmp-dictionary",
        config = function()
          -- 定义词典保存路径
          local dict_path = vim.fn.stdpath('config') .. '/dictionary/words_alpha.txt'

          require("cmp_dictionary").setup({
            paths = { dict_path, },
            exact_length = 2,
          })
        end
      },
      --- snippets plugins
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        config = function()
          local snippetpath = vim.fn.stdpath("config") .. "/snippets"
          require("luasnip.loaders.from_snipmate").lazy_load({ paths = snippetpath })
        end
      },
    },
    config = function()
      local cmp = require 'cmp'
      local compare = require("cmp.config.compare")
      local luasnip = require('luasnip')

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

        experimental = { ghost_text = true },

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          -- use super tab
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ["<Tab>"] = cmp.mapping(function(fallback)
            -- if cmp.visible() then
            --   cmp.select_next_item()
            -- elseif luasnip.locally_jumpable(1) then
            --   luasnip.jump(1)
            -- else
            --   fallback()
            -- end

            if luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            -- if cmp.visible() then
            --   cmp.select_prev_item()
            -- elseif luasnip.locally_jumpable(-1) then
            --   luasnip.jump(-1)
            -- else
            --   fallback()
            -- end

            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
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
              abbr = 40,
              menu = 30,
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
        performance = {
          max_view_entries = 15,
        }
      }

      cmp.setup(options)

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
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

      cmp.setup.filetype({ 'markdown', 'Avante' }, {
        sources = {
          { name = 'nvim_lsp',        group_index = 1, priority = 100 },
          { name = 'luasnip',         group_index = 1, priority = 100 },
          { name = 'render-markdown', group_index = 1, priority = 100 },
          { name = 'buffer',          group_index = 3, priority = 40 },
          { name = 'path',            group_index = 3, priority = 40 },
          {
            name = "dictionary",
            keyword_length = 2,
            group_index = 2,
            priority = 80
          },
        }
      })
      -- override the deprecate abbr item highlight add strikethrough line
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecatedDefault', { bg = 'NONE', strikethrough = true, fg = '#656565' })
    end
  },
}
