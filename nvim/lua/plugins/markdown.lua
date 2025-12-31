return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown", "Avante" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = { { "<C-e>", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "RenderMarkdown toggle" } },
    opts = {
      enabled = true,
      file_types = { "markdown", "Avante" },
      completions = { lsp = { enabled = true } },

      sign = { enabled = false },

      heading = {
        icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' },
        width = 'block',
        position = 'inline',
        left_pad = 1,
        right_pad = 1,
      },

      checkbox = {
        checked = { scope_highlight = '@markup.strikethrough' }
      },

      pipe_table = {
        cell = 'padded',
        preset = 'round',
      },

      code = {
        width = 'block',
        -- Minimum width to use for code blocks when width is 'block'.
        min_width = 120,
        left_margin = 5,
        left_pad = 1,
        right_pad = 1,
        -- Whether to include the language icon above code blocks.
        language_icon = true,
        -- Whether to include the language name above code blocks.
        language_name = true,
        -- Whether to include the language info above code blocks.
        language_info = true,
        language = true,
      },

      anti_conceal = { enabled = false },

      indent = { enabled = false },

      preset = 'obsidian',
    },

    init = function()

      vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
          if vim.bo.filetype ~= "markdown" then
            return
          end
          vim.cmd("RenderMarkdown disable")
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          if vim.bo.filetype ~= "markdown" then
            return
          end
          vim.cmd("RenderMarkdown enable")
        end,
      })

    end

  },
  -- install with yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install", -- need manually install
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
      vim.g.mkdp_theme = 'light' -- light or dark
      vim.g.mkdp_markdown_css = vim.fn.stdpath('config') .. "/lua/configs/markdown/notion-light-enhanced.css"
      -- vim.g.mkdp_theme = 'dark' -- light or dark
      -- vim.g.mkdp_markdown_css = vim.fn.stdpath('config') .. "/lua/configs/markdown/notion-dark-enhanced.css"
    end
  },

  {
    "HakonHarnes/img-clip.nvim",
    ft = { 'markdown' },
    opts = {
      filetypes = {
        markdown = {
          dir_path = function()
            return vim.g.project_root_dir .. "/assets/" .. vim.fn.expand("%:t:r")
          end,
          template = function(context)
            local filename = vim.fs.basename(context.file_path)  -- 获取文件名（如 img.png）
            local dirname = vim.fs.basename(vim.fs.dirname(context.file_path))  -- 获取父目录名（如 note1）
            -- 拼接为 assets/<filename>/img.png
            return string.format("![[assets/%s/%s]]", dirname, filename)
          end,
          download_images = true,
          use_absolute_path = false,
          url_encode_path = false,
        },
      }
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
    },

    opts = {
      disable_frontmatter = true,
      workspaces = {
        {
          name = "obsidian",
          path = "~/Personal/obsidian",
          overrides = {
            notes_subdir = "00-Inbox",
          },
        },
      },

      ui = {
        enable = false, -- conflict with render-markdown.nvim, and render-markdown have better ui
        -- only use the below two checkboxes style, can use <CR> to toggle the status
        checkboxes = {
          [" "] = {},
          ["x"] = {},
        },
      },

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "00-Inbox/dailies",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = 'dailies.md'
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d %H:%M",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {
          id = function()
            return os.date("%Y%m%d%H%M")
          end,
          title_date = function()
            return os.date("%B %-d, %Y")
          end
        },
      },

      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({"open", url})  -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
      },
    },
  }
}
