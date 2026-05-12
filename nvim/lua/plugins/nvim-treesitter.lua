---Tree-sitter parser management and syntax highlighting.
return {
  "nvim-treesitter/nvim-treesitter",
  enabled = not require("configs.utils").is_diff_mode(),
  event = { "BufReadPost", "BufNewFile" },
  branch = "master",
  lazy = false,
  config = function()
    local opts = {
      ensure_installed = {
        "html",
        "python",
        "diff",
        "bash",
        "json",
        "vim",
        "vimdoc",
        "lua",
        "c",
        "cpp",
        "markdown",
        "markdown_inline",
        "regex",
        "query",
        "xml",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 1024 * 1024 -- 1MB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))

          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false }, -- influnce = indent
      incremental_selection = { enable = false },
      textobjects = { enable = true },
    }
    require("nvim-treesitter.configs").setup(opts)
  end,
}
