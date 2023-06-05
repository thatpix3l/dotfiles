return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' }, -- Required
        {
            -- Optional
            'williamboman/mason.nvim',
            build = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        { 'williamboman/mason-lspconfig.nvim' }, -- Optional

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },     -- Required
        { 'hrsh7th/cmp-nvim-lsp' }, -- Required
        { 'L3MON4D3/LuaSnip' },     -- Required
        { "nvim-telescope/telescope.nvim" }
    },
    config = function()
        -- Attah LSP to buffer
        local lsp = require('lsp-zero').preset({})
        lsp.on_attach(function(_, bufnr)
            lsp.default_keymaps({ buffer = bufnr })
        end)

        -- Setup IDE-like tab completion
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")

        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        lsp.setup()

        cmp.setup {
            mapping = {
                -- Enter in insert mode accepts suggested completion
                ["<Enter>"] = cmp.mapping.confirm { select = true },

                -- Insert mode: Tab cycles forward a suggested completion
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- they way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                -- Insert mode: Shift-Tab cycles backward a suggested completion
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            }

        }

        -- Keymap for LSP-related stuff
        local builtin = require("telescope.builtin")
        local keymap = {
            {
                mode = "n",
                keystroke = "<leader>fr",
                action = function()
                    builtin.lsp_references()
                end
            }
        }

        require("keymap").apply(keymap)
    end
}
