local x = vim.diagnostic.severity
local config = {
    virtual_text = { prefix = "" },
    signs = { text = { [x.ERROR] = "✘", [x.WARN] = "", [x.INFO] = "", [x.HINT] = "" } },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
            focusable = true,
            style  = "minimal",
            border = "rounded",
            source = "if_many",
            header = "",
            prefix = "",
        },
    }
vim.diagnostic.config(config)
