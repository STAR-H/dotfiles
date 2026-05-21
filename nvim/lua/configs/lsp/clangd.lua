return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--fallback-style=Google", -- default format style
    "--header-insertion=never",
    "--pch-storage=memory",
    "--query-driver=*clang++*",
    "-j=8"
  },
}
