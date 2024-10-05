return {
  { "ionide/Ionide-vim", event = "LazyFile", ft = "fsharp" },
  { "PhilT/vim-fsharp", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nushell/tree-sitter-nu" },
    },
    opts = function(_, opts)
      ---@diagnostic disable-next-line: inject-field
      require("nvim-treesitter.parsers").get_parser_configs().fsharp = {
        install_info = {
          url = "https://github.com/ionide/tree-sitter-fsharp",
          branch = "main",
          files = { "src/scanner.c", "src/parser.c" },
        },
        requires_generate_from_grammar = false,
        filetype = "fsharp",
      }
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "fsharp" })
      end
    end,
  },
}
