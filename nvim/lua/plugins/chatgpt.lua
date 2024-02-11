return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = function()
        require("chatgpt").setup({
            api_key_cmd = "pass show api/token/openai",
            predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/STAR-H/awesome-chatgpt-prompts/main/prompts.csv"
        })
    end,
}
