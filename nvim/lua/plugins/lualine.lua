---Blazing fast and easy to configure Neovim statusline.
local stl_bg = "#32302f"

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
    "folke/noice.nvim",
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

    vim.api.nvim_set_hl(0, "StatusLine", { bg = stl_bg })
  end,
  config = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    -- diagnostics status component
    local function diagnostics_component()
      local bufnr = vim.api.nvim_get_current_buf()
      if not vim.diagnostic.is_enabled() then
        return string.format("%%#LualineDiagOff#󰦞")
      end

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

    -- highlight groups
    vim.api.nvim_set_hl(0, "LualineError",    { fg = "#FF0000", bg = stl_bg, bold = true })
    vim.api.nvim_set_hl(0, "LualineWarning",  { fg = "#FFA500", bg = stl_bg, bold = true })
    vim.api.nvim_set_hl(0, "LualineDiagOn",   { fg = "#93f542", bg = stl_bg })
    vim.api.nvim_set_hl(0, "LualineDiagOff",  { fg = "#FF0000", bg = stl_bg })
    vim.api.nvim_set_hl(0, "stlDiffAdd",      { fg = "#b8bb26", bg = stl_bg })
    vim.api.nvim_set_hl(0, "stlDiffDelete",   { fg = "#fb4934", bg = stl_bg })
    vim.api.nvim_set_hl(0, "stlDiffModified", { fg = "#f18019", bg = stl_bg })

    -- diff component
    local diff = {
      "diff",
      colored = true,
      diff_color = {
        added    = "stlDiffAdd",
        modified = "stlDiffModified",
        removed  = "stlDiffDelete",
      },
      symbols = { added = "  ", modified = "  ", removed = "  " },
    }

    local navic_status, navic = pcall(require, "nvim-navic")
    local noice_status, noice = pcall(require, "noice")

    -- shared navic breadcrumb component
    local function navic_component()
      if not navic_status then
        return
      end
      return {
        function() return navic.get_location() end,
        cond = function() return navic.is_available() end,
      }
    end

    local is_windows = require("configs.platform").is_windows
    local section_b = { diagnostics_component }

    if not is_windows then
      table.insert(section_b, diff)
    end

    require("lualine").setup({
      options = {
        icons_enabled        = true,
        theme                = "gruvbox-material",
        section_separators   = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes   = {
          statusline = {},
        },
        ignore_focus         = {
          "NvimTree",
          "tagbar",
          "undotree",
          "aerial",
          "trouble",
          "gitsigns-blame",
          "TelescopePrompt",
        },
        always_divide_middle = true,
        globalstatus         = true,
        refresh = {
          statusline = 500,
          tabline    = 1000,
          winbar     = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { section_b },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = false,
            path = 1,
            symbols = {
              modified = "[+]",
              readonly = "[RO]",
              unnamed  = "[No Name]",
              newfile  = "[New]",
            },
          },
          -- noice recording indicator
          {
            function() return noice.api.status.mode.get() end,
            cond = function() return noice_status and noice.api.status.mode.has() end,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_x = {
          navic_component(),
          -- spell language indicator
          {
            function()
              return "󰓆[" .. table.concat(vim.opt.spelllang:get(), ",") .. "]"
            end,
            color = { fg = "#ffaa00", gui = "bold" },
            cond = function() return vim.wo.spell end,
          },
          -- active LSP client names
          {
            function()
              local stbufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
              local lsp_names = {}

              for _, client in ipairs(vim.lsp.get_clients()) do
                if client.attached_buffers[stbufnr] then
                  table.insert(lsp_names, client.name)
                end
              end

              if #lsp_names > 0 then
                if vim.o.columns > 100 then
                  return "  " .. table.concat(lsp_names, ",")
                else
                  return "  LSP"
                end
              end

              return ""
            end,
            color = { fg = "#ff9e64" },
          },
          "filesize",
          "filetype",
        },
        lualine_y = {
          -- project root directory name
          {
            function()
              return " " .. vim.fn.fnamemodify(vim.g.project_root_dir, ":t")
            end,
            cond = function()
              return vim.g.project_root_dir ~= nil and vim.g.project_root_dir ~= ""
            end,
            color = {
              bg = stl_bg,
              fg = "#458588",
            },
          },
          "selectioncount",
        },
        lualine_z = { "progress" },
      },
      winbar = {},
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {
          navic_component(),
          "location",
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "quickfix", "nvim-tree" },
    })
  end,
}
