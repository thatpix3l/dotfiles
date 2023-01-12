-- Guard for if running inside of VSCode
if vim.api.nvim_eval('exists("g:vscode")') == 1 then
    print('Detected VSCode, skipping neovim config...')
    return
end

-- Load plugin manager
require('plugins')

-- Colorscheme
vim.opt.background = 'light'
vim.opt.termguicolors = true
vim.cmd('colorscheme breezy')

-- Line numbering
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'

-- Expand tabs to spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Enable mouse
vim.opt.mouse = 'a'

-- Global statusline
vim.o.laststatus = 3
vim.api.nvim_exec('highlight WinSeparator guibg=None', true) -- Separator

-- Load mason LSP config
local mason_lsp = require('mason-lspconfig')

-- Ensure that the following LSP servers are installed
mason_lsp.setup({
        ensure_installed = {
            'vls', -- VLang support
            'gopls', -- Golang support
            'sumneko_lua', -- Lua suport
            'rust_analyzer', -- Rust support
            -- 'svelte', -- Svelte support
            'tsserver', -- TypeScript support
            -- 'zls' -- Zig support
        }
    })

-- Setup all installed language servers
mason_lsp.setup_handlers({
        function(server_name)
            local server_props = {}

            if server_name == "sumneko_lua" then
                server_props.settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            end

            server_props.capabilities = require('cmp_nvim_lsp').default_capabilities()

            require('lspconfig')[server_name].setup(server_props)

        end
    })

-- Load auto-complete
local cmp = require('cmp')

-- Helper func for returning a closure that runs a given action if the completion list is visible
local cmp_run_visible = function(action)
    return function(fallback)
        if cmp.visible() then
            action()
        else
            fallback()
        end
    end
end

local luasnip = require('luasnip')

cmp.setup({

        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },

        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
            }),

        mapping = {
            -- Select next item
            ["<Tab>"] = cmp_run_visible(cmp.select_next_item),

            -- Select previous item
            ["<S-Tab>"] = cmp_run_visible(cmp.select_prev_item),

            -- Choose selected item
            ["<C-Space>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            }

        }
    })

-- Keybinds
local map = require('utils').map

-- In normal mode, pressing F2 runs in command mode neovim's LSP rename feature
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })

require('which-key').register({
        q = {
            name = "Quit",
            b = { "<cmd>q!<CR>", "Quit buffer without saving"}
        },
        t = {
            name = "Toggle",
            e = { '<cmd>NvimTreeToggle<CR>', 'Toggle explorer' },
            t = { '<cmd>ToggleTerm direction=float<CR>', 'Toggle terminal' }
        }
    }, { prefix = '<leader>' })

-- Timeout (affects leader key)
vim.opt.timeoutlen = 0

-- Auto-command for setting V language filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = {"*.v"},
        callback = function() vim.opt.filetype = "vlang" end
    })

