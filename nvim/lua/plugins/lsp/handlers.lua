local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = false
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "none",
    })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "none",
    })

local function lsp_keymaps(bufnr)
    local function opts(descs)
            return { desc = descs, noremap = true, silent = true, nowait = true }
        end
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, "n", "gD",         "<cmd>lua vim.lsp.buf.declaration()<CR>",               opts("Go to [D]eclaration"))
    keymap(bufnr, "n", "gd",         "<cmd>lua vim.lsp.buf.definition()<CR>",                opts("Go to [d]efiniton"))
    keymap(bufnr, "n", "K",          "<cmd>lua vim.lsp.buf.hover()<CR>",                     opts("Show hover"))
    keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",      opts("Lsp buffer [f]ormat"))
    keymap(bufnr, "v", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr><esc>", opts("Lsp buffer [f]ormat"))
    keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>",               opts("Lsp [c]ode [a]ction"))
    keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>",                    opts("Lsp [r]e[n]ame"))
    keymap(bufnr, "n", "<leader>a", "<cmd>ClangdSwitchSourceHeader<CR>",                     opts)
    -- keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>",            opts)
    -- keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>",             opts)
    -- keymap(bufnr, "n", "gI",         "<cmd>lua vim.lsp.buf.implementation()<CR>",            opts)
    -- keymap(bufnr, "n", "gl",         "<cmd>lua vim.diagnostic.open_float()<CR>",             opts)
    -- keymap(bufnr, "n", "gr",         "<cmd>lua vim.lsp.buf.references()<CR>",                opts)
end

function IncomingCalls()
    vim.lsp.buf.incoming_calls()
end

vim.cmd("command! IncomingCalls lua IncomingCalls()")

local navic = require("nvim-navic")
M.on_attach = function(client, bufnr)
    navic.attach(client, bufnr)
    lsp_keymaps(bufnr)
end

return M
