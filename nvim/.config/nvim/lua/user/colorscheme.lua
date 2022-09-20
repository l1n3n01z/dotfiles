local colorscheme = "darkplus"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if (status_ok) then return end
vim.notify("colorscheme " .. colorscheme .. " is not available. Switching to habamax")
local status_ok, _ = pcall(vim.cmd, "colorscheme habamax")
