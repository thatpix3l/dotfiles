local keymap = {}

local default_options = {
    silent = true,
    noremap = true
}

keymap.apply = function(mappings)
    for _, mapping in pairs(mappings) do
        if mapping.mode == nil or mapping.keystroke == nil or mapping.action == nil then
            error("keymap does not have all required fields")
        end

        if mapping.opts == nil then
            mapping.opts = {}
        end

        -- Add list of default options
        for opt, val in pairs(default_options) do
            if mapping.opts[opt] == nil then
                mapping.opts[opt] = val
            end
        end

        vim.keymap.set(
            mapping.mode,
            mapping.keystroke,
            mapping.action,
            mapping.opts
        )
    end
end

return keymap
