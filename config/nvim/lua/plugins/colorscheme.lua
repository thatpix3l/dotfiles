return {
    "Shatur/neovim-ayu",
    config = function()
        vim.opt.termguicolors = true
        vim.cmd.colorscheme("ayu")
    end
}
