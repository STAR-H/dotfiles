---LSP handler configuration.
---Provides on_attach (keymaps per buffer), on_init (semantic tokens disable),
---and client capabilities (with cmp_nvim_lsp augmentation).
local M = {}
local map = vim.keymap.set

-- =============================================================================
-- on_attach: buffer-local LSP keymaps
-- =============================================================================
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  -- go to declaration
  map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))

  -- NOTE: gd, gi, gr use Trouble (defined in trouble plugin spec)
  -- rename symbol
  map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))

  -- NOTE: <leader>ca uses actions-preview.nvim (defined in actions-preview plugin spec)
  -- signature help
  map("n", "<leader>ls", vim.lsp.buf.signature_help, opts("SignatureHelp"))

  -- clangd: switch between source and header
  map("n", "<leader>a", "<cmd>ClangdSwitchSourceHeader<cr>", opts("Clangd Switch Source Header"))

  -- format buffer (normal mode)
  map("n", "<leader>lf",
    function()
      vim.lsp.buf.format({ async = true })
      vim.notify("Buffer Formatted", vim.log.levels.INFO, { timeout = 1000 })
    end, opts("Buffer Format"))

  -- format buffer (visual mode: exit visual after format)
  map("v", "<leader>lf",
    function()
      vim.lsp.buf.format({ async = true })
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      vim.notify("Buffer Formatted", vim.log.levels.INFO, { timeout = 1000 })
    end, opts("Buffer Format"))
end

-- =============================================================================
-- on_init: disable semantic tokens (reduces LSP noise)
-- =============================================================================
M.on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- =============================================================================
-- Client capabilities (augmented by cmp_nvim_lsp)
-- =============================================================================
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
if status_cmp_ok then
  M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
end

-- =============================================================================
-- defaults: load diagnostic config
-- =============================================================================
M.defaults = function()
  require("configs.diagnostics")
end

return M
