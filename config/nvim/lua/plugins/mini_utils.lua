return {
	"echasnovski/mini.nvim",
	config = function()
	    require('mini.indentscope').setup() -- Pretty indent lines
	    require('mini.align').setup() -- text column alignment
	end
}