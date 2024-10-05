-- consider using the saecki fork of treesitter-context
-- https://github.com/Saecki/nvim-treesitter-context/tree/categories
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- init = function(_)
    --   local configs = require("nvim-treesitter.configs")
    --   local hackIndent = {
    --     module_path = "hacks.indent",
    --     enable = true,
    --     is_supported = function(_)
    --       return true
    --     end,
    --   }
    --   configs.define_modules({ hack = hackIndent })
    --   local query = require("vim.treesitter.query")
    --   query.add_directive("print!", function(_, _, _, directive, _)
    --     local toprint = directive[2]
    --     -- local obj = directive[3]
    --     print(toprint)
    --   end, {})
    -- end,
    opts = {
      ensure_installed = {
        "c_sharp",
        "fish",
      },
      -- indent = {
      --   enabled = false,
      -- },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- dir = "~/personal/nvim-plugins/nvim-treesitter-context",
    -- dev = true,
    opts = {
      multiline_threshold = 1,
    },
  },
}
