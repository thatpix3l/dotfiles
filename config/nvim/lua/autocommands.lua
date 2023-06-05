local autocommands = {}

-- "m" for "mappings", as in the "mappings" of autocommands
local m = {
    {
        events = { "BufWritePre" },
        callback = function()
            vim.lsp.buf.format()
        end
    }
}

autocommands.apply = function()
    for _, mapping in pairs(m) do
        local events = mapping.events
        mapping.events = nil
        vim.api.nvim_create_autocmd(events, mapping)
    end
end

return autocommands
