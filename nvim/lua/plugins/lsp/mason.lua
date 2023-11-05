return {
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("nvim-navic").setup {
                icons = {
                    File          = "󰈙 ",
                    Module        = " ",
                    Namespace     = "󰌗 ",
                    Package       = " ",
                    Class         = "󰠱 ",
                    Method        = "ƒ ",
                    Property      = "󰜢 ",
                    Field         = " ",
                    Constructor   = " ",
                    Enum          = " ",
                    Interface     = " ",
                    Function      = "󰊕 ",
                    Variable      = "󰀫 ",
                    Constant      = "󰏿 ",
                    String        = "󰀬 ",
                    Number        = "󰎠 ",
                    Boolean       = "◩ ",
                    Array         = "󰅪 ",
                    Object        = "󰅩 ",
                    Key           = "󰌋 ",
                    Null          = "󰟢 ",
                    EnumMember    = " ",
                    Struct        = "󰆧 ",
                    Event         = " ",
                    Operator      = "󰆕 ",
                    TypeParameter = " ",
                },
                lsp = {
                    auto_attach = false,
                    preference = nil,
                },
                highlight = false,
                separator = " > ",
                depth_limit = 10,
                depth_limit_indicator = "..",
                safe_output = true,
                lazy_update_context = false,
                click = true
            }
        end
    },
    {
        "williamboman/mason.nvim",
        enabled = not isDiffMode(),
        dependencies = "williamboman/mason-lspconfig.nvim",
        config = function()
            local settings = {
                ui = {
                    border = "none",
                    icons = {
                        package_installed   = "✓",
                        package_pending     = "➜",
                        package_uninstalled = "✗",
                    },
                },
                log_level = vim.log.levels.INFO,
                max_concurrent_installers = 4,
            }
            require("mason").setup(settings)

            -- mason-lsp-config
            local servers = {
                "clangd",
                "cmake",
                "lua_ls",
                "bashls",
                "pyright"
            }
            require("mason-lspconfig").setup({
                ensure_installed = servers,
                automatic_installation = true,
            })

            local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
            if not lspconfig_status_ok then
                return
            end

            local opts = {}

            for _, server in pairs(servers) do
                opts = {
                    on_attach = require("plugins.lsp.handlers").on_attach,
                    capabilities = require("plugins.lsp.handlers").capabilities,
                }

                server = vim.split(server, "@")[1]

                local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
                if require_ok then
                    opts = vim.tbl_deep_extend("keep", conf_opts, opts)
                end

                lspconfig[server].setup(opts)
            end
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        enabled = not isDiffMode(),
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "cppdbg" }
            })
        end
    }
}
