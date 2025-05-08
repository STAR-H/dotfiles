return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",                    desc = "Bufferline Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>",         desc = "Bufferline Delete Non-Pinned Buffers" },
      { "fj",         "<Cmd>BufferLinePick<CR>",                         desc = "Bufferline Pick Buffer" },
      { "fg",         "<Cmd>BufferLinePickClose<CR>",                    desc = "Bufferline Pick Buffer Close" },
      { "<leader>1",  "<Cmd>lua require'bufferline'.go_to(1, true)<CR>", desc = "Bufferline Go to buffer[1]" },
      { "<leader>2",  "<Cmd>lua require'bufferline'.go_to(2, true)<CR>", desc = "Bufferline Go to buffer[2]" },
      { "<leader>3",  "<Cmd>lua require'bufferline'.go_to(3, true)<CR>", desc = "Bufferline Go to buffer[3]" },
      { "<leader>4",  "<Cmd>lua require'bufferline'.go_to(4, true)<CR>", desc = "Bufferline Go to buffer[4]" },
      { "<leader>5",  "<Cmd>lua require'bufferline'.go_to(5, true)<CR>", desc = "Bufferline Go to buffer[5]" },
      { "<leader>6",  "<Cmd>lua require'bufferline'.go_to(6, true)<CR>", desc = "Bufferline Go to buffer[6]" },
      { "<leader>7",  "<Cmd>lua require'bufferline'.go_to(7, true)<CR>", desc = "Bufferline Go to buffer[7]" },
      { "<leader>8",  "<Cmd>lua require'bufferline'.go_to(8, true)<CR>", desc = "Bufferline Go to buffer[8]" },
      { "<leader>9",  "<Cmd>lua require'bufferline'.go_to(9, true)<CR>", desc = "Bufferline Go to buffer[9]" },
    },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup {
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          indicator = {
            icon = '⏽', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
          },
          diagnostics = false,
          -- numbers = "ordinal",  -- Comment this to disable show number in bufferline
          show_buffer_close_icons = false,
          always_show_bufferline = true,
          truncate_names = false,
          max_name_length = 25,
          max_prefix_length = 25,        -- prefix used when a buffer is de-duplicated
          show_duplicate_prefix = false, -- whether to show duplicate buffer prefix

          separator_style = "thick",
          sort_by = 'id',
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = false
            },
            {
              filetype = "vista_kind",
              text = "Symbol Outline",
              text_align = "center",
              separator = false
            },
            {
              filetype = "undotree",
              text = "UndoTree",
              text_align = "center",
              separator = false
            },
            {
              filetype = "vista_markdown",
              text = "Table of contents",
              text_align = "center",
              separator = false
            }
          },
          groups = {
            items = {
              require('bufferline.groups').builtin.pinned:with({ icon = "󰐃" })
            }
          },
          pick = {
            alphabet = "abcdefghijklmopqrstuvwxyz12345",
          },
        }
      }

      vim.api.nvim_set_hl(0, 'BufferLineIndicatorSelected', { bold = true, fg = '#3498DB' })
    end
  },

  {
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
              { find = "^mark%-?%d?%s?" }, -- vim-mark mark-1
              { find = ".(%w+)\\>$" },     -- vim-mark /\<xxxxx\>
              { find = "^%s?cleared" },    -- mark-1 cleared
              { find = "^Cleared%sall" },  -- all marks cleared
              { find = "^%d%s?$" },
              { find = "^/.*" }            --mark-1/word
            },
          },
          view = "mini",
          opts = { skip = true },
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search         = false, -- use a classic bottom cmdline for search
        long_message_to_split = false, -- long messages will be sent to a split
        lsp_doc_border        = true,  -- add a border to hover docs and signature help
      },
      throttle = 1000 / 30,            -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
      cmdline = {
        enabled = true,                -- enables the Noice cmdline UI
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
        enabled = true,      -- enables the Noice messages UI
        view_search = false, -- view for search count messages. Set to `false` to disable
      },
      health = {
        checker = true, -- Disable if you don't want health checks to run
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
        silent = false, -- set to true to not show a message if hover is not available
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
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
      "folke/noice.nvim"
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end

      vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#32302f' })
      -- lualine diff status highlight override
      vim.api.nvim_set_hl(0, 'stlDiffAdd',      { fg = '#b8bb26', bg = '#32302f' })
      vim.api.nvim_set_hl(0, 'stlDiffDelete',   { fg = '#fb4934', bg = '#32302f' })
      vim.api.nvim_set_hl(0, 'stlDiffModified', { fg = '#f18019', bg = '#32302f' })
    end,
    config = function()
      vim.o.laststatus = vim.g.lualine_laststatus
      local function diagnostics_component()
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.diagnostic.is_enabled() then
          return string.format("%%#LualineDiagOff#󰦞")
        end
        -- 获取当前缓冲区的诊断统计信息
        local diagnostics = vim.diagnostic.get(bufnr)
        local error_count = 0
        local warning_count = 0

        for _, diag in ipairs(diagnostics) do
          if diag.severity == vim.diagnostic.severity.ERROR then
            error_count = error_count + 1
          elseif diag.severity == vim.diagnostic.severity.WARN then
            warning_count = warning_count + 1
          end
        end

        if error_count == 0 and warning_count == 0 then
          return string.format("%%#LualineDiagOn#󰒘")
        elseif error_count == 0 and warning_count ~= 0 then
          return string.format("%%#LualineWarning# %d", warning_count)
        elseif error_count ~= 0 and warning_count == 0 then
          return string.format("%%#LualineError# %d", error_count)
        end

        return string.format("%%#LualineError# %d %%#LualineWarning# %d", error_count, warning_count)
      end

      vim.api.nvim_set_hl(0, "LualineError",   { fg = '#FF0000', bg = '#32302f', bold = true })
      vim.api.nvim_set_hl(0, "LualineWarning", { fg = '#FFA500', bg = '#32302f', bold = true })
      vim.api.nvim_set_hl(0, "LualineDiagOn",  { fg = '#93f542', bg = '#32302f' })
      vim.api.nvim_set_hl(0, "LualineDiagOff", { fg = '#FF0000', bg = '#32302f' })

      local diff = {
        'diff',
        colored = true, -- Displays a colored diff status if set to true
        diff_color = {
          -- Same color values as the general color option can be used here.
          added    = 'stlDiffAdd', -- Changes the diff's added color
          modified = 'stlDiffModified', -- Changes the diff's modified color
          removed  = 'stlDiffDelete', -- Changes the diff's removed color you
        },
        symbols = { added = '  ', modified = '  ', removed = '  ' }, -- Changes the symbols used by the diff.
      }

      local navic_status, navic = pcall(require, 'nvim-navic')
      local noice_status, noice = pcall(require, 'noice')

      require('lualine').setup {
        options = {
          icons_enabled        = true,
          theme                = 'gruvbox-material', --gruvbox-material / nord
          section_separators   = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes   = {
            statusline = { "nvdash" },
          },
          ignore_focus         = {
            "NvimTree",
            "tagbar",
            "undotree",
            "vista_kind",
            "vista_markdown",
            "trouble",
            "AvanteInput",
            "AvanteSelectedFiles",
            "Avante",
            "gitsigns-blame"
          },
          always_divide_middle = true,
          globalstatus         = true,
          refresh              = {
            statusline = 500,
            tabline    = 1000,
            winbar     = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { diagnostics_component, diff },
          lualine_c = {
            { 'filename',
              file_status = true,     -- Displays file status (readonly status, modified status)
              newfile_status = false, -- Display new file status (new file means no write after created)
              path = 1,
              symbols = {
                modified = '[+]',       -- Text to show when the file is modified.
                readonly = '[RO]',      -- Text to show when the file is non-modifiable or readonly.
                unnamed  = '[No Name]', -- Text to show for unnamed buffers.
                newfile  = '[New]',     -- Text to show for newly created file before first write
              },
            },
            -- Show @recording messages in statusline
            {
              function()
                return noice.api.status.mode.get()
              end,
              cond = function()
                if noice_status then
                  return noice.api.status.mode.has()
                else
                  return false
                end
              end,
              color = { fg = "#ff9e64" },
            },
          },
          lualine_x = {
            {
              function()
                if navic_status then
                  return navic.get_location()
                else
                  return
                end
              end,
              cond = function()
                if navic_status then
                  return navic.is_available()
                else
                  return
                end
              end
            },
            {
              function()
                local stbufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
                if rawget(vim, "lsp") then
                  for _, client in ipairs(vim.lsp.get_clients()) do
                    if client.attached_buffers[stbufnr] and client.name ~= "null-ls" then
                      return (vim.o.columns > 100 and "  " .. client.name .. " ") or " LSP "
                    end
                  end
                end

                return ""
              end,
              color = { fg = "#ff9e64" },

            },
            'filesize', 'filetype' },
          lualine_y = {
            {
              function()
                return " " .. vim.fn.fnamemodify(vim.g.project_root_dir, ':t')
              end,
              cond = function()
                if vim.g.project_root_dir == nil or vim.g.project_root_dir == "" then
                  return false
                else
                  return true
                end
              end,
              color = {
                bg = "#32302f",
                fg = "#458588",
              }
            },
            'selectioncount' },
          lualine_z = { 'progress' }
        },
        winbar = {},
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = {
            {
              function()
                if navic_status then
                  return navic.get_location()
                else
                  return
                end
              end,

              cond = function()
                if navic_status then
                  return navic.is_available()
                else
                  return
                end
              end,
            },
            'location' },
          lualine_y = {},
          lualine_z = {}
        },
        extensions = { 'quickfix', 'nvim-tree' }
      }
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    enabled = not require("configs.utils").is_diff_mode(),
    event = { "BufReadPost", "BufNewFile" },
    build = ":TsUpdate", -- auto update installed parser
    config = function()
      local opts = {
        ensure_installed = {
          "html",
          "python",
          "diff",
          "bash",
          "json",
          "vim",
          "lua",
          "c",
          "cpp",
          "markdown",
          "markdown_inline",
          "vim",
          "regex",
          "query",
        },
        sync_install = false,
        auto_install = false,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 1024 * 1024 -- 1MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = false }, -- influnce = indent
        incremental_selection = { enable = false },
        textobjects = { enable = true },
      }
      require 'nvim-treesitter.configs'.setup(opts)
    end,
  },

  {
    "folke/trouble.nvim",
    keys = {
      { "gr",         "<cmd>Trouble lsp_references focus=true<cr>",       desc = "LSP Go to References" },
      { "gd",         "<cmd>Trouble lsp_definitions focus=true<cr>",      desc = "LSP Go to Definitions" },
      { "gi",         "<cmd>Trouble lsp_implementations focus=true<cr>",  desc = "LSP Go to Implementations" },
      { "<leader>ld", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics list diagnostics info(current buffer)" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_close = true,       -- auto close when there are no items
      warn_no_results = false, -- show a warning when there are no results
    },
  },

  {
    'stevearc/dressing.nvim',
    event = "VeryLazy",
    opts = {
      input = {
        enabled = false,
      },
      select = {
        enabled = true,
        -- change codeaction telescope theme to get_cursor
        get_config = function(opts)
          if opts.kind == 'codeaction' then
            return {
              telescope = require('telescope.themes').get_cursor({})
            }
          end
        end,
      }
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end
  }
}
