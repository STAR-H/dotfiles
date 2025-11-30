return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
    "folke/noice.nvim"
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end

    vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#32302f' })
    -- lualine diff status highlight override
    vim.api.nvim_set_hl(0, 'stlDiffAdd', { fg = '#b8bb26', bg = '#32302f' })
    vim.api.nvim_set_hl(0, 'stlDiffDelete', { fg = '#fb4934', bg = '#32302f' })
    vim.api.nvim_set_hl(0, 'stlDiffModified', { fg = '#f18019', bg = '#32302f' })
  end,
  config = function()
    vim.o.laststatus = vim.g.lualine_laststatus
    local function diagnostics_component()
      local bufnr = vim.api.nvim_get_current_buf()
      if not vim.diagnostic.is_enabled() then
        return string.format("%%#LualineDiagOff#󰦞")
      end
      -- 获取当前缓冲区的诊断统计信息
      local diagnostics = vim.diagnostic.get(bufnr)
      local error_count = 0
      local warning_count = 0

      for _, diag in ipairs(diagnostics) do
        if diag.severity == vim.diagnostic.severity.ERROR then
          error_count = error_count + 1
        elseif diag.severity == vim.diagnostic.severity.WARN then
          warning_count = warning_count + 1
        end
      end

      if error_count == 0 and warning_count == 0 then
        return string.format("%%#LualineDiagOn#󰒘")
      elseif error_count == 0 and warning_count ~= 0 then
        return string.format("%%#LualineWarning# %d", warning_count)
      elseif error_count ~= 0 and warning_count == 0 then
        return string.format("%%#LualineError# %d", error_count)
      end

      return string.format("%%#LualineError# %d %%#LualineWarning# %d", error_count, warning_count)
    end

    vim.api.nvim_set_hl(0, "LualineError", { fg = '#FF0000', bg = '#32302f', bold = true })
    vim.api.nvim_set_hl(0, "LualineWarning", { fg = '#FFA500', bg = '#32302f', bold = true })
    vim.api.nvim_set_hl(0, "LualineDiagOn", { fg = '#93f542', bg = '#32302f' })
    vim.api.nvim_set_hl(0, "LualineDiagOff", { fg = '#FF0000', bg = '#32302f' })

    local diff = {
      'diff',
      colored = true,   -- Displays a colored diff status if set to true
      diff_color = {
        -- Same color values as the general color option can be used here.
        added    = 'stlDiffAdd', -- Changes the diff's added color
        modified = 'stlDiffModified', -- Changes the diff's modified color
        removed  = 'stlDiffDelete', -- Changes the diff's removed color you
      },
      symbols = { added = '  ', modified = '  ', removed = '  ' }, -- Changes the symbols used by the diff.
    }

    local navic_status, navic = pcall(require, 'nvim-navic')
    local noice_status, noice = pcall(require, 'noice')

    require('lualine').setup {
      options = {
        icons_enabled        = true,
        theme                = 'gruvbox-material',   --gruvbox-material / nord
        section_separators   = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes   = {
          statusline = { "nvdash" },
        },
        ignore_focus         = {
          "NvimTree",
          "tagbar",
          "undotree",
          "vista_kind",
          "vista_markdown",
          "trouble",
          "AvanteInput",
          "AvanteSelectedFiles",
          "Avante",
          "gitsigns-blame"
        },
        always_divide_middle = true,
        globalstatus         = true,
        refresh              = {
          statusline = 500,
          tabline    = 1000,
          winbar     = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { diagnostics_component, diff },
        lualine_c = {
          { 'filename',
            file_status = true,       -- Displays file status (readonly status, modified status)
            newfile_status = false,   -- Display new file status (new file means no write after created)
            path = 1,
            symbols = {
              modified = '[+]',         -- Text to show when the file is modified.
              readonly = '[RO]',        -- Text to show when the file is non-modifiable or readonly.
              unnamed  = '[No Name]',   -- Text to show for unnamed buffers.
              newfile  = '[New]',       -- Text to show for newly created file before first write
            },
          },
          -- Show @recording messages in statusline
          {
            function()
              return noice.api.status.mode.get()
            end,
            cond = function()
              if noice_status then
                return noice.api.status.mode.has()
              else
                return false
              end
            end,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_x = {
          {
            function()
              if navic_status then
                return navic.get_location()
              else
                return
              end
            end,
            cond = function()
              if navic_status then
                return navic.is_available()
              else
                return
              end
            end
          },
          {
            function()
                return "󰓆[" .. table.concat(vim.opt.spelllang:get(), ",") .. "]"
            end,
            color = { fg = "#ffaa00", gui = "bold" },
            cond = function()
              return vim.wo.spell
            end
          },

          {
            function()
              local stbufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
              if rawget(vim, "lsp") then
                for _, client in ipairs(vim.lsp.get_clients()) do
                  if client.attached_buffers[stbufnr] and client.name ~= "null-ls" then
                    return (vim.o.columns > 100 and "  " .. client.name .. " ") or " LSP "
                  end
                end
              end

              return ""
            end,
            color = { fg = "#ff9e64" },

          },
          'filesize', 'filetype' },
        lualine_y = {
          {
            function()
              return " " .. vim.fn.fnamemodify(vim.g.project_root_dir, ':t')
            end,
            cond = function()
              if vim.g.project_root_dir == nil or vim.g.project_root_dir == "" then
                return false
              else
                return true
              end
            end,
            color = {
              bg = "#32302f",
              fg = "#458588",
            }
          },
          'selectioncount' },
        lualine_z = { 'progress' }
      },
      winbar = {},
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {
          {
            function()
              if navic_status then
                return navic.get_location()
              else
                return
              end
            end,

            cond = function()
              if navic_status then
                return navic.is_available()
              else
                return
              end
            end,
          },
          'location' },
        lualine_y = {},
        lualine_z = {}
      },
      extensions = { 'quickfix', 'nvim-tree' }
    }
  end
}
