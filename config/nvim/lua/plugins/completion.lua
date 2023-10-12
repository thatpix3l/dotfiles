-- Helper func for checking if there are words before the cursor
local has_words_before = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s')
end

return {
    "hrsh7th/nvim-cmp",            -- Main completion engine
    dependencies = {
        "neovim/nvim-lspconfig",   -- Predefined configs for a bunch of popular LSP servers
        -- "ii14/emmylua-nvim",       -- Completion for neovim's internal Lua APIs
        "hrsh7th/cmp-nvim-lsp",    -- Neovim LSP as completion source
        "L3MON4D3/LuaSnip",        -- Snippets
        "saadparwaiz1/cmp_luasnip" -- LuaSnip's snippets as completion source
    },
    config = function()
        local lspc = require("lspconfig")

        -- Configuration of LSP servers I want...
        local lsp_configs = {
            -- Lua
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true)
                        }
                    }
                }
            },

            -- Java
            jdtls = {
                single_file_support = true,
                root_dir = function()
                    return vim.fs.dirname(vim.fs.find(
                        { '.gradlew', '.gitignore', 'mvnw', 'build.grade.kts' }, { upward = true })[1]) .. "\\"
                end
            },

            -- Go
            gopls = {},
            -- C
            clangd = {}
        }

        -- Add message when an LSP gets attached
        for k, v in pairs(lsp_configs) do
            v.on_attach = function()
                print("lsp server \"" .. k .. "\" attached")
            end
        end

        local cmp = require("cmp")
        local ls = require("luasnip")

        cmp.setup({
            preselect = cmp.PreselectMode.None, -- Do not select any suggestions by default
            snippet = {
                expand = function(args)
                    ls.lsp_expand(args.body)
                end
            },
            mapping = {
                -- BEGIN move to next completion
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif ls.expand_or_jumpable() then
                        ls.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i" }),
                -- END move to next completion

                -- BEGIN move to previous completion
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif ls.jumpable(-1) then
                        ls.jump(-1)
                    else
                        fallback()
                    end
                end, { "i" }),
                -- END move to previous completion

                -- BEGIN accept current completion selection
                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                })
                -- END accept current completion selection
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- Use Neovim's LSP as a source for completions
                { name = "luasnip" }   -- Use LuaSnip's snippets as a source for completions
            })
        })

        -- For each configured LSP, activate it
        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        for lsp_name, config in pairs(lsp_configs) do
            config.capabilities = lsp_capabilities -- I'm not gonna lie, I have no idea what "capabilities" does...
            lspc[lsp_name].setup(config)           -- I DO know what this does on the other hand...
        end
    end
}
