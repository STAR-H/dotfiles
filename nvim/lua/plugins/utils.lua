return {
  {
    "folke/todo-comments.nvim",
    enabled = not require("configs.utils").is_diff_mode(),
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        after = "fg", -- "fg" or "bg" or empty
        multiline = true
      },
    },
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                   desc = "Todo-Comments Trouble Toggle" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                         desc = "Todo-Comments Telescope Show" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo-Comments Telescope Keyword" },
    },
  },

  {
    -- only use in diff mode
    "octol/vim-cpp-enhanced-highlight",
    enabled = require("configs.utils").is_diff_mode(),
    ft = { "cpp" },
  },

  {
    "andersevenrud/nvim_context_vt",
    event = "VeryLazy",
    enabled = not require("configs.utils").is_diff_mode(),
    ft = { 'c', 'cpp', 'lua', 'python' },
    config = function()
      vim.api.nvim_set_hl(0, 'CustomContextVt', { fg = '#928374', bold = true, italic = true })
      require('nvim_context_vt').setup({
        enabled = true,
        prefix = '󰞘 𝓮𝓷𝓭 𝓸𝓯',
        highlight = 'CustomContextVt',
        disable_ft = { 'markdown' },
        disable_virtual_lines = false,
        disable_virtual_lines_ft = { 'yaml' },
        min_rows = 20,
      })
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require('hlslens').setup({
        enable_incsearch = false, -- disable for flicker issue when enable incsearch
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
  },

  {
    "stevearc/profile.nvim",
    enabled = false,
    lazy = false,
    config = function()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end

      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          prof.start("*")
        end
      end
      vim.keymap.set("", "<f2>", toggle_profile)
    end
  },

  {
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
          mappings = false, -- not use icon
        },
      }
      return settings
    end,
  },

  {
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
      vim.g.mwHistAdd = ' '
      -- let marks to be case-insensitive
      vim.g.mwIgnoreCase = 0
      vim.g.mwMaxMatchPriority = 10
      vim.g.mw_no_mappings = 1

      -- combind vim-mark and nvim-hlslens toggther with n / N
      local function mark_or_hlslens_search(is_backward)
        local is_marked = vim.fn["mark#CurrentMark"]()
        local is_marked_string = tostring(is_marked[1])
        if is_marked_string == nil or is_marked_string == "" then -- current not marked
          if not is_backward then
            vim.cmd("execute('normal! ' . v:count1 . 'n')")
            require("hlslens").start()
          else
            vim.cmd("execute('normal! ' . v:count1 . 'N')")
            require("hlslens").start()
          end
        else -- is marked
          vim.fn["mark#SearchCurrentMark"](is_backward)
        end
      end

      -- 绑定键映射
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
  },

  {
    "tomasky/bookmarks.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require('bookmarks').setup {
        -- sign_priority = 8,  --set bookmark sign priority to cover other sign
        save_file = vim.fn.expand "$HOME/.bookmarks", -- bookmarks save file path
        keywords = {},
        signs = {
          add = { text = "" },
          ann = { text = "󰙆" },
        },
        on_attach = function(bufnr)
          local bm = require "bookmarks"
          local map = vim.keymap.set
          map("n", "<Space>bb", bm.bookmark_toggle, { desc = "bookmark toogle" })                              -- add or remove bookmark at current line
          map("n", "<Space>bi", bm.bookmark_ann, { desc = "bookmark annotation" })                             -- add or edit mark annotation at current line
          map("n", "<Space>bj", bm.bookmark_next, { desc = "bookmark jump next" })                             -- jump to next mark in local buffer
          map("n", "<Space>bk", bm.bookmark_prev, { desc = "bookmark jump previous" })                         -- jump to previous mark in local buffer
          map("n", "<Space>ba", "<cmd>Telescope bookmarks list<cr>", { desc = "bookmark show markd in list" }) -- show marked file list in quickfix window
          map("n", "<Space>bc", function()
            bm.bookmark_clear_all()
            bm.bookmark_clean()
          end, { desc = "bookmark clear all bookmarks" }) -- removes all bookmarks
        end

      }
      vim.api.nvim_set_hl(0, 'BookMarksAdd', { fg = '#a9ddea' })
      vim.api.nvim_set_hl(0, 'BookMarksAnn', { fg = '#a9ddea' })
    end
  },

  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern" },
        patterns = { ".git", ".root", ".project", "compile_command.json" },
      }
      vim.g.project_root_dir = require("project_nvim.project").get_project_root() or vim.uv.cwd()
    end
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Create some toggle mappings
          Snacks.toggle.dim():map("<leader>ud")
        end,
      })
    end,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      animate = { enabled = true },
      bufdelete = { enabled = true },
      bigfile = { enabled = true },
      image = {
        enabled = true,
        doc = {
          inline = true, -- use float window show the image
        }
      },
      indent = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      profiler = { enabled = true },

      dashboard = { enabled = false },
      explorer = { enabled = false },
      input = { enabled = false },
      picker = { enabled = false },
      notifier = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      lazygit = { enabled = false }
    },
    keys = {
      { "<leader>z",        function() Snacks.zen.zoom() end,    desc = "Snacks Zen Toggle Zoom" },
      { "<leader><leader>", function() Snacks.image.hover() end, desc = "Snacks show image at cursor" },
    }
  }
}
