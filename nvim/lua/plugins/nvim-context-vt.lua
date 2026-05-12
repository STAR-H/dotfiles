---Virtual text showing current context (function/class/loop) at top of window.
---Enabled for c, cpp, lua, python files. Disabled in diff mode.
return {
  "andersevenrud/nvim_context_vt",
  event = "VeryLazy",
  enabled = not require("configs.utils").is_diff_mode(),
  ft = { "c", "cpp", "lua", "python" },
  config = function()
    vim.api.nvim_set_hl(0, "CustomContextVt", { fg = "#928374", bold = true, italic = true })
    require("nvim_context_vt").setup({
      enabled = true,
      prefix = "󰞘 𝓮𝓷𝓭 𝓸𝓯",
      highlight = "CustomContextVt",
      disable_ft = { "markdown" },
      disable_virtual_lines = false,
      disable_virtual_lines_ft = { "yaml" },
      min_rows = 20,
    })
  end,
}
