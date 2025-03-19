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


M.update_foldcolumn = function()
  if not vim.wo.foldenable then
    vim.wo.foldcolumn = "0"
    return
  end

  local has_fold = false
  local line_count = vim.api.nvim_buf_line_count(0)
  for lnum = 1, line_count do
    if vim.fn.foldlevel(lnum) > 0 then
      has_fold = true
      break
    end
  end

  vim.wo.foldcolumn = has_fold and "1" or "0"
end


return M
