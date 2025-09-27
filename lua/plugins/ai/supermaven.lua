return {{
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("supermaven-nvim").setup({
            keymaps = {
                accept_suggestion = "<C-j>",
                clear_suggestion = "<C-z>",
                accept_word = "<C-J>"
            },
            color = {
                  suggestion_color = "#6c7086",
                cterm = 244
            }
        })
    end
}}
