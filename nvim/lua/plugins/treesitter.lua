return {
    "nvim-treesitter/nvim-treesitter",
    enabled = not isDiffMode(),
    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = {
                "html",
                "python",
                "diff",
                "bash",
                "json",
                "vim",
                "lua",
                "c",
                "cpp",
                "comment",
                "markdown",
                "markdown_inline",
                "vim",
                "regex",
            },
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true;
                disable = function(lang, buf)
                    local max_filesize = 1024 * 1024 -- 1MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = false },
            incremental_selection = { enable = false },
            textobjects = { enable = false },
        }
    end
}
