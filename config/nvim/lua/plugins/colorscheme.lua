return {
	'rose-pine/neovim',
	name = "rose-pine",
	opts = function()
		vim.opt.termguicolors = true
		vim.cmd.colorscheme("rose-pine")
	end
}
