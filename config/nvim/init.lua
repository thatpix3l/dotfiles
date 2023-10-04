-- Turn off higlight when done searching
vim.api.nvim_create_namespace("search")
local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
local manageSearch = function(char)
    local pressedKey = vim.fn.keytrans(char)
    if vim.fn.mode() == "n" then
        if not vim.tbl_contains(keys, pressedKey) then
            vim.cmd("set nohlsearch")
        else
            vim.cmd("set hlsearch")
        end
    end
end

vim.on_key(manageSearch, vim.api.nvim_create_namespace("search"))

-- Line numbering
vim.opt.relativenumber = true -- enable relative numbers for all lines
vim.opt.number = true         -- enable absolute number for current line
vim.opt.numberwidth = 3       -- width for numbers column
vim.opt.cursorcolumn = true   -- highlight cursor column
vim.opt.cursorline = true     -- highlight cursor line
vim.opt.signcolumn = "yes"    -- always enable sign column

-- Status line
vim.opt.laststatus = 3                       -- global statusline
vim.cmd("highlight WinSeparator guibg=none") -- transparent window separators

-- Absolute number is highlighted, relative numbers are grayed out
vim.cmd("highlight LineNr guifg=#ffffff")
vim.cmd("highlight LineNrAbove guifg=#575757")
vim.cmd("highlight LineNrBelow guifg=#575757")

-- Indentation, tabs, spaces
vim.opt.shiftwidth = 4   -- Indentation of 4
vim.opt.tabstop = 4      -- Tabs width of 4
vim.opt.expandtab = true -- Tabs to spaces

-- Space as leader key
vim.g.mapleader = " "

-- Neovide-specific customizations
vim.g.neovide_transparency = 0.95           -- Transparency
vim.opt.guifont = "FiraCode Nerd Font Mono" -- Font

local km = require("keymap")
local acmds = require("autocommands")

-- Apply key mappings
km.apply({
    { mode = "n", keystroke = "<C-k>",      action = "<C-y>k" },                   -- Scroll up, cursor stays
    { mode = "n", keystroke = "<C-j>",      action = "<C-e>j" },                   -- Scroll down, cursor stays
    { mode = "n", keystroke = "<leader>sk", action = ":topleft split<CR>" },       -- Create split north
    { mode = "n", keystroke = "<leader>sj", action = ":botright split<CR>" },      -- Create split south
    { mode = "n", keystroke = "<leader>sl", action = ":botright vsp<CR>" },        -- Create split east
    { mode = "n", keystroke = "<leader>sh", action = ":topleft vsp<CR>" },         -- Create split west
    { mode = "n", keystroke = "<S-w>",      action = "<C-w>+" },                   -- Increase split height
    { mode = "n", keystroke = "<S-s>",      action = "<C-w>-" },                   -- Decrease split height
    { mode = "n", keystroke = "<S-d>",      action = "<C-w>>" },                   -- Increase split width
    { mode = "n", keystroke = "<S-a>",      action = "<C-w><" },                   -- Decrease split width
    { mode = "n", keystroke = "<A-a>",      action = "0vg_:m .-2<CR>" },           -- Move line upward
    { mode = "n", keystroke = "<A-d>",      action = "0vg_:m .+1<CR>" },           -- Move line downward
    { mode = "n", keystroke = "<A-w>",      action = "j^d$k$pjddk$" },             -- Bring up next line onto end of current line
    { mode = "n", keystroke = "<A-s>",      action = "k^d$j$pkdd$" },              -- Bring down previous line onto end of current line
    { mode = "n", keystroke = "<S-z>",      action = vim.lsp.buf.signature_help }, -- Peek signature help under cursor
    { mode = "n", keystroke = "<C-w>",      action = ":bd<CR>" },                  -- Close focused buffer
    { mode = "v", keystroke = "<C-c>",      action = "\"+y" },                     -- Copy to system clipboard in visual mode
    { mode = "n", keystroke = "<C-S-v>",    action = "\"+p" },                     -- Paste from system clipboard in normal mode
    { mode = "t", keystroke = "<C-S-v>",    action = "<C-\\><C-n>\"+pi" }          -- Paste from system clipboard in terminal mode
})

-- Apply autocommands
acmds.apply({
    {
        events = { "BufWritePre" },
        opts = {
            callback = function()
                vim.lsp.buf.format()
            end
        }
    },
    {
        events = { "TermOpen" },
        opts = {
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
            end
        }
    }
})

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
require("lazy").setup("plugins")
