-- LSP for "templ" filetype
vim.lsp.start({
    cmd = { "templ", "lsp" },
    root_dir = vim.fn.getcwd()
})
