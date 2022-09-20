local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
  -- startup is much faster if we don't specify all. Unsure why there is an impact
  -- goes from 300 ms for treesitter start to a couple of ms
  -- possibly specifying explicitly a huge list is faster than all?
	ensure_installed = { "c_sharp", "lua" },  -- one of "all" or a list of languages
	-- ensure_installed = "all",  -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
})
