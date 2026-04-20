return {
  -- only use in diff mode
  "octol/vim-cpp-enhanced-highlight",
  enabled = require("configs.utils").is_diff_mode() and vim.loop.os_uname().sysname ~= "Windows_NT",
  ft = { "cpp" },
}
