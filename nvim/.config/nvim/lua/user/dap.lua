local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

local dap_install_status_ok, mason_dap_install = pcall(require, "mason-nvim-dap")
if not dap_install_status_ok then
  return
end

mason_dap_install.setup({
    -- ensure_installed = {'stylua', 'jq'}
})

mason_dap_install.setup_handlers {
  function(source_name)
    -- all sources with no handler get passed here
  end,
  -- add other configs here
  python = function()
    dap.adapters.python = {
      type = "executable",
      command = "/usr/bin/python3",
      args = {
        "-m",
        "debugpy.adapter",
      },
    }

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}", -- This configuration will launch the current file if used.
      },
    }
  end,
  -- dotnet core, csharp
  -- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook#making-debugging-net-easier
  cs = function()
    dap.adapters.coreclr = {
      type = 'executable',
      command = 'netcoredbg',
      args = {'--interpreter=vscode', '--engineLogging=/home/nonni/ble.log', '--hot-reload'},
    }
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        -- request = "attach",
        -- program = function()
        --   return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        -- end,
        -- program = "dotnet run --project /home/nonni/work/shipment_delivery/src/api/apexinfo/Origo.ApexService/Origo.ApexService.csproj"
        program = "/home/nonni/work/shipment_delivery/src/api/workflowservice/Origo.OrderDelivery.Rest/bin/Debug/netcoreapp3.1/Origo.OrderDelivery.Rest.dll",
        cwd = "/home/nonni/work/shipment_delivery/src/api/workflowservice/Origo.OrderDelivery.Rest/bin/Debug/netcoreapp3.1/",
        args = {"local"}
      }
    }
  end,
}


dapui.setup {
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.25, -- Can be float or integer > 1
        },
        { id = "breakpoints", size = 0.25 },
        'stacks',
        'watches',
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 10,
      position = 'bottom',
    },
  },
}

-- dapui.setup {
--   sidebar = {
--     elements = {
--       {
--         id = "scopes",
--         size = 0.25, -- Can be float or integer > 1
--       },
--       { id = "breakpoints", size = 0.25 },
--     },
--     size = 40,
--     position = "right", -- Can be "left", "right", "top", "bottom"
--   },
--   tray = {
--     elements = {},
--   },
-- }

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
