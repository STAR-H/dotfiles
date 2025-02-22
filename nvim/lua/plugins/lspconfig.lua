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
}
