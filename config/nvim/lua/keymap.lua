local keymap = {}

local default_options = {
    silent = true,
    noremap = true
}

local required_keys = {
	"mode",
	"keystroke",
	"action"
}

local detected_required_keys = function(mapping)
	local data = {
		missing = false,
		keys = {}
	}

	for _, key in pairs(required_keys) do
		if mapping[key] == nil then
			table.insert(data.keys, key)
			data.missing = true
		end
	end

	return data

end

keymap.apply = function(mappings)
    for _, mapping in pairs(mappings) do

		local data = detected_required_keys(mapping)

		-- Error early if mapping is missing required keys.
		if data.missing then
			local missing_keys = table.concat(data.keys, ", ")
			error("keymap is missing required keys: " .. missing_keys)
		end

        if mapping.opts == nil then
            mapping.opts = {}
        end

        -- Add list of default options.
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
