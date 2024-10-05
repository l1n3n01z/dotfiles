-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { "lsp", "Dockerfile", ".sln", "package.json", { ".git", "lua" }, "cwd" }

-- a hack. See ./../hacks/indent.lua
-- this is overwritten by nvim treesitter anyway
-- vim.bo.indentexpr = "luaeval(printf('require\"hacks.indent\".get_indent(%d)', v:lnum))"

-- it seems that we might be using xsel now?
-- also, lazyvim will start to optimize the startup cost away
-- https://github.com/LazyVim/LazyVim/discussions/4112
-- https://github.com/LazyVim/LazyVim/blob/12818a6cb499456f4903c5d8e68af43753ebc869/lua/lazyvim/config/init.lua#L164
-- only issue is that we get \r,
-- we explicitly set the clipboard to reduce startup time (quite a lot due to system calls)
-- win32yank must be installed and be in our path (could check, but meh)
-- if vim.fn.has("wsl") then -- note, is this has wsl fast enough?
--   local wsl = require("user.wsl")
--   vim.g.clipboard = {
--     name = "clipfunctions",
--     copy = {
--       ["+"] = wsl.copy,
--       ["*"] = wsl.copy,
--     },
--     paste = {
--       ["+"] = wsl.paste,
--       ["*"] = wsl.paste,
--     },
--     -- we use our own cache, because the nvim cache doesn't function with the debounce currently
--     cache_enabled = 0,
--   }
-- end

-- consider stripping \r away?

-- vim.g.clipboard = {
--   name = "xsel",
--   copy = {
--     ["+"] = "xsel --nodetach -i -b",
--     ["*"] = "xsel --nodetach -i -p",
--   },
--   paste = {
--     ["+"] = "xsel -o -b | sed 's/\n\r/\n/'",
--     ["*"] = "xsel -o -p | sed 's/\n\r/\n/'",
--   },
--   cache_enabled = true,
-- }

--   ['+'] = ['xsel', '--nodetach', '-i', '-b']
--     let s:paste['+'] = ['xsel', '-o', '-b']
--     let s:copy['*'] = ['xsel', '--nodetach', '-i', '-p']
--     let s:paste['*'] = ['xsel', '-o', '-p']
--     return 'xsel'
-- }
