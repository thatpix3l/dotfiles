-- Turn off higlight when done searching
vim.api.nvim_create_namespace('search')
local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
local manageSearch = function(char)
    local pressedKey = vim.fn.keytrans(char)
    if vim.fn.mode() == 'n' then
        if not vim.tbl_contains(keys, pressedKey) then
            vim.cmd("set nohlsearch")
        elseif vim.tbl_contains(keys, pressedKey) then
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

-- Space is leader key
vim.g.mapleader = ' '

-- Font
vim.opt.guifont = "FiraCode Nerd Font Mono"

local cmdCallback = function(cmdStr)
    return function()
        vim.cmd(cmdStr)
    end
end

-- Apply keymap of stuff without plugins
local keymapVanilla = {
    { mode = "n", keystroke = "<leader>pv", action = vim.cmd.Ex },
    { mode = "n", keystroke = "<A-k>",      action = "<C-y>k" },                      -- Scroll up, cursor stays
    { mode = "n", keystroke = "<A-j>",      action = "<C-e>j" },                      -- Scroll down, cursor stays
    { mode = "n", keystroke = "<leader>sh", action = cmdCallback("topleft vsp") },    -- Create split to the left
    { mode = "n", keystroke = "<leader>sj", action = cmdCallback("botright split") }, -- Create split below
    { mode = "n", keystroke = "<leader>sk", action = cmdCallback("topleft split") },  -- Create split above
    { mode = "n", keystroke = "<leader>sl", action = cmdCallback("botright vsp") },   -- Create split to the right
}

-- Apply vanilla keymaps
require("keymap").apply(keymapVanilla)

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

-- LSP
-- local lsp = require('lsp-zero').preset({})
-- lsp.on_attach(function(_, bufnr)
--     lsp.default_keymaps({ buffer = bufnr })
-- end)
--
-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
-- lsp.setup()

-- Apply autocommands
require("autocommands").apply()
