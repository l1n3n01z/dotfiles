return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000 ,
		-- config = true,
		config = function()
			vim.cmd.colorscheme "gruvbox"
		end,
	},
	{
		"ricardoraposo/gruvbox-minor.nvim",
		lazy = false,
		priority = 1000,
		-- opts = {},
		-- config = true,
	},
}
