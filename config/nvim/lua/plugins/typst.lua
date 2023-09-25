return {
    "nvarner/typst-lsp",
    dependencies = {
        {
            "kaarmu/typst.vim",
            ft = "typst",
            lazy = false
        },
        {
            "neovim/nvim-lspconfig"
        }
    },
    config = function()
        require("lspconfig").typst_lsp.setup({
            settings = {
                exportPdf = "onType"
            }
        })
    end
}
