local M = {}

-- function for diffMode (vi -d)
M.is_diff_mode = function()
    if vim.opt.diff:get() then
        return true
    else
        return false
    end
end

M.toggle_diagnostics = function()
    if not vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(true)
        vim.notify("Diagnostic Enabled!", vim.log.levels.INFO)
    else
        vim.diagnostic.enable(false)
        vim.notify("Diagnostic Disabled!", vim.log.levels.WARN)
    end
end

-- close buffer or window layout
M.close_buffer = function()
    local win_count = vim.fn.winnr('$')
    if win_count > 1 then
        vim.cmd("close")
    else
        vim.cmd("bd")
    end
end

return M
