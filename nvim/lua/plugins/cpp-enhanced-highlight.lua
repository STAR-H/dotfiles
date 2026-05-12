---Enhanced C++ syntax highlighting.
return {
  -- only use in diff mode
  "octol/vim-cpp-enhanced-highlight",
  enabled = require("configs.utils").is_diff_mode() and require("configs.platform").is_unix,
  ft = { "cpp" },
}
