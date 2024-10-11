vim.g.mapleader = " "
vim.cmd.colorscheme("gruvbox-material")

require("lsp")
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
