return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		require('mini.completion').setup()
	end
}
