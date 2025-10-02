return {
  {
    "yetone/avante.nvim",
    enabled = not require("configs.utils").is_diff_mode(),
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "deepseek",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
          extra_request_body = {
            max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
            -- reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
          },
        },
      },

      windows = {
        ---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
        position = "right",
        wrap = true,        -- similar to vim.o.wrap
        width = 40,         -- default % based on available width in vertical layout
        sidebar_header = {
          enabled = true,   -- true, false to enable/disable the header
          align = "center", -- left, center, right for title
          rounded = true,
        },
        input = {
          prefix = "󰭹 ",
          height = 10, -- Height of the input window in vertical layout
        },
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      -- fg need same as WinSeparator
      vim.api.nvim_set_hl(0, 'AvanteSidebarWinSeparator', { fg = '#808080', bg = '#232323' })
      vim.api.nvim_set_hl(0, 'AvanteSidebarWinHorizontalSeparator', { fg = '#36393a', bg = '#232323' })
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
    },
  },
}
