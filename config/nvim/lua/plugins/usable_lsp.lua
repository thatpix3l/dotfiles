local pum_next = function(nextChar)
    return function()
        return vim.fn.pumvisible() == 1 and "<C-n>" or nextChar
    end
end

local pum_prev = function(prevChar)
    return function()
        return vim.fn.pumvisible() == 1 and "<C-p>" or prevChar
    end
end

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        -- LSP Support
        "neovim/nvim-lspconfig",                      -- Neovim's LSP boilerplate
        "williamboman/mason.nvim",                    -- LSP package manager
        { "echasnovski/mini.nvim", version = false }, -- Bunch of function stuff, including basic completion engine
        "ii14/emmylua-nvim"                           -- Completion for neovim's internal Lua APIs
    },
    config = function()
        require("mason").setup()           -- Initialize LSP package manager
        require("mason-lspconfig").setup() -- Initialize thing that communicates with lspconfig

        local lspconfig = require("lspconfig")

        -- Configuration of existing LSPs
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
                root_dir = function()
                    return vim.fs.dirname(vim.fs.find(
                        { '.gradlew', '.gitignore', 'mvnw', 'build.grade.kts' }, { upward = true })[1]) .. "\\"
                end
            },

            -- Go
            gopls = {},
        }

        -- For each configured LSP, activate it
        for lsp_name, config in pairs(lsp_configs) do
            lspconfig[lsp_name].setup(config)
        end

        -- Load completion
        require("mini.completion").setup()

        local binds = {
            { mode = "i", keystroke = "<Tab>",   action = pum_next("<Tab>"),   opts = { expr = true } }, -- Tab to next completion match
            { mode = "i", keystroke = "<S-Tab>", action = pum_prev("<S-Tab>"), opts = { expr = true } }  -- Tab to previous completion match
        }

        require("keymap").apply(binds)
    end
}
