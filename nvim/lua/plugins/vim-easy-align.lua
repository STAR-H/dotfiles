---Simple, easy-to-use Vim alignment plugin.
return {
  "junegunn/vim-easy-align",
  event = "VeryLazy",
  config = function()
    -- Visual mode: xmap ga <Plug>(EasyAlign)
    vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { silent = true })
    -- Normal mode: nmap ga <Plug>(EasyAlign)
    vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { silent = true })
  end
}
