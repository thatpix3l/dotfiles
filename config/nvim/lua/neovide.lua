-- Guard check for if not in a neovide instance
if vim.g.neovide == nil then
	return
end

-- Preferred font.
vim.opt.guifont = "IosevkaTerm Nerd Font Mono"

-- Toggle fullscreen.
local toggle_fullscreen = function()
	if vim.g.neovide_fullscreen == nil then
		vim.g.neovide_fullscreen = true
	else
		vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
	end
end

require("keymap").apply({
	{ mode = { "n", "i", "t" }, keystroke = "<A-CR>", action = toggle_fullscreen } -- Toggle fullscreen
})
