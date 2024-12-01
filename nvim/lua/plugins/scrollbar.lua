return {
    {
        "kevinhwang91/nvim-hlslens",
        event = "VeryLazy",
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
