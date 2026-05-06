-- LSP configuration
local lspconfig = require("lspconfig")

-- Diagnostic configuration
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- LSP keymaps (applied when LSP attaches)
local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
  map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")

  -- Inlay hints (if supported)
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, "Toggle Inlay Hints")
  end
end

-- Common capabilities (with blink.cmp support)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Default config for all servers
local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Lua (for Neovim config)
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

lspconfig.lua_ls.setup(vim.tbl_extend("force", default_config, {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
}))

-- Nix
lspconfig.nil_ls.setup(vim.tbl_extend("force", default_config, {
  settings = {
    ["nil"] = {
      formatting = { command = { "nixfmt" } },
    },
  },
}))

-- TypeScript
lspconfig.ts_ls.setup(default_config)

-- C#
lspconfig.csharp_ls.setup(default_config)

-- F#
lspconfig.fsautocomplete.setup(default_config)

-- Zig
lspconfig.zls.setup(default_config)

-- Conform (formatting)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    fish = { "fish_indent" },
    cs = { "csharpier" },
  },
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
  },
  format_on_save = function()
    if vim.g.autoformat == false then
      return nil
    end
    return { timeout_ms = 3000, lsp_format = "fallback" }
  end,
})

-- Enable autoformat by default
vim.g.autoformat = true

-- Lint
require("lint").linters_by_ft = {
  fish = { "fish" },
  sh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
