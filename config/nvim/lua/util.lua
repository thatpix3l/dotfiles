local util = {}

util.commandCallback = function(cmd)
    return function()
        vim.cmd(cmd)
    end
end

util.pad = function(input, padLeft, n, chars)
    while string.len(input) < n do
        if padLeft then
            input = chars .. input
        else
            input = input .. chars
        end
    end

    return input
end

util.get_visual_selection = function()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return table.concat(lines, '\n')
end

return util
