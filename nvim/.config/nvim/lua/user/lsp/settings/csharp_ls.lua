local util = require 'lspconfig.util'
return {
  root_dir = function(fname)
    return util.root_pattern("*.sln", ".git", "Dockerfile")(fname) or util.root_pattern("*.csproj")(fname)
  end,
  handlers = {
    ["textDocument/definition"] = require('csharpls_extended').handler,
  },
}
