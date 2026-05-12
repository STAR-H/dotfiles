---Visual word marking and navigation. Integrates with nvim-hlslens.
---Keymaps: mm mark, mr mark by regex, mc clear all. n/N jumps marks+search.
return {
  "STAR-H/vim-mark",
  keys = {
    { "mm", "<Plug>MarkSet",      desc = "Mark Set/Unset", mode = { "n", "x" }, },
    { "mr", "<Plug>MarkRegex",    desc = "Mark by Regx" },
    { "mc", "<Plug>MarkAllClear", desc = "Mark Clear" },
  },
  branch = "master",
  dependencies = {
    { "inkarkat/vim-ingo-library" },
    { "kevinhwang91/nvim-hlslens" },
  },
  -- do not add mark words to the search(/)  and input(@) history
  config = function()
    vim.g.mwHistAdd = " "
    -- let marks to be case-insensitive
    vim.g.mwIgnoreCase = 0
    vim.g.mwMaxMatchPriority = 10
    vim.g.mw_no_mappings = 1

    -- combind vim-mark and nvim-hlslens toggther with n / N
    local function mark_or_hlslens_search(is_backward)
      local is_marked = vim.fn["mark#CurrentMark"]()
      local is_marked_string = tostring(is_marked[1])
      if is_marked_string == nil or is_marked_string == "" then -- current not marked
        local status = nil
        if not is_backward then
          status = pcall(function() vim.cmd("execute('normal! ' . v:count1 . 'n')") end)
        else
          status = pcall(function() vim.cmd("execute('normal! ' . v:count1 . 'N')") end)
        end
        if status then
          require("hlslens").start()
        end
      else -- is marked
        vim.fn["mark#SearchCurrentMark"](is_backward)
      end
    end

    -- key mapping
    vim.api.nvim_set_keymap("n", "n", "", {
      noremap = true,
      silent = true,
      callback = function()
        mark_or_hlslens_search(false)
      end,
    })

    vim.api.nvim_set_keymap("n", "N", "", {
      noremap = true,
      silent = true,
      callback = function()
        mark_or_hlslens_search(true)
      end,
    })
  end
}
