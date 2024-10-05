local new_note = function()
  vim.ui.input({ prompt = "Title: " }, function(input)
    if not input then
      return
    end
    local zk = require("zk")
    zk.new({ title = input })
    -- local _, err = pcall(function()
    --   zk.new({ title = input })
    -- end)
    -- if err then
    --   vim.notify(err)
    -- end
  end)
end

return {
  name = "zk",
  "zk-org/zk-nvim",
  opts = {
    picker = "telescope",
    lsp = {
      -- `config` is passed to `vim.lsp.start_client(config)`
      config = {
        cmd = { "zk", "lsp" },
        name = "zk",
        -- on_attach = ...
        -- etc, see `:h vim.lsp.start_client()`
      },

      -- automatically attach buffers in a zk notebook that match the given filetypes
      auto_attach = {
        enabled = true,
        filetypes = { "markdown" },
      },
    },
  },
  enabled = false,
  keys = {
    { "<leader>jn", new_note, desc = "Wiki index" },
  },
}
-- zettelkasten zk-nvim
-- Create a new note after asking for its title.
-- map("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>")
--
-- -- Open notes.
-- map("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>")
-- -- Open notes associated with the selected tags.
-- map("n", "<leader>zt", "<Cmd>ZkTags<CR>")
--
-- -- Search for the notes matching a given query.
-- map("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>")
-- -- Search for the notes matching the current visual selection.
-- map("v", "<leader>zf", ":'<,'>ZkMatch<CR>")
