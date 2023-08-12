return {
    {
        "petertriho/nvim-scrollbar",
        dependencies = 'kevinhwang91/nvim-hlslens',
        config = function()
            require("scrollbar.handlers.search").setup({})
            require("scrollbar").setup({
                show = true,
                show_in_active_only = false,
                set_highlights = true,
                hide_if_all_visible = false, -- Hides everything if all lines are visible
                handle = {
                    text = " ",
                    blend = 100,
                    hide_if_all_visible = true,
                },
                marks = {
                    Cursor = {
                        text = "•",
                        priority = 0,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil, -- cterm
                        highlight = "Normal",
                    },
                    Search = {
                        text = { "-", "=" },
                        priority = 1,
                        color = "yellow",
                        highlight = "Search",
                    },
                },
                excluded_buftypes = {
                    "terminal",
                },
                handlers = {
                    diagnostic = false,
                    search = true,
                    handle = true,
                },
            })
        end
    },
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require('hlslens').setup({
                override_lens = function(render, posList, nearest, idx)
                    local text, chunks
                    local lnum, col = unpack(posList[idx])
                    if nearest then
                        local cnt = #posList
                        text = ('[%d/%d]'):format(idx, cnt)
                        chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
                    else
                        text = ('[%d]'):format(idx)
                        chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
                    end
                    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
                end

            })
        end
    }
}
