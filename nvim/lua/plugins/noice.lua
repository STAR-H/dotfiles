return {
  "folke/noice.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      -- need this config for hover and signature help
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
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          any = {
            { find = "^mark%-?%d?%s?" },   -- vim-mark mark-1
            { find = ".(%w+)\\>$" },       -- vim-mark /\<xxxxx\>
            { find = "^%s?cleared" },      -- mark-1 cleared
            { find = "^Cleared%sall" },    -- all marks cleared
            { find = "^%d%s?$" },
            { find = "^/.*" },             -- mark-1/word
            { find = "^.*EasyAlign.*" }     -- EasyAlign
          },
        },
        opts = { skip = true },
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search         = false,   -- use a classic bottom cmdline for search
      long_message_to_split = false,   -- long messages will be sent to a split
      lsp_doc_border        = true,    -- add a border to hover docs and signature help
    },
    throttle = 1000 / 30,              -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
    cmdline = {
      enabled = true,                  -- enables the Noice cmdline UI
      format = {
        cmdline     = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up   = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter      = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help        = { pattern = "^:%s*he?l?p?%s+", icon = "󰘥 " },
        input       = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
      },
    },
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,        -- enables the Noice messages UI
      view_search = false,   -- view for search count messages. Set to `false` to disable
    },
    health = {
      checker = true,   -- Disable if you don't want health checks to run
    },
    views = {
      mini = {
        timeout = 3000,
        align = "message-left",
        position = {
          row = -1,
          col = "50%",
          -- col = 0,
        },
        win_options = {
          winblend = 0,
        }
      },
      confirm = {
        position = {
          row = "50%",
          col = "50%",
        },
      },
    },
    hover = {
      enabled = true,
      silent = false,   -- set to true to not show a message if hover is not available
    },
  },

  config = function(_, opts)
    -- HACK: noice shows messages from before it was enabled,
    -- but this is not ideal when Lazy is installing plugins,
    -- so clear the messages in this case.
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end
}
