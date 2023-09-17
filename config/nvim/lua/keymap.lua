local keymap = {}

keymap.apply = function(mappings)
    for _, mapping in pairs(mappings) do
        if mapping.mode == nil or mapping.keystroke == nil or mapping.action == nil then
            error("keymap does not have all required fields")
        end

        -- Add default options if no opts field already exists
        if mapping.opts == nil then
            mapping.opts = {
                silent = true -- Do not show output for mapping
            }
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
