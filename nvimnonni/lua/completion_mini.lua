-- require "custom.snippets"

-- note that mini completion sets defaults, unless we set set_vim_settings to false
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.shortmess:append("cC")

require("mini.completion").setup({ set_vim_settings = false })

-- require("mini.completion").setup({
-- 	set_vim_settings = false,
-- 	lsp_completion = {
-- 		source_func = "omnifunc",
-- 		auto_setup = false,
-- 		process_items = function(items, base)
-- 			-- Don't show 'Text' and 'Snippet' suggestions
-- 			items = vim.tbl_filter(function(x)
-- 				return x.kind ~= 1 and x.kind ~= 15
-- 			end, items)
-- 			return MiniCompletion.default_process_items(items, base)
-- 		end,
-- 	},
-- 	window = {
-- 		info = { border = "double" },
-- 		signature = { border = "double" },
-- 	},
-- })
if vim.fn.has("nvim-0.11") == 1 then
	vim.opt.completeopt:append("fuzzy") -- Use fuzzy matching for built-in completion
end

-- local cmp = require("cmp")

-- cmp.setup({
-- 	sources = {
-- 		{ name = "nvim_lsp" },
-- 		{ name = "path" },
-- 		{ name = "buffer" },
-- 	},
-- 	mapping = {
-- 		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
-- 		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
-- 		["<C-y>"] = cmp.mapping(
-- 			cmp.mapping.confirm({
-- 				behavior = cmp.ConfirmBehavior.Insert,
-- 				select = true,
-- 			}),
-- 			{ "i", "c" }
-- 		),
-- 	},
--
-- 	-- Enable luasnip to handle snippet expansion for nvim-cmp
-- 	-- snippet = {
-- 	--   expand = function(args)
-- 	--     vim.snippet.expand(args.body)
-- 	--   end,
-- 	-- },
-- })
-- -- Setup up vim-dadbod
-- cmp.setup.filetype({ "sql" }, {
-- 	sources = {
-- 		{ name = "vim-dadbod-completion" },
-- 		{ name = "buffer" },
-- 	},
-- })
