---LSP setup: Mason installer + lspconfig with handlers.
return {
  {
    -- LSP package manager: install/update language servers
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
        "lua_ls",
        "marksman",
        "jsonls",
      }

      require("mason").setup(settings)
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
    end,
  },

  {
    -- LSP client configuration: attach handlers and capabilities
    "neovim/nvim-lspconfig",
    branch = "v2.9.0",
    event = "BufReadPost",
    enabled = not require("configs.utils").is_diff_mode(),
    config = function()
      require("configs.handlers").defaults()

      local lsphandlers = require("configs.handlers")

      -- servers with default config
      local servers = { "clangd", "marksman", "jsonls" }

      for _, server in ipairs(servers) do
        local opts = {
          on_attach = lsphandlers.on_attach,
          on_init = lsphandlers.on_init,
          capabilities = lsphandlers.capabilities,
        }

        server = vim.split(server, "@")[1]

        -- merge with per-server custom config if exists (e.g. configs/lsp/clangd.lua)
        local require_ok, self_conf = pcall(require, "configs.lsp." .. server)
        if require_ok then
          opts = vim.tbl_deep_extend("keep", self_conf, opts)
        end

        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end

      -- lua_ls: custom settings (library paths, diagnostics globals)
      vim.lsp.config("lua_ls", {
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
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },
}
