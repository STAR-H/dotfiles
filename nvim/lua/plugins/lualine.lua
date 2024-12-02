return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-navic',
    },
    config = function()
        local function diagnostics_component()
            local bufnr = vim.api.nvim_get_current_buf()
            if vim.diagnostic.is_disabled(bufnr) then
                return ""
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
                return ""
            end

            return string.format("%%#LualineError# %d %%#LualineWarning# %d", error_count, warning_count)
        end

        vim.api.nvim_set_hl(0, "LualineError", {fg = '#FF0000', bold = true})
        vim.api.nvim_set_hl(0, "LualineWarning", {fg = '#FFA500', bold = true})

        local diff = {
            'diff',
            colored = true, -- Displays a colored diff status if set to true
            diff_color = {
                -- Same color values as the general color option can be used here.
                added    = 'DiffAdd',    -- Changes the diff's added color
                modified = 'DiffChange', -- Changes the diff's modified color
                removed  = 'DiffDelete', -- Changes the diff's removed color you
            },
            symbols = {added = '  ', modified = '  ', removed = '  '}, -- Changes the symbols used by the diff.
        }
        local navic = require("nvim-navic")

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'gruvbox-material', --gruvbox-material / nord
                section_separators   = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {"NvimTree", "tagbar", "undotree", "vista_kind"},
                    winbar     = {"NvimTree", "tagbar", "undotree", "vista_kind"},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 500,
                    tabline    = 1000,
                    winbar     = 1000,
                }
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {diagnostics_component, diff},
                lualine_c = {
                    { 'filename',
                    file_status = true,      -- Displays file status (readonly status, modified status)
                    newfile_status = false,  -- Display new file status (new file means no write after created)
                    path = 1,
                    symbols = {
                        modified = '[+]',      -- Text to show when the file is modified.
                        readonly = '[RO]',      -- Text to show when the file is non-modifiable or readonly.
                        unnamed  = '[No Name]', -- Text to show for unnamed buffers.
                        newfile  = '[New]',     -- Text to show for newly created file before first write
                    },
                },
                -- Show @recording messages in statusline
                {
                    require("noice").api.statusline.mode.get,
                    cond = require("noice").api.statusline.mode.has,
                    color = { fg = "#ff9e64" },
                },
            },
            lualine_x = {
            {
                function()
                    return navic.get_location()
                end,
                cond = function()
                    return navic.is_available()
                end
            },
            'encoding', 'filesize', 'filetype'},
            lualine_y = {'progress', 'selectioncount'},
            lualine_z = {'location'}
        },
        winbar = {},
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {
                {
                    function()
                        return navic.get_location()
                    end,
                    cond = function()
                        return navic.is_available()
                    end
                },
                'location'},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {'quickfix', 'nvim-tree'}
    }
end
}
