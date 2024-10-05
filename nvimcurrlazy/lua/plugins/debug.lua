return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        function(config)
          -- all sources with no handler get passed here
          --
          -- Keep original functionality
          require("mason-nvim-dap").default_setup(config)
        end,
        coreclr = function(config)
          -- vim.print(config)
          -- local mason_nvim_dap = require("mason-nvim-dap.mappings.configurations")
          -- local get_dll = require("mason-nvim-dap.mappings.configurations").get_dll
          --
          -- the below works pretty well for net stuff, but load_json is mostly better
          -- TODO, maybe check if we have a launch json file and if not do this instead
          -- Note, the only difference between the default and this is the ASPNETCORE_ENVIRONMENT setting

          -- local sillyThing = config.configurations[1].program
          -- config.configurations = {
          --   {
          --     cwd = "${fileDirname}",
          --     name = "NetCoreDbg: Launch",
          --     program = sillyThing,
          --     env = {
          --       ASPNETCORE_ENVIRONMENT = "Development",
          --     },
          --     request = "launch",
          --     type = "coreclr",
          --   },
          -- config.configurations = {}
          require("mason-nvim-dap").default_setup(config) -- don't forget this!
        end,
      },
    },
  },
}
