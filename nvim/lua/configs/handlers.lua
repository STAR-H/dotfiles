local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  -- keymaps releated to lsp
  -- NOTE: lsp definitions references implications use keymaps set by trouble.nvim
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  -- map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  -- map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  -- map("n", "gr", vim.lsp.buf.references, opts "Go to reference")
  map("n", "<leader>rn", vim.lsp.buf.rename,                                     opts "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action,                                opts "Code action")
  map("n", "<leader>ls", vim.lsp.buf.signature_help,                             opts "SignatureHelp")
  map("n", "<leader>a",  "<cmd>ClangdSwitchSourceHeader<cr>",                    opts "Clangd Switch Source Header")
  map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",      opts "Buffer Format")
  map("v", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr><esc>", opts "Buffer Format")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.defaults = function()
  require("configs.diagnostics")
end

return M
