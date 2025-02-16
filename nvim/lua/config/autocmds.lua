-- function for diffMode (vi -d)
function IsDiffMode()
    if vim.api.nvim_win_get_option(0, "diff") then
        return true
    else
        return false
    end
end

function ToggleDiagnostics()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
        vim.notify("Diagnostic Enabled!", vim.log.levels.INFO)
    else
        vim.diagnostic.disable()
        vim.notify("Diagnostic Disabled!", vim.log.levels.INFO)
    end
end

-- 关闭缓冲区或窗口
function CloseBuffer()
    local win_count = vim.fn.winnr('$')
    if win_count > 1 then
        vim.cmd("close")
    else
        vim.cmd("bd")
    end
end

local function augroup(name)
  return vim.api.nvim_create_augroup("star_" .. name, { clear = true })
end

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
 group = augroup("highlight_yank"),
 callback = function()
   (vim.hl or vim.highlight).on_yank({higroup="IncSearch", timeout=300})
 end,
})

-- Open the file to automatically locate to the last edited position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].neovim_last_loc then
      return
    end
    vim.b[buf].neovim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set the terminal buffer when terminal open
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn ="no"
  end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    require('lualine').refresh() -- flash lualine status
  end,
})
