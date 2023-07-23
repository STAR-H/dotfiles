return {
    "nvim-lualine/lualine.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local diagnostics = {
            "diagnostics",
            sources  = { "coc" },
            sections = { "error", "warn" },
            symbols  = { error = " ", warn = " " },
            colored  = true,
            update_in_insert = false,
            always_visible   = false,
        }
        local diff = {
            'diff',
            colored = true, -- Displays a colored diff status if set to true
            diff_color = {
                -- Same color values as the general color option can be used here.
                added    = 'DiffAdd',    -- Changes the diff's added color
                modified = 'DiffChange', -- Changes the diff's modified color
                removed  = 'DiffDelete', -- Changes the diff's removed color you
            },
            symbols = {added = ' ', modified = ' ', removed = ' '}, -- Changes the symbols used by the diff.
        }

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'gruvbox-material', --gruvbox-material / nord
                section_separators   = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {"NvimTree", "tagbar"},
                    winbar     = {"NvimTree", "tagbar"},
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
                lualine_b = {diagnostics, diff},
                lualine_c = {
                    { 'filename',
                    file_status = true,      -- Displays file status (readonly status, modified status)
                    newfile_status = false,  -- Display new file status (new file means no write after created)
                    path = 1,
                    symbols = {
                        modified = '[+]',      -- Text to show when the file is modified.
                        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                        unnamed  = '[No Name]', -- Text to show for unnamed buffers.
                        newfile  = '[New]',     -- Text to show for newly created file before first write
                    },
                }
            },
            lualine_x = {'encoding', 'filesize', 'filetype'},
            lualine_y = {'progress', 'selectioncount'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {'quickfix', 'nvim-tree'}
    }
end
}
