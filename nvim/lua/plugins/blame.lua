return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle" },
  enabled = vim.tbl_contains({ "Darwin", "Linux" }, vim.loop.os_uname().sysname),
  opts = {},
}
