return {
    'numToStr/Comment.nvim',
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        local context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

        require('Comment').setup({
            padding = true,
            sticky = true,
            ignore = "^$",
            toggler = {
                line = "<leader>/",
            },
            opleader = {
                line = "<leader>/"
            },
            pre_hook = context_commentstring.create_pre_hook()
        })
    end
}
