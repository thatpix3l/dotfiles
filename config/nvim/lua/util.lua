local util = {}

util.commandCallback = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

return util
