-- Turn off higlight when done searching
vim.api.nvim_create_namespace('search')
local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
local manageSearch = function(char)
    local pressedKey = vim.fn.keytrans(char)
    if vim.fn.mode() == 'n' then
        if not vim.tbl_contains(keys, pressedKey) then
            vim.cmd("set nohlsearch")
        else
            vim.cmd("set hlsearch")
        end
    end
end

vim.on_key(manageSearch, vim.api.nvim_create_namespace('search'))

-- Line numbering
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 1

-- Absolute number is highlighted, relative numbers are grayed out
vim.cmd("highlight LineNr guifg=#ffffff")
vim.cmd("highlight LineNrAbove guifg=#575757")
vim.cmd("highlight LineNrBelow guifg=#575757")

-- Indentation, tabs, spaces
vim.opt.shiftwidth = 4   -- Indentation of 4
vim.opt.tabstop = 4      -- Tabs width of 4
vim.opt.expandtab = true -- Tabs to spaces

-- Space as leader key
vim.g.mapleader = ' '

-- Neovide-specific customizations
vim.g.neovide_transparency = 0.95           -- Transparency
vim.opt.guifont = "FiraCode Nerd Font Mono" -- Font

local util = require("util")

vim.api.nvim_create_user_command(
    "Pad",
    function(opts)
        local padDirection = opts.fargs[1]
        local isLeftpad
        local promptStr

        if padDirection == "left" then
            isLeftpad = true
            promptStr = "Prefix"
        elseif padDirection == "right" then
            isLeftpad = false
            promptStr = "Suffix"
        else
            error("argument for \"Pad\" command is not \"left\" or \"right\"")
        end

        vim.ui.input(
            { prompt = promptStr .. " Chars: " },
            function(chars)
                vim.ui.input(
                    { prompt = "Pad Length: " },
                    function(chosenLength)
                        chosenLength = tonumber(chosenLength)
                        local selection = util.get_visual_selection()

                        vim.cmd.delete()
                        vim.cmd.startinsert()
                        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col,
                            { util.pad(selection, isLeftpad, chosenLength, chars) })
                    end
                )
            end
        )
    end,
    { nargs = 1 }
)

-- Apply keymap of stuff without plugins
local mappings = {
    { mode = "n", keystroke = "<C-w>",      action = "<C-y>k" },              -- Scroll up, cursor stays
    { mode = "n", keystroke = "<C-s>",      action = "<C-e>j" },              -- Scroll down, cursor stays
    { mode = "n", keystroke = "<leader>sh", action = ":topleft vsp<CR>" },    -- Create split to the left
    { mode = "n", keystroke = "<leader>sj", action = ":botright split<CR>" }, -- Create split to the bottom
    { mode = "n", keystroke = "<leader>sk", action = ":topleft split<CR>" },  -- Create split to the top
    { mode = "n", keystroke = "<leader>sl", action = ":botright vsp<CR>" },   -- Create split to the right
    { mode = "n", keystroke = "<S-w>",      action = "<C-w>+" },              -- Increase split height
    { mode = "n", keystroke = "<S-s>",      action = "<C-w>-" },              -- Decrease split height
    { mode = "n", keystroke = "<S-d>",      action = "<C-w>>" },              -- Increase split width
    { mode = "n", keystroke = "<S-a>",      action = "<C-w><" },              -- Decrease split width
    { mode = "n", keystroke = "<A-a>",      action = "0vg_:m .-2<CR>" },      -- Move line upward
    { mode = "n", keystroke = "<A-d>",      action = "0vg_:m .+1<CR>" },      -- Move line downward
    { mode = "n", keystroke = "<A-w>",      action = "j:left<CR>kgJ" },       -- Cut previous line, append to current line
    -- { mode = "n", keystroke = "<A-s>",      action = "<A-a><A-w>",         { noremap = false } }, -- Cut next line, append to current line
}

-- Apply vanilla keymaps
require("keymap").apply(mappings)

-- Boostrap "Lazy" package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

-- Apply autocommands
require("autocommands").apply()
