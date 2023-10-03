return {
 "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  dependencies = {
      "MunifTanjim/nui.nvim",
  },
  config = function ()
      require("noice").setup({
          lsp = {
              -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
              override = {
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                  ["vim.lsp.util.stylize_markdown"] = true,
                  ["cmp.entry.get_documentation"] = true,
              },
              -- defaults for hover and signature help
              documentation = {
                  view = "hover",
                  ---@type NoiceViewOptions
                  opts = {
                      lang = "markdown",
                      replace = true,
                      render = "plain",
                      format = { "{message}" },
                      win_options = { concealcursor = "n", conceallevel = 3 },
                  },
              },
          },
          -- you can enable a preset for easier configuration
          presets = {
              bottom_search         = false, -- use a classic bottom cmdline for search
              command_palette       = false, -- position the cmdline and popupmenu together
              long_message_to_split = false, -- long messages will be sent to a split
              inc_rename            = false, -- enables an input dialog for inc-rename.nvim
              lsp_doc_border        = true,  -- add a border to hover docs and signature help
          },
          cmdline = {
              enabled = true, -- enables the Noice cmdline UI
              view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
              format = {
                  cmdline     = { pattern = "^:", icon = "", lang = "vim" },
                  search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
                  search_up   = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
                  filter      = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                  lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                  help        = { pattern = "^:%s*he?l?p?%s+", icon = "󰛵 " },
              },
          },
          messages = {
              -- NOTE: If you enable messages, then the cmdline is enabled automatically.
              -- This is a current Neovim limitation.
              enabled = true, -- enables the Noice messages UI
              view_search = false, -- view for search count messages. Set to `false` to disable
          },
          markdown = {
              hover = {
                  ["|(%S-)|"] = vim.cmd.help, -- vim help links
                  ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
              },
              highlights = {
                  ["|%S-|"] = "@text.reference",
                  ["@%S+"] = "@parameter",
                  ["^%s*(Parameters:)"] = "@text.title",
                  ["^%s*(Return:)"] = "@text.title",
                  ["^%s*(See also:)"] = "@text.title",
                  ["{%S-}"] = "@parameter",
              },
          },
          health = {
              checker = false, -- Disable if you don't want health checks to run
          },
          views = {
              mini = {
                  timeout = 3000,
              },
          },
          hover = {
              enabled = true,
              silent = true, -- set to true to not show a message if hover is not available
          },
      })
  end
}
