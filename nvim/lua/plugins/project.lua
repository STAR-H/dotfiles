return {
  "ahmedkhalf/project.nvim",
  lazy = false,
  config = function()
    require("project_nvim").setup {
      detection_methods = { "pattern" },
      patterns = { ".git", ".root", ".project", "compile_command.json" },
    }
    vim.g.project_root_dir = require("project_nvim.project").get_project_root() or vim.uv.cwd()
  end
}
