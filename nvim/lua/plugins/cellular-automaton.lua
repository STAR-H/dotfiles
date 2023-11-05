return {
    "Eandrju/cellular-automaton.nvim",
    enabled = not isDiffMode(),
    keys = {{"<space><space>"}},
    config = function()
        vim.keymap.set('n', '<space><space>', ":CellularAutomaton make_it_rain<cr>", {silent = true, nowait = true})
    end
}
