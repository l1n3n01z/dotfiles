local M = {}

M.telescope_my_grep = function ()
  -- by default, telescope will use word under cursor and cwd
  -- this grep tries to do something more advanced
  local opts = {}
  local search_dirs = vim.lsp.buf.list_workspace_folders()
  vim.pretty_print(search_dirs)
  if next(search_dirs) ~= nil then
    opts.search_dirs = search_dirs
  end
  -- TODO use treesitter to check if we are within string. If so, use different rules
  -- currently telescope uses vim.fn.expand("<cword>") but strings can contain often contain hyphens and should allow that
  vim.pretty_print(vim.api.nvim_get_mode())
  if vim.api.nvim_get_mode().mode == "v" then
    local buffer, start_row, start_col = unpack(vim.fn.getpos("v"))
    local _, end_row, end_col = unpack(vim.fn.getcurpos())
    -- only allow simple visual selection. one line and do not allow empty string
    if (start_row == end_row) then
      -- note api is zero based but vim getpos is 1 based, so offset by one except end_col (want exclusive)
      local lines = vim.api.nvim_buf_get_text(buffer, start_row-1, start_col - 1, end_row-1, end_col, {})
      vim.pretty_print(lines)
        local text = lines[1]
      vim.pretty_print(text)
      opts.search = text
    end
  end
  require('telescope.builtin').grep_string(opts)
end

vim.api.nvim_create_user_command("SnippetSource", "source ~/.config/nvim/after/plugin/luasnip.lua", {})

return M
