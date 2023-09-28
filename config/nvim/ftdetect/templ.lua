-- "templ" filetype for any files that end with "*.templ"
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.templ" },
    callback = function(ev)
        vim.api.nvim_buf_set_option(0, "filetype", "templ")
    end
})
