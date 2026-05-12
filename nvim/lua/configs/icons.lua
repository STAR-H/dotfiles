---Unified LSP completion kind icons.
---Merged from lspkind defaults and navic breadcrumb icons.
---Used by both nvim-cmp and nvim-navic.
---@class Icons
local M = {}

M.lspkind = {
  Text          = "󰊄",
  Snippet       = "󰻋",
  Color         = "󰏘",
  Reference     = "",
  Folder        = "󰉋",
  Unit          = "",
  Value         = "󰎠",
  Keyword       = "󰌋",
  File          = "󰈙",
  Module        = "",
  Property      = "󰜢",
  Constructor   = "",
  Enum          = "",
  Interface     = "",
  Function      = "󰊕",
  Variable      = "󰀫",
  Constant      = "󰏿",
  EnumMember    = "",
  Event         = "",
  Class         = "",
  Method        = "ƒ",
  Field         = "",
  Operator      = "",
  TypeParameter = "",
  Struct        = "󰙅",
  Namespace     = "󰦮",
  Package       = "",
  String        = "",
  Number        = "󰎠",
  Boolean       = "󰨙",
  Array         = "󰅪",
  Object        = "󰅩",
  Key           = "󰌋",
  Null          = "󰟢",
}

return M
