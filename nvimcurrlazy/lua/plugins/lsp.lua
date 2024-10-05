return {
  { "Decodetalkers/csharpls-extended-lsp.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        csharp_ls = {
          handlers = {
            ["textDocument/definition"] = function(...)
              return require("csharpls_extended").handler(...)
            end,
          },
          keys = {
            {
              "gd",
              function()
                require("csharpls_extended").lsp_definitions()
              end,
              desc = "Goto Definition",
            },
          },
        },
      },
    },
  },
}
