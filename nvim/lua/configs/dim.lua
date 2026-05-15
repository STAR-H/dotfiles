local M = {}
local config = {}

M.ns = vim.api.nvim_create_namespace("custom_dim")

function M.on_win(_, win, buf, top, bot)
  if win == vim.api.nvim_get_current_win() then return end
  if vim.bo[buf].buftype ~= "" then return end
  if vim.api.nvim_win_get_option(win, "diff") then return end
  -- don't dim when focus is on an ignored window (e.g., Trouble, NvimTree, Telescope)
  local cur_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  if vim.tbl_contains(config.ignore_filetypes or {}, vim.bo[cur_buf].filetype) then return end
  -- skip dimming for excluded filetypes and buftypes
  if vim.tbl_contains(config.ignore_buftypes or {}, vim.bo[buf].buftype) then return end
  if vim.tbl_contains(config.ignore_filetypes or {}, vim.bo[buf].filetype) then return end

  vim.api.nvim_buf_set_extmark(buf, M.ns, top, 0, {
    end_row = bot + 1,
    end_col = 0,
    hl_group = "CustomDimOverlay",
    hl_eol = true,
    ephemeral = true,
    priority = 4097,
  })
end

function M.setup(opts)
  config = opts or {}
  vim.api.nvim_set_hl(0, "CustomDimOverlay", { bg = "#353535", default = true })
  vim.api.nvim_set_decoration_provider(M.ns, { on_win = M.on_win })
end

return M
