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
      scope = { enabled = false },
      scroll = { enabled = true },
      profiler = { enabled = true },

      dashboard = { enabled = false },
      explorer = { enabled = false },
      input = { enabled = false },
      picker = { enabled = false },
      notifier = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      lazygit = { enabled = false },

      zen = {
        toggles = {
          dim = false,
          git_signs = false,
          mini_diff_signs = false,
          diagnostics = false,
          -- inlay_hints = false,
        },
        win = {
          backdrop = { transparent = false, blend = 0, bg = '#282828' },
        },
      }
    },
    keys = {
      { "<Space><Space>",   function() Snacks.zen.zoom() end,    desc = "Snacks Zen Toggle Zoom" },
      { "<leader><leader>", function() Snacks.image.hover() end, desc = "Snacks show image at cursor" },
      { "<leader>uz",       function() Snacks.zen() end,         desc = "Toggle Zen Mode" },
    }
  },

  {
    'nvim-focus/focus.nvim',
    enabled = not require("configs.utils").is_diff_mode(),
    event = "VeryLazy",
    version = false,
    config = function()
      local opts = {
        enable = true,              -- Enable module
        commands = false,           -- Create Focus commands
        autoresize = {
          enable = false,           -- Enable or disable auto-resizing of splits
          width = 0,                -- Force width for the focused window
          height = 0,               -- Force height for the focused window
          minwidth = 0,             -- Force minimum width for the unfocused window
          minheight = 0,            -- Force minimum height for the unfocused window
          height_quickfix = 10,     -- Set the height of quickfix panel
        },
        split = {
          bufnew = false,     -- Create blank buffer for new split windows
          tmux = false,       -- Create tmux splits instead of neovim splits
        },
        ui = {
          number = false,                        -- Display line numbers in the focussed window only
          relativenumber = false,                -- Display relative line numbers in the focussed window only
          hybridnumber = false,                  -- Display hybrid line numbers in the focussed window only
          absolutenumber_unfocussed = false,     -- Preserve absolute numbers in the unfocussed windows

          cursorline = true,                     -- Display a cursorline in the focussed window only
          cursorcolumn = false,                  -- Display cursorcolumn in the focussed window only
          colorcolumn = {
            enable = false,                      -- Display colorcolumn in the foccused window only
            list = '+1',                         -- Set the comma-saperated list for the colorcolumn
          },
          signcolumn = true,                     -- Display signcolumn in the focussed window only
          winhighlight = true,                   -- Auto highlighting for focussed/unfocussed windows
        }
      }

      require("focus").setup(opts)

      vim.api.nvim_set_hl(0, 'FocusedWindow', { link = 'Normal' })
      vim.api.nvim_set_hl(0, 'UnfocusedWindow', { bg = '#3a3a3a' })

      local ignore_filetypes = {
        "NvimTree",
        "tagbar",
        "undotree",
        "vista_kind",
        "vista_markdown",
        "trouble",
        "AvanteInput",
        "AvanteSelectedFiles",
        "Avante",
        "noice",
        "TelescopePrompt",
        "TelescopeResults",
      }
      local ignore_buftypes = {
        "nofile",
        "prompt",
        "popup",
      }

      local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
          then
            vim.w.focus_disable = true
            vim.wo.cursorline = not opts.ui.cursorline
          else
            vim.w.focus_disable = false
            vim.wo.cursorline = opts.ui.cursorline
          end
        end,
        desc = 'Disable focus autoresize for BufType',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
            vim.wo.cursorline = not opts.ui.cursorline
          else
            vim.b.focus_disable = false
            vim.wo.cursorline = opts.ui.cursorline
          end
        end,
        desc = 'Disable focus autoresize for FileType',
      })
    end
  },
}
