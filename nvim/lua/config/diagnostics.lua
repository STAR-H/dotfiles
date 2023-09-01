local signs = {
    { name = "DiagnosticSignError", text = "✘" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
    virtual_text = true, -- disable virtual text
    signs = {
        active = signs, -- show signs
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
            focusable = true,
            style  = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
vim.diagnostic.config(config)

function ToggleDiagnostics()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end
vim.keymap.set("n", "dt", ToggleDiagnostics, {silent = true, noremap = true, desc = "[d]iagnostics [t]oggle"})

-- function toggle_loclist()
--     local wininfos = vim.fn.getwininfo()
--     local loclist_exists = false
--
--     for _, wininfo in ipairs(wininfos) do
--         if wininfo.loclist == 1 then
--             loclist_exists = true
--             break
--         end
--     end
--
--     if not loclist_exists then
--         vim.cmd("lua vim.diagnostic.setloclist()")
--     else
--         vim.cmd("lclose")
--     end
-- end
--
--
-- vim.keymap.set("n", "dl", toggle_loclist, {silent = true, noremap = true})
