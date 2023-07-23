return {
    "nvim-tree/nvim-web-devicons",
    config = function()
        require'nvim-web-devicons'.setup {
            override_by_extension = {
                ["doc"]  = {icon = ""},
                ["docx"] = {icon = ""},
                ["pdf"]  = {icon = ""},
                ["ppt"]  = {icon = ""},
                ["txt"]  = {icon = ""},
                ["xls"]  = {icon = ""},
                ["xlsx"] = {icon = ""},
                ["xml"]  = {icon = ""},
                ["log"]  = {icon = ""},
            };
        }
    end
}
