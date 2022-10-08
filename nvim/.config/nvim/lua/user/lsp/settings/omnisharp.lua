local util = require 'lspconfig.util'
return {
  root_dir = function(fname)
    return util.root_pattern("*.sln", ".git")(fname) or util.root_pattern("*.csproj")(fname)
  end,
}
