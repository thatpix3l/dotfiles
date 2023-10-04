local m = {}

m.apply = function(autocmds)
    for _, autocmd in pairs(autocmds) do
        vim.api.nvim_create_autocmd(autocmd.events, autocmd.opts)
    end
end

return m
