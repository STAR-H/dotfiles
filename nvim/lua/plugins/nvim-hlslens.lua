return {
  "kevinhwang91/nvim-hlslens",
  event = "VeryLazy",
  config = function()
    require('hlslens').setup({
      enable_incsearch = false,   -- disable for flicker issue when enable incsearch
      override_lens = function(render, posList, nearest, idx)
        local text, chunks
        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          text = ('(%d/%d)'):format(idx, cnt)
          chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end

    })
    local kopts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
  end
}
