return {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup {
            detection_methods = { "pattern" },
            patterns = { ".git", ".root", ".project" },
        }

        local tele_status_ok, telescope = pcall(require, "telescope")
        if not tele_status_ok then
            return
        end

        telescope.load_extension('projects')
    end
}
