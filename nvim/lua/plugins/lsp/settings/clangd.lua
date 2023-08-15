local util = require 'lspconfig.util'

return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--clang-tidy-checks=performance-*,bugprone-*",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--pch-storage=disk"
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    single_file_support = true,
}
