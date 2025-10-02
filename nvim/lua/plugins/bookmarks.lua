return {
  "tomasky/bookmarks.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require('bookmarks').setup {
      -- sign_priority = 8,  --set bookmark sign priority to cover other sign
      save_file = vim.fn.expand "$HOME/.bookmarks",   -- bookmarks save file path
      keywords = {},
      signs = {
        add = { text = "" },
        ann = { text = "󰙆" },
      },
      on_attach = function(bufnr)
        local bm = require "bookmarks"
        local map = vim.keymap.set
        map("n", "<Space>bb", bm.bookmark_toggle, { desc = "bookmark toogle" })                                -- add or remove bookmark at current line
        map("n", "<Space>bi", bm.bookmark_ann, { desc = "bookmark annotation" })                               -- add or edit mark annotation at current line
        map("n", "<Space>bj", bm.bookmark_next, { desc = "bookmark jump next" })                               -- jump to next mark in local buffer
        map("n", "<Space>bk", bm.bookmark_prev, { desc = "bookmark jump previous" })                           -- jump to previous mark in local buffer
        map("n", "<Space>ba", "<cmd>Telescope bookmarks list<cr>", { desc = "bookmark show markd in list" })   -- show marked file list in quickfix window
        map("n", "<Space>bc", function()
          bm.bookmark_clear_all()
          bm.bookmark_clean()
        end, { desc = "bookmark clear all bookmarks" })   -- removes all bookmarks
      end

    }
    vim.api.nvim_set_hl(0, 'BookMarksAdd', { fg = '#a9ddea' })
    vim.api.nvim_set_hl(0, 'BookMarksAnn', { fg = '#a9ddea' })
  end
}
