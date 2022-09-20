-- NO LONGER NEEDED. neovim supports has('wsl')
--
--local function check_wsl () 
--  if not (vim.fn.has('unix')) then return false end
--  return os.getenv("WSL_INTEROP") ~= nil
--end
--asdka;l;
-- explicit setting the clipboard reduces startup time by 500 ms. 
-- Clip.exe seems to have the least latency
-- If we want better performance we are going to have to write a server queue for the clipboard
if (vim.fn.has('wsl')) then
  vim.g.clipboard = {
    name = "clipfunctions",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe"
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf"
    },
    cache_enabled = 0
  }
  -- let's not swamp the clipboard with single characters
  vim.keymap.set("n", "x", "\"0x", { silent = true })
  vim.keymap.set("n", "X", "\"0X", { silent = true })
end


require "user.options"
require "user.keymaps"
--require "user.plugins"
--require "user.autocommands"
--require "user.colorscheme"
--require "user.cmp"
--require "user.telescope"
--require "user.treesitter"
--require "user.comment"
--require "user.nvim-tree"
--require "user.lualine"
--require "user.impatient"
--require "user.lsp"
--require "user.dap"
