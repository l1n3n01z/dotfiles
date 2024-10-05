return { {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
        parser_config.fsharp = {
            install_info = {
                url = "https://github.com/ionide/tree-sitter-fsharp",
                branch = "main",
                files = { "src/scanner.c", "src/parser.c" },
            },
            filetype = "fsharp",
        }
    end

},
    { 'echasnovski/mini.indentscope', version = '*', config = true },
}
