return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
  -- Linux => Linux, Darwin => macos Windows => Windows_NT
  enabled = vim.tbl_contains({ "Darwin", "Linux" }, vim.loop.os_uname().sysname),
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

    vim.keymap.set({ "n" }, "<leader>ca", require("actions-preview").code_actions)
  end
}
