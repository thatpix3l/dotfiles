vim.cmd [[ packadd packer.nvim ]]

return require('packer').startup(function(use)

    local setup = function(repo, name, overrides)
        local options = {
            repo
        }
        -- Load the plugin
        use(options)

        if overrides ~= nil then
            for k, v in pairs(overrides) do
                if k ~= nil then
                    options[k] = v
                end
            end
        end

        -- Setup the plugin
        require(name).setup{}
    end

    use('wbthomason/packer.nvim') -- neovim pkg manager

    use('folke/neodev.nvim') -- neovim lua API support
    use('sheerun/vim-polyglot') -- Support for a ton of languages

    use('fneu/breezy') -- Color scheme

    -- LSP package manager
    setup('williamboman/mason.nvim', 'mason')

    use('neovim/nvim-lspconfig') -- Quickstart configs for the built-in LSP client
    use('williamboman/mason-lspconfig.nvim') -- Bridge between mason and neovim's built-in LSP client

    setup('windwp/nvim-autopairs', 'nvim-autopairs') -- Auto close brackets/braces/parentheses

    use('hrsh7th/nvim-cmp') -- Auto-complete
    use('hrsh7th/cmp-nvim-lsp') -- Auto-complete extras
    use('L3MON4D3/LuaSnip') -- Snippets

    setup('lewis6991/gitsigns.nvim', 'gitsigns') -- Git signs for line numbers
    setup('stevearc/dressing.nvim', 'dressing')

    -- File tree
    setup('kyazdani42/nvim-tree.lua', 'nvim-tree', {
        requires = {
            'kyazdani42/nvim-web-devicons'
        }
    })

    setup('akinsho/toggleterm.nvim', 'toggleterm', { tag = 'v2.*' })

    setup('folke/which-key.nvim', 'which-key')

end)


