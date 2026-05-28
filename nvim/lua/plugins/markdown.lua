---Markdown enhancements: render-markdown + img-clip.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = { { "<C-e>", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "RenderMarkdown toggle" } },
    opts = {
      enabled = true,
      file_types = { "markdown" },
      completions = { lsp = { enabled = true } },

      sign = { enabled = false },

      heading = {
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
        width = "block",
        position = "inline",
        left_pad = 1,
        right_pad = 1,
        border = true,
        border_virtual = true,
        -- Used above heading for border.
        above = "─",
        -- Used below heading for border.
        below = "─",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      checkbox = {
        checked = { scope_highlight = "@markup.strikethrough" },
        right_pad = 0
      },

      pipe_table = {
        cell = "padded",
        preset = "round",
        border_virtual = true,
      },

      code = {
        width = "full",
        -- WARNING: block mode cannot set right margin and cannot deal with
        -- wrapped lines, so fallback to full mode.

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
          icon = ""
        }
      },

      win_options = {
        showbreak = {
          default = "",
          rendered = "  ",
        },
        breakindent = {
          default = false,
          rendered = true,
        },
        breakindentopt = {
          default = "",
          rendered = "",
        },
      },

      anti_conceal = { enabled = false },

      indent = { enabled = false },

      preset = "obsidian",
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
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline",      { bg = "NONE" })
      vim.api.nvim_set_hl(0, "@markup.raw.block.markdown",    { fg = "#c2ccd0" })
      vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline",   { bg = "#434343", fg = "#ff4c00" })
      vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { bg = "#6b3f1d", bold = true })

      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#3a3735" })
      vim.api.nvim_set_hl(0, "RenderMarkdown_RendermarkdownCodeBorder_bg_as_fg", { link = "RenderMarkdownCode" })

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

  -- image paste from clipboard into markdown
  {
    "HakonHarnes/img-clip.nvim",
    enabled = require("configs.platform").is_macos,
    ft = { "markdown" },
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
}
