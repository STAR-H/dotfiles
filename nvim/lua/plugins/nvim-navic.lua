---LSP-powered code context breadcrumbs for statusline/winbar.
return {
  "SmiteshP/nvim-navic",
  event = "VeryLazy",
  dependencies = { "neovim/nvim-lspconfig" },
  init = function()
    -- PERF: Set it to true to update context only on CursorHold event. Could be usefull if
    -- you are facing performance issues on large files. Example usage
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.api.nvim_buf_line_count(0) > 10000 then
          vim.b.navic_lazy_update_context = true
        end
      end,
    })
  end,
  config = function()
    local icons = require("configs.icons").lspkind
    local spaced = {}
    for k, v in pairs(icons) do
      spaced[k] = v .. " "   -- add space after each icon
    end

    require("nvim-navic").setup {
      icons = spaced,
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      highlight = false,
      separator = " → ",
      depth_limit = 4,
      depth_limit_indicator = "…",
      safe_output = true,
      click = true
    }
  end,
}
