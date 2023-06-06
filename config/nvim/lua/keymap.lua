local keymap = {}

keymap.apply = function(mappings)
    for _, mapping in pairs(mappings) do
        if mapping.mode == nil or mapping.keystroke == nil or mapping.action == nil then
            error("keymap does not have all required fields")
        end

        vim.keymap.set(
            mapping.mode,
            mapping.keystroke,
            mapping.action
        )
    end
end

return keymap
