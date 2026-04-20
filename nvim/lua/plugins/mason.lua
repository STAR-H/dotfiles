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
        "marksman"
      }
      require("mason").setup(settings)
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
    end,
  },
}
