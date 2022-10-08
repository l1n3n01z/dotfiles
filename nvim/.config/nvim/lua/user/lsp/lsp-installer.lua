local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "bashls",
  "jsonls",
  "yamlls",
  -- "omnisharp",
  "csharp_ls"
}

lsp_installer.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server == "sumneko_lua" then
    require("lua-dev").setup({})
    -- local sumneko_opts = require "user.lsp.settings.sumneko_lua"
    -- opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server == "pyright" then
    local pyright_opts = require "user.lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server == "csharp_ls" then
    local csharp_ls_opts = require "user.lsp.settings.csharp_ls"
    opts = vim.tbl_deep_extend("force", csharp_ls_opts, opts)
  end

  if server == "omnisharp" then
    local omnisharp_opts = require "user.lsp.settings.omnisharp"
    opts = vim.tbl_deep_extend("force", omnisharp_opts, opts)
  end

  lspconfig[server].setup(opts)
end
