-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local pid = vim.fn.getpid()

local lspconfig = require('lspconfig')

-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
local omnisharp_bin = vim.fn.expand("~/.local/share/nvim/lsp_servers/omnisharp/omnisharp/run")

lspconfig.omnisharp.setup {
    capabilities = capabilities,
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
}

local zls_bin = "/home/nonni/zls/zls";

lspconfig.zls.setup{
    cmd = {zls_bin},
}
