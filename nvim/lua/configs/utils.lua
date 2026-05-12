---Utility functions for diff mode detection, diagnostics toggle,
---buffer closing, and dynamic foldcolumn.
local M = {}

---Check if running in diff mode (nvim -d)
function M.is_diff_mode()
  return vim.opt.diff:get()
end

---Toggle diagnostics on/off globally with notification
function M.toggle_diagnostics()
  if not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(true)
    vim.notify("Diagnostic Enabled!", vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    vim.notify("Diagnostic Disabled!", vim.log.levels.WARN)
  end
end

---Close current window if splits exist, otherwise close buffer
function M.close_buffer()
  local win_count = vim.fn.winnr("$")
  if win_count > 1 then
    vim.cmd("close")
  else
    vim.cmd("bd")
  end
end

---Dynamically show foldcolumn only when folds exist in the buffer
function M.update_foldcolumn()
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

function M.statuscolumn()
  local lnum = vim.v.lnum
  if not vim.wo.diff then
    return "%=%l %C"
  end
  local hl_id = vim.fn.diff_hlID(lnum, 0)
  if hl_id > 0 then
    local name = vim.fn.synIDattr(vim.fn.synIDtrans(hl_id), "name")
    local map = {
      DiffAdd = "DiffAddNr",
      DiffChange = "DiffChangeNr",
      DiffDelete = "DiffDeleteNr",
      DiffModified = "DiffModifiedNr",
    }
    local hl = map[name] or "LineNr"
    return "%=%#" .. hl .. "#" .. string.format("%3d", lnum) .. " %*%C"
  end
  return "%=%#LineNr#" .. string.format("%3d", lnum) .. " %*%C"
end

return M
