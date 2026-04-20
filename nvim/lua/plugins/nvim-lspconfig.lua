return {
  "neovim/nvim-lspconfig",
  event = "User FilePost",
  enabled = not require("configs.utils").is_diff_mode(),
  config = function()
    require("configs.handlers").defaults()

    local lspconfig = require "lspconfig"
    local lsphandlers = require("configs.handlers")

    local servers = { "clangd", "cmake", "bashls", "marksman" }

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
}
