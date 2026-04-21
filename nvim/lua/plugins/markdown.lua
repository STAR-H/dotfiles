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
        border = true,
        border_virtual = true,
        -- Used above heading for border.
        above = '─',
        -- above = '·',
        -- Used below heading for border.
        below = '─',
        -- below = '·',
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        -- Highlight for the heading and sign icons.
        -- Output is evaluated using the same logic as 'backgrounds'.
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },

      checkbox = {
        checked = { scope_highlight = '@markup.strikethrough' },
        right_pad = 0
      },

      pipe_table = {
        cell = 'padded',
        preset = 'round',
      },

      code = {
        width = 'full',
        -- WARNING: due to block mode is can not set rightt mragin and can deal with 
        -- wraped lines, so fallback to full mode.

        -- Minimum width to use for code blocks when width is 'block'.
        -- min_width = 120,
        -- left_margin = 0,
        -- left_pad = 0,
        -- right_pad = 0,
        -- Whether to include the language icon above code blocks.
        language_icon = true,
        -- Whether to include the language name above code blocks.
        language_name = true,
        -- Whether to include the language info above code blocks.
        language_info = true,
        language = true,
      },

      quote = {
        repeat_linebreak = true
      },

      link = {
        footnote = {
          icon = ''
        }
      },

      win_options = {
        showbreak = {
          default = '',
          rendered = '  ',
        },
        breakindent = {
          default = false,
          rendered = true,
        },
        breakindentopt = {
          default = '',
          rendered = '',
        },
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

    end,

    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- NOTE: override markdown highlights
      vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = none })
      vim.api.nvim_set_hl(0, '@markup.raw.block.markdown', { fg = '#c2ccd0' })
      vim.api.nvim_set_hl(0, '@markup.raw.markdown_inline', { bg = '#434343', fg = '#ff4c00' })
      vim.api.nvim_set_hl(0, 'RenderMarkdownInlineHighlight', { bg = '#6b3f1d', bold = true })

      vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#3a3735' })
      vim.api.nvim_set_hl(0, 'RenderMarkdown_RendermarkdownCodeBorder_bg_as_fg', { link = 'RenderMarkdownCode' })

      -- H1 (yellow)
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { fg = "#e6c384", bg = "#4a412a", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1",   { fg = "#e6c384", bold = true })

      -- H2 (green)
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { fg = "#c0d8a0", bg = "#3f4a36", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2",   { fg = "#c0d8a0", bold = true })

      -- H3 (aqua)
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { fg = "#a8d5c4", bg = "#384a46", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3",   { fg = "#a8d5c4", bold = true })

      -- H4 (blue)
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { fg = "#b0c8e0", bg = "#38424a", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4",   { fg = "#b0c8e0", bold = true })

      -- H5 (purple)
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { fg = "#d0b8e0", bg = "#44384a", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5",   { fg = "#d0b8e0", bold = true })

      -- H6 (neutral gray)
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { fg = "#b8b8b8", bg = "#3a3a3a", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6",   { fg = "#b8b8b8", bold = true })    end

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
    enabled = vim.loop.os_uname().sysname == "Darwin",
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
    enabled = false,
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
          path = "~/Documents/OneDrive/obsidian",
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
