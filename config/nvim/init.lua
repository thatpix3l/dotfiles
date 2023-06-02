vim.opt.shiftwidth = 4 -- Indentation of 4
vim.opt.tabstop = 4 -- Tabs width of 4
vim.opt.expandtab = true -- Tabs to spaces

vim.g.mapleader = ' ' -- Space is leader key

local mappingTable = {
    {"n", "<leader>pv", vim.cmd.Ex},
    {"n", "<esc>", vim.cmd.nohlsearch}, -- Clear search
    {"n", "<A-k>", "<C-y>k"}, -- Scroll page and cursor up
    {"n", "<A-j>", "<C-e>j"} -- Scroll page and cursor down
}

for _, mapping in pairs(mappingTable) do
    vim.keymap.set(mapping[1], mapping[2], mapping[3])
end

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- File manager
-- vim.keymap.set("n", "<esc>", vim.cmd.nohlsearch) -- Clear search with escape key

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
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 1

vim.cmd.highlight {args = {"LineNr", "guifg=white"}}
vim.cmd.highlight {args = {"LineNrAbove", "guifg=gray"}}
vim.cmd.highlight {args = {"LineNrBelow", "guifg=gray"}}

