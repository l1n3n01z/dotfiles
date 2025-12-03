vim.g.mapleader = " "

-- todo
-- make vimrc
-- use globals
-- neotree
--   fix keybindings
-- LSP fix keybindings?
--
-- LazyVim uses q to close all sorts of (ephemeral) windows. That fits with how I think about windows

-- we are using packadd
-- because we are using nix to dump all the plugins into our optional plugin folder
-- so for now, packadd everything.
-- Later we can do it more lazily
local currentPlugins = {
	"vim-fugitive",
	--color
	"gruvbox-material.nvim",
	--completion
	-- "nvim-cmp",
	-- "cmp-nvim-lsp",
	-- "cmp-buffer",
	-- "cmp-path",
	-- own-care-nvim
	-- lsp and formatting
	"blink.cmp",
	"nvim-lspconfig",
	"csharpls-extended-lsp.nvim",
	"vim-dispatch",
	"conform.nvim",
	-- ui
	"neo-tree.nvim",
	-- "which-key.nvim", 100% cpu on macro recording
	"indent-blankline.nvim",
	-- "all the mini plugins",
	"mini.nvim",
	--
	"lualine.nvim",
	-- dap
	"nvim-dap",
	"nvim-dap-ui",
	"nvim-nio", -- dependency for ui
	"nvim-dap-virtual-text",
	--sql
	"vim-dadbod",
	"vim-dadbod-ui",
	"vim-dadbod-completion",
	-- maybe use dbee instead? Mainly because it's annoying to deal with large columns
	-- note, dbee completion is not available in nixpkgs
}

for _, pluginName in ipairs(currentPlugins) do
	if not pcall(vim.cmd.packadd, pluginName) then
		print(pluginName .. " not found")
	end
end

vim.cmd.colorscheme("gruvbox-material")

require("completion_mini")
require("lsp")

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		csharp = { "csharpier" },
		fsharp = { "fantomas" },
		nix = { "nixfmt" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- mini. WIP
require("mini.starter").setup()
require("mini.bracketed").setup()
require("mini.clue").setup()
-- require("mini.pick").setup()
require("mini.surround").setup()
require("mini.comment").setup()
require("mini.sessions").setup({ autoread = true })
require("mini.keymap").setup()

require("picker")
