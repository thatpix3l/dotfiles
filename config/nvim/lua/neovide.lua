-- Guard check for if not in a neovide instance
if vim.g.neovide == nil then
    return
end

local nv = function(key, value)
    vim.g["neovide_" .. key] = value
end

vim.g.neovide_transparency = 0.8            -- window transparency
vim.g.neovide_cursor_vfx_mode = "railgun"   -- cursor particles
vim.opt.guifont = "FiraCode Nerd Font Mono" -- font

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
