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
        -- Default PDF viewer
        vim.g.typst_pdf_viewer = "mupdf"

        -- Recompile typ file when typing
        require("lspconfig").typst_lsp.setup({
            settings = {
                exportPdf = "onType"
            }
        })

        -- Refresh PDF viewer on text changes
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            pattern = { "*.typ" },
            callback = function()
                vim.fn.jobstart("pkill --signal HUP mupdf")
            end
        })
    end
}
