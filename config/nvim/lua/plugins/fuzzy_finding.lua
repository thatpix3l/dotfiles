return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" },
    config = function()

        local telescope = require("telescope")
        telescope.setup {}
        telescope.load_extension("fzy_native")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {}) -- Search for file names
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {}) -- Search inside files
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {}) -- Search for buffer

    end

}
