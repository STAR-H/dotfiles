return {
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        after = "", -- "fg" or "bg" or empty
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
    "junegunn/vim-easy-align",
    keys = {
      -- for unknown reason can use <Cmd> must use :
      { "ga", mode = { "n", "x" }, ":EasyAlign<CR>", desc = "EasyAlign Toggle +" },
    }
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { show_start = false, show_end = false, char = "│", highlight = "IblScopeChar" },
      exclude = {
        filetypes = {
          "Trouble",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "nvim-tree",
          "notify",
          "trouble",
        },
      },
    },
    config = function(_, opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
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

  -- autopairing of (){}[] etc
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
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
    "MattesGroeger/vim-bookmarks",
    keys = {
      { '<Space>bb', "<cmd>BookmarkToggle<CR>",   desc = "Bookmark Toggle" },
      { '<Space>bi', "<cmd>BookmarkAnnotate<CR>", desc = "Bookmark Annotate" },
      { '<Space>bj', "<cmd>BookmarkNext<CR>",     desc = "Bookmark Go to Next" },
      { '<Space>bk', "<cmd>BookmarkPrev<CR>",     desc = "Bookmark Go to Prev" },
      { '<Space>ba', "<cmd>BookmarkShowAll<CR>",  desc = "Bookmark Show All Bookmark" },
      { '<Space>bc', "<cmd>BookmarkClearAll<CR>", desc = "Bookmark Clear All Bookmark" },
    },
    config = function()
      vim.g.bookmark_no_default_key_mappings = 1
      vim.g.bookmark_show_toggle_warning = 0
      vim.g.bookmark_highlight_lines = 1
      vim.g.bookmark_location_list = 1
      vim.g.bookmark_disable_ctrlp = 1
      vim.g.bookmark_show_warning = 0
      vim.g.bookmark_auto_close = 1
      vim.g.bookmark_auto_save = 0
      vim.g.bookmark_center = 1
      vim.g.bookmark_sign = ''
      vim.g.bookmark_annotation_sign = '󰙆'

      vim.api.nvim_set_hl(0, 'BookmarkSign', { fg = '#a9ddea', bg = '#3c3836' })
      vim.api.nvim_set_hl(0, 'BookmarkAnnotationSign', { fg = '#a9ddea', bg = '#3c3836' })
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
      vim.g.project_root_dir = require("project_nvim.project").get_project_root()
    end
  }
}
