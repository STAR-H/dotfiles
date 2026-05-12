---Preview LSP code actions before applying.
return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
  enabled = require("configs.platform").is_unix and not require("configs.utils").is_diff_mode(),
  config = function()
    require("actions-preview").setup({
      backend = "telescope",
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.5,
          height = 0.6,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    })
    vim.keymap.set("n", "<leader>ca", require("actions-preview").code_actions,
      { desc = "LSP code actions with preview" })
  end
}
