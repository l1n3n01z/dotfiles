if vim.g.dap_cs then
	return
end
vim.g.dap_cs = 1

local function prequire(m)
	local ok, err = pcall(require, m)
	if not ok then
		return nil, err
	end
	return err
end

local dap = prequire("dap")
local dapui = prequire("dapui")
if dap == nil then
	return
end
if dapui == nil then
	print("missing dapui, cancelling dap setup")
	return
end

local nio = prequire("nio")
if nio == nil then
	print("missing nio, cancelling dap setup")
	return
end

local dapvirt = prequire("nvim-dap-virtual-text")

if dapvirt ~= nil then
	dapvirt.setup({})
end

dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

dap.adapters.coreclr = {
	type = "executable",
	command = "netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
}
