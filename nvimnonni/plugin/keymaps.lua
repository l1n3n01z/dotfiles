-- Open project directory in floating window
-- Consider readonly

vim.keymap.set("n", "-", "<CMD>Neotree float reveal<CR>", { desc = "View file in Neotree" })

-- Open project directory in floating window
-- Use oil for editing directory
-- vim.keymap.set("n", "<space>-", require("oil").toggle_float)
