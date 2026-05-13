local M = {}

M.ns = vim.api.nvim_create_namespace("custom_dim")

function M.on_win(_, win, buf, top, bot)
  if win == vim.api.nvim_get_current_win() then return end
  if vim.bo[buf].buftype ~= "" then return end
  if vim.api.nvim_win_get_option(win, "diff") then return end

  vim.api.nvim_buf_set_extmark(buf, M.ns, top, 0, {
    end_row = bot + 1,
    end_col = 0,
    hl_group = "CustomDimOverlay",
    hl_eol = true,
    ephemeral = true,
    priority = 4097,
  })
end

function M.setup()
  vim.api.nvim_set_hl(0, "CustomDimOverlay", { bg = "#353535", default = true })
  vim.api.nvim_set_decoration_provider(M.ns, { on_win = M.on_win })
end

return M
