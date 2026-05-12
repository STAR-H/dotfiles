---Bookmarks with global file store, loaded on first bookmarks key press.
return {
  "tomasky/bookmarks.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    { "<Space>bb", function() require("bookmarks").bookmark_toggle() end, desc = "Bookmark Toggle" },
    { "<Space>bi", function() require("bookmarks").bookmark_ann() end,    desc = "Bookmark Annotate" },
    { "<Space>bj", function() require("bookmarks").bookmark_next() end,   desc = "Bookmark Next" },
    { "<Space>bk", function() require("bookmarks").bookmark_prev() end,   desc = "Bookmark Previous" },
    { "<Space>ba", "<cmd>Telescope bookmarks list<cr>",                   desc = "Bookmark List" },
    { "<Space>bc", function() require("bookmarks").bookmark_clear_all(); require("bookmarks").bookmark_clean() end, desc = "Bookmark Clear All" },
  },
  config = function()
    require("bookmarks").setup {
      save_file = vim.fn.expand("$HOME/.bookmarks"),
      signs = {
        add = { text = "" },
        ann = { text = "󰙆" },
      },
    }
    vim.api.nvim_set_hl(0, "BookMarksAdd", { fg = "#a9ddea" })
    vim.api.nvim_set_hl(0, "BookMarksAnn", { fg = "#a9ddea" })
  end,
}
