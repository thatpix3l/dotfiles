local autocommands = {}

-- "m" for "mappings", as in the "mappings" of autocommands
local m = {
    {
        events = { "BufWritePre" },
        opts = {
            callback = function()
                vim.lsp.buf.format()
            end
        }

    },
    {
        events = { "TermOpen" },
        opts = {
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
            end
        }
    }
}

autocommands.apply = function()
    for _, mapping in pairs(m) do
        vim.api.nvim_create_autocmd(mapping.events, mapping.opts)
    end
end

return autocommands
