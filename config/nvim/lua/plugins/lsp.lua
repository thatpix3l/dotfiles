local jdtls_cfg = {
	root_dir = function()
		return vim.fs.dirname(vim.fs.find(
			{ '.gradlew', '.gitignore', 'mvnw', 'build.grade.kts' }, { upward = true })[1]) .. "\\"
	end
}

-- Customized LSP server configs.
local lsp_configs = {
	-- Lua
	lua_ls = {},

	-- Java
	jdtls = {},

	-- Go
	gopls = {},

	-- C
	clangd = {},

	-- Rust
	rust_analyzer = {},

	-- Templ
	templ = {},

	-- Typst
	typst_lsp = {
		settings = {
			exportPdf = "onType"
		}
	},

	-- Dockerfile
	dockerls = {},
}

local ensure_installed = {}

-- For each LSP config...
for name, config in pairs(lsp_configs) do
	-- Modify to print message on attach.
	config.on_attach = function()
		print('lsp server "' .. name .. '" attached')
	end

	-- Ensure LSP gets installed
	table.insert(ensure_installed, name)
end

return {
	'neovim/nvim-lspconfig',
	dependencies = {
		{
			'williamboman/mason-lspconfig.nvim',
			dependencies = {
				{
					'williamboman/mason.nvim',
					opts = {}
				}
			},
			opts = ensure_installed
		}
	},
	config = function()
		local lspc = require("lspconfig")

		for name, config in pairs(lsp_configs) do
			lspc[name].setup(config)
		end
	end
}
