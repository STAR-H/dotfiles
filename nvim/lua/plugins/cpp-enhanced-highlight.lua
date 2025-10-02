return {
  -- only use in diff mode
  "octol/vim-cpp-enhanced-highlight",
  enabled = require("configs.utils").is_diff_mode(),
  ft = { "cpp" },
}
