---Diagnostic display configuration.
---Sets virtual text prefix, sign column symbols, float window style.
---Note: diagnostics are disabled globally by default (options.lua),
---enabled per-filetype via autocmds, toggled with `dt` keymap.
local severity = vim.diagnostic.severity

local config = {
  -- virtual text shown inline at the offending line
  virtual_text = { prefix = "" },

  -- sign column icons per severity level
  signs = {
    text = {
      [severity.ERROR] = "✘",
      [severity.WARN]  = "",
      [severity.INFO]  = "",
      [severity.HINT]  = "",
    },
  },

  -- don't update diagnostics while typing in insert mode
  update_in_insert = false,

  -- underline the diagnostic range
  underline = true,

  -- sort diagnostics by severity
  severity_sort = true,

  -- floating window style for diagnostic details
  float = {
    focusable = true,
    style     = "minimal",
    border    = "rounded",
    source    = "if_many",
    header    = "",
    prefix    = "",
  },
}

vim.diagnostic.config(config)
