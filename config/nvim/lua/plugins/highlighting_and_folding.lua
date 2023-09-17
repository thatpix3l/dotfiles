return {
    'nvim-treesitter/nvim-treesitter',
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "go",
                "bash", "javascript", "typescript",
                "yaml", "json", "zig"
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        }
        vim.cmd("TSUpdate")
    end
}
