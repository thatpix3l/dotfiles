return {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim"
    },
    config = function()

        local binds = {
            { mode = "n", keystroke = "<CR>", action = "<cmd>FineCmdline<CR>", opts = { noremap = true } } -- Floating command on enter
        }

        require("keymap").apply(binds)

        vim.opt.cmdheight = 0 -- Make internal comman line invisible

    end
}
