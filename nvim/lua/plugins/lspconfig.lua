return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    dependencies = "williamboman/mason-lspconfig.nvim",
    config = function()
      local settings = {
        PATH = "skip",
        ui = {
          icons = {
            package_pending = " ",
            package_installed = " ",
            package_uninstalled = " ",
          },
        },
        max_concurrent_installers = 4,
      }
      local servers = {
        "clangd",
        "cmake",
        "lua_ls",
        "bashls",
      }
      require("mason").setup(settings)
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    enabled = not require("configs.utils").is_diff_mode(),
    config = function()
      require("configs.handlers").defaults()

      local lspconfig = require "lspconfig"
      local lsphandlers = require("configs.handlers")

      local servers = { "clangd", "cmake", "bashls", }

      -- lsps with default config
      local opts = {}
      for _, server in pairs(servers) do
        opts = {
          on_attach = lsphandlers.on_attach,
          on_init = lsphandlers.on_init,
          capabilities = lsphandlers.capabilities,
        }

        server = vim.split(server, "@")[1]

        local require_ok, self_conf = pcall(require, "configs.lsp." .. server)
        if require_ok then
          opts = vim.tbl_deep_extend("keep", self_conf, opts)
        end

        lspconfig[server].setup(opts)
      end

      -- configuring single server
      lspconfig.lua_ls.setup {
        on_attach = lsphandlers.on_attach,
        capabilities = lsphandlers.capabilities,
        on_init = lsphandlers.on_init,

        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      }
    end,
  },

  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      -- PERF: Set it to true to update context only on CursorHold event. Could be usefull if
      -- you are facing performance issues on large files. Example usage
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.api.nvim_buf_line_count(0) > 10000 then
            vim.b.navic_lazy_update_context = true
          end
        end,
      })
    end,
    config = function()
      require("nvim-navic").setup {
        icons = {
          File          = "󰈙 ",
          Module        = " ",
          Namespace     = "󰦮 ",
          Package       = " ",
          Class         = " ",
          Method        = "ƒ ",
          Property      = "󰜢 ",
          Field         = " ",
          Constructor   = " ",
          Enum          = " ",
          Interface     = " ",
          Function      = "󰊕 ",
          Variable      = "󰀫 ",
          Constant      = "󰏿 ",
          String        = " ",
          Number        = "󰎠 ",
          Boolean       = "󰨙 ",
          Array         = "󰅪 ",
          Object        = "󰅩 ",
          Key           = "󰌋 ",
          Null          = "󰟢 ",
          EnumMember    = " ",
          Struct        = "󰆧 ",
          Event         = " ",
          Operator      = " ",
          TypeParameter = " ",
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = false,
        separator = " > ",
        depth_limit = 10,
        depth_limit_indicator = "..",
        safe_output = true,
        click = true
      }
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    enabled = false,
    event = "VeryLazy",
    ft = { "cpp", "c" },
    config = function()
      local null_ls = require("null-ls")
      local helpers = require("null-ls.helpers")
      local clang_tidy_conf = vim.fn.stdpath('config') .. "/lua/configs/lsp/clang-tidy"

      local clang_tidy = {
        name = "clang-tidy",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "cpp", "c" },
        generator = null_ls.generator({
          command = "clang-tidy",
          args = {
            "--config-file=" .. clang_tidy_conf,
            "$FILENAME",
          },
          to_temp_file = true,
          ignore_stderr = true,
          ignore_stdout = false,
          timeout = 2000,
          format = "line",
          check_exit_code = function(code)
            return code >= 1
          end,
          -- use helpers to parse the output from string matchers,
          -- or parse it manually with a function
          on_output = helpers.diagnostics.from_pattern([[(%d+):(%d+): (%w+): (.*)]],
            { "row", "col", "severity", "message" }, {
              severities = {
                note = helpers.diagnostics.severities["warning"],
                style = helpers.diagnostics.severities["hint"],
                performance = helpers.diagnostics.severities["warning"],
                portability = helpers.diagnostics.severities["information"],
              },
            }),
        }),
      }

      null_ls.register(clang_tidy)
    end
  },

  {
    "aznhe21/actions-preview.nvim",
    event = "VeryLazy",
    config = function()
      require("actions-preview").setup({
        backend = "telescope",
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.5,
            height = 0.6,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      })

      vim.keymap.set({ "n" }, "<leader>ca", require("actions-preview").code_actions)
    end
  }
}
