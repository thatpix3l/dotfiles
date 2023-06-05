return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" },
    config = function()
        local telescope = require("telescope")
        telescope.setup {}
        telescope.load_extension("fzy_native")

        local builtin = require("telescope.builtin")

        local keymap = {
            { mode = "n", keystroke = "<leader>ff", action = builtin.find_files },                 -- Search for file with name
            { mode = "n", keystroke = "<leader>ft", action = builtin.live_grep },                  -- Search for file containing text
            { mode = "n", keystroke = "<leader>fb", action = builtin.buffers },                    -- Search for buffer with name
            { mode = "n", keystroke = "<leader>r",  action = function() vim.lsp.buf.rename() end } -- Rename symbol under cursor with LSP
        }

        require("keymap").apply(keymap)
    end

}
