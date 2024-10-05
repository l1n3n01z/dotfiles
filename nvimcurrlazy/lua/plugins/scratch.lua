-- would possibly be nice if unsaved scratches were still "saved" between sessions
return {
  "LintaoAmons/scratch.nvim",
  opts = {
    scratch_file_dir = "~/.scratch",
    filetypes = { "log" },
  },
  keys = {
    { "<leader>os", "<cmd>Scratch<cr>", desc = "New scratch" },
    { "<leader>on", "<cmd>ScratchWithName<cr>", desc = "New Scratch with name" },
    -- use telescope?
    { "<leader>of", "<cmd>ScratchOpenFzf<cr>", desc = "Find Scratch" },
  },
}

-- return {
--   "LintaoAmons/scratch.nvim",
--   config = function()
--     require("scratch").setup({
--       scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim", -- where your scratch files will be put
--       filetypes = { "lua", "js", "sh", "ts" }, -- you can simply put filetype here
--       filetype_details = { -- or, you can have more control here
--         json = {}, -- empty table is fine
--         ["project-name.md"] = {
--           subdir = "project-name" -- group scratch files under specific sub folder
--         },
--         ["yaml"] = {},
--         go = {
--           requireDir = true, -- true if each scratch file requires a new directory
--           filename = "main", -- the filename of the scratch file in the new directory
--           content = { "package main", "", "func main() {", "  ", "}" },
--           cursor = {
--             location = { 4, 2 },
--             insert_mode = true,
--           },
--         },
--       },
--       window_cmd = "rightbelow vsplit", -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
--       use_telescope = true,
--       localKeys = {
--         {
--           filenameContains = { "sh" },
--           LocalKeys = {
--             {
--               cmd = "<CMD>RunShellCurrentLine<CR>",
--               key = "<C-r>",
--               modes = { "n", "i", "v" },
--             },
--           },
--         },
--       },
--     })
--   end,
--   event = "VeryLazy",
-- }
