return {
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	config = function()
		require('nvim-treesitter.install').compilers = {
			'zig'
		}

		require('nvim-treesitter.configs').setup({
			ensure_installed = {
				'c',
				'lua',
				'vim',
				'vimdoc',
				'go',
				'bash',
				'yaml',
				'json',
				'typst'
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true
			},
			indent = {
				enable = true
			},
		})
	end
}
