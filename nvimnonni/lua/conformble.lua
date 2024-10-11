			require("conform").setup({
				formatters_by_ft = {
					-- lua = { "stylua" },
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
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	callback = function(args)
			-- 		require("conform").format({
			-- 			bufnr = args.buf,
			-- 			lsp_fallback = true,
			-- 			quiet = true,
			-- 		})
			-- 	end,
			-- })
