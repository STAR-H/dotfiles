return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--clang-tidy-checks=performance-*,bugprone-*",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--pch-storage=disk",
    "-j=8"
  },
  -- capabilities = {
  --   offsetEncoding = { "utf-16" },
  -- },
  single_file_support = true,
}
