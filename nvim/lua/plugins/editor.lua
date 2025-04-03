return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = not require("configs.utils").is_diff_mode(),
    keys = { { "<leader>s", mode = "n", "<cmd>lua require('flash').jump()<cr>", desc = "flash search jump" }, },
    config = function()
      require("flash").setup({
        jump = {
          -- save location in the jumplist
          jumplist = false,
          -- jump position
          pos = "start", ---@type "start" | "end" | "range"
          -- add pattern to search history
          history = false,
          -- add pattern to search register
          register = false,
          -- clear highlight after jump
          nohlsearch = true,
          -- automatically jump when there is only one match
          autojump = true,
          -- You can force inclusive/exclusive jumps by setting the
          -- `inclusive` option. By default it will be automatically
          -- set based on the mode.
          inclusive = nil, ---@type boolean?
          -- jump position offset. Not used for range jumps.
          -- 0: default
          -- 1: when pos == "end" and pos < current position
          offset = nil, ---@type number
        },
        labels = "aghjklqwertyuiopzcvbnm",
        label = {
          -- allow uppercase labels
          uppercase = false,
          -- add any labels with the correct case here, that you want to exclude
          exclude = "",
          -- add a label for the first match in the current window.
          -- you can always jump to the first match with `<CR>`
          current = true,
          -- show the label after the match
          after = true, ---@type boolean|number[]
          -- show the label before the match
          before = false, ---@type boolean|number[]
          -- position of the label extmark
          style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
          -- flash tries to re-use labels that were already assigned to a position,
          -- when typing more characters. By default only lower-case labels are re-used.
          reuse = "lowercase", ---@type "lowercase" | "all" | "none"
          -- for the current window, label targets closer to the cursor first
          distance = true,
          -- minimum pattern length to show labels
          -- Ignored for custom labelers.
          min_pattern_length = 0,
          -- Enable this to use rainbow colors to highlight labels
          -- Can be useful for visualizing Treesitter ranges.
          rainbow = {
            enabled = false,
            -- number between 1 and 9
            shade = 5,
          },
        },
        modes = {
          -- options used when flash is activated through
          -- a regular search with `/` or `?`
          search = {
            -- when `true`, flash will be activated during regular search by default.
            -- You can always toggle when searching with `require("flash").toggle()`
            enabled = false,
            highlight = { backdrop = false },
            jump = { history = true, register = true, nohlsearch = true },
            search = {
              -- `forward` will be automatically set to the search direction
              -- `mode` is always set to `search`
              -- `incremental` is set to `true` when `incsearch` is enabled
            },
          },
          -- options used when flash is activated through
          -- `f`, `F`, `t`, `T`, `;` and `,` motions
          char = {
            enabled = true,
            -- dynamic configuration for ftFT motions
            config = function(opts)
              -- autohide flash when in operator-pending mode
              opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

              -- disable jump labels when enabled and when using a count
              opts.jump_labels = opts.jump_labels and vim.v.count == 0

              -- Show jump labels only in operator-pending mode
              -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
            end,
            -- hide after jump when not using jump labels
            autohide = false,
            -- show jump labels
            jump_labels = true,
            -- set to `false` to use the current line only
            multi_line = false,
            -- When using jump labels, don't use these keys
            -- This allows using those keys directly after the motion
            label = { exclude = "hjkliardc" },
            -- by default all keymaps are enabled, but you can disable some of them,
            -- by removing them from the list.
            -- If you rather use another key, you can map them
            -- to something else, e.g., { [";"] = "L", [","] = H }
            keys = { "f", "F", },
            ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
            -- The direction for `prev` and `next` is determined by the motion.
            -- `left` and `right` are always left and right.
            char_actions = function(motion)
              return {
                ["j"] = "next", -- set to `right` to always go right
                ["k"] = "prev", -- set to `left` to always go left
                -- clever-f style
                [motion:lower()] = "next",
                [motion:upper()] = "prev",
                -- jump2d style: same case goes next, opposite case goes prev
                -- [motion] = "next",
                -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
              }
            end,
            search = { wrap = true },
            highlight = { backdrop = true },
            jump = { register = false },
          },
        },
      })
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = 'telescope find files' },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = 'telescope live grep' },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = 'telescope list buffers' },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = 'telescope fuzzy search' },
      { "<leader>ft", "<cmd>Telescope lsp_document_symbols<cr>",      desc = 'telescope current buffer tags' },
      { "z=",         "<cmd>Telescope spell_suggest<cr>",             { desc = 'telescope spell suggest', noremap = true } }
    },
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local actions = require "telescope.actions"
      require('telescope').setup({
        defaults = {
          git_worktrees = vim.g.project_root_dir, -- use project.nvim update root dir
          color_devicons = false,
          prompt_prefix = "  ",
          selection_caret = "  ",
          path_display = { shorten = { len = 2, exclude = { -1, -2 } } },
          sorting_strategy = "descending",
          vimgrep_arguments = { -- use by live grep and grep string
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim"                    --remove indentation
          },
          layout_strategy = 'vertical', -- horizontal or vertical
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
              preview_width = 0.6,
              width = 0.9,
              height = 0.8,
              preview_cutoff = 120
            },
            vertical = {
              mirror = false,
              preview_height = 0.75,
              width = 0.7,
              height = 0.9,
              preview_cutoff = 40
            },
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-e>"] = actions.close,
            },
            n = {
              ["<C-e>"] = actions.close,
              ["q"]     = actions.close,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            cwd = vim.g.project_root_dir,
            prompt_title = "Find Files at (" .. vim.fn.fnamemodify(vim.g.project_root_dir, ':t') .. ")"
          },
          buffers = {
            prompt_title = "Switch Buffers",
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            ignore_current_buffer = false,
          },
          commands = {
            theme = "dropdown",
            previewer = false,
          },
          live_grep = {
            disable_coordinates = true,
            cwd = vim.g.project_root_dir,
            prompt_title = "Live Grep at (" .. vim.fn.fnamemodify(vim.g.project_root_dir, ':t') .. ")"
          },
          current_buffer_fuzzy_find = {
            skip_empty_lines = true,
            results_ts_highlight = false,
          },
          spell_suggest = {
            prompt_title = "Spell Suggestion",
            theme = "cursor",
            layout_config = {
              width = 0.15,
              height = 0.1
            }
          },
          lsp_document_symbols = {
            symbol_width = 60,
            symbol_type_width = 10,
          }
        },
      })

      -- load the extension here
      require('telescope').load_extension('bookmarks')
      require("telescope").load_extension("fzf")
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    keys = {
      { "]g",         "&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>'", desc = "Gitsigns next_hunk<CR>" },
      { "[g",         "&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>'", desc = "Gitsigns prev_hunk" },
      { "gs",         "<Cmd>Gitsigns preview_hunk<CR>",               desc = "Gitsigns preview_hunk" },
      { "gu",         "<Cmd>Gitsigns reset_hunk<CR>",                 desc = "Gitsigns reset_hunk" },
      { "<leader>gb", "<Cmd>Gitsigns toggle_current_line_blame<CR>",  desc = "Gitsigns Toggle Current Line Blame" },
    },
    -- add key map for nvcheatsheet
    enabled = not require("configs.utils").is_diff_mode(),
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "-" },
          topdelete    = { text = '▔' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          follow_files = true
        },
        attach_to_untracked          = true,
        -- PERF: disabel line blame by default  for performance
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 300,
          ignore_whitespace = true,
        },
        -- current_line_blame_formatter = '<author> (<author_time:%R>):<summary>',
        current_line_blame_formatter = '<author> (<author_time:%y-%m-%d>):<summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border = 'rounded',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        on_attach                    = function(bufnr)
          local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
          end
          -- Navigation
          map('n', ']g', "&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          map('n', '[g', "&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
          map('n', 'gs', '<Cmd>Gitsigns preview_hunk<CR>')
          map('n', 'gu', '<Cmd>Gitsigns reset_hunk<CR>')
          map('v', 'gu', '<Cmd>Gitsigns reset_hunk<CR>')
          map('n', '<leader>gb', '<Cmd>Gitsigns toggle_current_line_blame<CR>')
        end
      }
      vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#a89984' })
    end
  },

  {
    "FabijanZulj/blame.nvim",
    cmd = { "BlameToggle" },
    opts = {},
  },

  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>n", "<Cmd>NvimTreeToggle<CR>", desc = "NvimTree Toggle" },
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- default mappings
        -- api.config.mappings.default_on_attach(bufnr)

        -- custom key mappings start
        vim.keymap.set('n', 'h',     api.node.navigate.parent_close, opts('Close'))
        vim.keymap.set('n', 'l',     api.node.open.edit,             opts('Open'))
        vim.keymap.set('n', 'r',     api.fs.rename,                  opts('Rename'))
        vim.keymap.set('n', 'y',     api.fs.copy.filename,           opts('Copy Name'))
        vim.keymap.set('n', 'Y',     api.fs.copy.absolute_path,      opts('Copy Absolute Path'))
        vim.keymap.set('n', 'a',     api.fs.create,                  opts('Create File or Dir'))
        vim.keymap.set('n', 'd',     api.fs.remove,                  opts('Delete'))
        vim.keymap.set('n', 'e',     api.tree.expand_all,            opts('Expand All'))
        vim.keymap.set('n', 'gp',    api.node.navigate.parent,       opts('Parent Directory'))
        vim.keymap.set('n', 'E',     api.tree.collapse_all,          opts('Collapse All'))
        vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,  opts('Toggle Dotfiles'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical,         opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal,       opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>',  api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', 'c',     api.tree.change_root_to_node,   opts('Change Root Dir'))
        vim.keymap.set('n', 'x',     api.fs.cut,                     opts('Cut file'))
        vim.keymap.set('n', '?',     api.tree.toggle_help,           opts('Help'))
        vim.keymap.set('n', 'p',     api.fs.paste,                   opts('Paste file'))
        vim.keymap.set('n', 'yy',    api.fs.copy.node,               opts('Copy file'))
        -- custom key mappings end
      end

      require("nvim-tree").setup({
        -- Changes the tree root directory on `DirChanged` and refreshes the tree.
        sync_root_with_cwd = false,
        -- Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
        respect_buf_cwd = false,
        sort_by = "case_sensitive",
        on_attach = my_on_attach,
        view = {
          width = 40,
          side = "right",
        },
        update_focused_file = {
          enable = true,
          -- Update the root directory of the tree if the file is not under current
          -- root directory. It prefers vim's cwd and `root_dirs`.
          -- Otherwise it falls back to the folder containing the file.
          update_root = {
            enable = true,
          },
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
      -- nvim-tree highlight override
      vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { bg = '#2e2e2e', bold = true })
    end
  },

  {
    "liuchengxu/vista.vim",
    keys = {
      { "<leader>t", "<cmd>Vista!!<cr>", desc = "Tagbar Toggle(On/Off)" },
    },
    ft = { "cpp", "c", "markdown" },
    config = function()
      vim.g.vista_default_executive = 'ctags'
      vim.cmd("let g:vista_executive_for = {'cpp': 'ctags'}")
      vim.cmd("let g:vista#renderer#enable_icon = 1")
      vim.g.vista_sidebar_position = "vertical left"
      vim.g.vista_sidebar_open_cmd = 'leftabove 40vsplit'
      vim.g.vista_sidebar_width = 40
      vim.g.vista_echo_cursor = 0
      vim.g.vista_disable_statusline = 1
      vim.g.vista_blink = { 0, 0 }
      vim.cmd("highlight VistaTag guifg=#ebdbb2")
      vim.cmd("let g:vista#render#ctags = 'kind'")
      vim.cmd("let g:vista#renderer#ctags = 'kind'")
      vim.cmd("let g:vista#renderer#default#vlnum_offset = 3")
      vim.g.vista_update_on_text_changed = true
    end
  },

  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<C-h>", mode = "v", [[:<C-u>lua MiniSurround.add('visual')<CR>`]], { slient = true, desc = "Markdown highlight color" } }
    },
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = 'gsa',            -- Add surrounding in Normal and Visual modes
          delete = 'gsd',         -- Delete surrounding
          find = 'gsf',           -- Find surrounding (to the right)
          find_left = 'gsF',      -- Find surrounding (to the left)
          highlight = 'gsh',      -- Highlight surrounding
          replace = 'gsr',        -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`

          suffix_last = 'l',      -- Suffix to search with "prev" method
          suffix_next = 'n',      -- Suffix to search with "next" method
        },
        silent = true
      })
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
      local autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      local cmp_status, cmp = pcall(require, "cmp")
      if autopairs_status and cmp_status then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  {
    "echasnovski/mini.align",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end
  },

  {
    "echasnovski/mini.cursorword",
    enabled = not require("configs.utils").is_diff_mode(),
    ft = { "c", "cpp", "h", "hpp", "lua" },
    version = "*",
    init = function()
      -- NOTE: disable mini cursorword for some file type
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "NvimTree", "vista_kind", "vista_markdown", "markdown" },
        callback = function()
          vim.b.minicursorword_disable = true
        end,
      })
    end,
    config = function()
      require("mini.cursorword").setup({ delay = 500 })

      vim.api.nvim_set_hl(0, 'MiniCursorword',        { bg = "#35333c", bold = true })
      vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { underline = true })
    end
  },
}
