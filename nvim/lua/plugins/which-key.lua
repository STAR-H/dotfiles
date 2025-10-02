return {
  "folke/which-key.nvim",
  cmd = "WhichKey",
  keys = { "<leader>", "<Space>" },
  opts = function()
    local settings = {
      delay = 1000,
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "<Space>",  mode = { "n" } },
      },
      icons = {
        mappings = false,   -- not use icon
      },
    }
    return settings
  end,
}
