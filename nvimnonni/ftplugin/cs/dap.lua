print("csharp")
local function prequire(m)
    local ok, err = pcall(require, m)
    if not ok then return nil, err end
    return err
end

dap.adapters.coreclr = {
    type = 'executable',
    command = '/path/to/dotnet/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}
