-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map({ "", "i" }, "<Up>", "<nop>")
map({ "", "i" }, "<Down>", "<nop>")
map({ "", "i" }, "<Left>", "<nop>")
map({ "", "i" }, "<Right>", "<nop>")

-- let's not swamp the clipboard with single characters
-- vim.keymap.set("n", "x", "\"0x", { silent = true })
-- vim.keymap.set("n", "X", "\"0X", { silent = true })
local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    j = {
      name = "+journal",
    },
  },
})
