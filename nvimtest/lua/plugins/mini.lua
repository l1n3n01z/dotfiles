-- Mini.nvim modules configuration
-- mini.nvim is a collection of small, independent modules

-- mini.pairs - Auto-pairs
require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
  mappings = {
    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
  },
})

-- mini.surround - Surround actions
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

-- mini.ai - Extended text objects
local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    d = { "%f[%d]%d+" }, -- digits
    g = function(ai_type) -- entire buffer
      local start_line, end_line = 1, vim.fn.line("$")
      if ai_type == "i" then
        local first_nonblank = vim.fn.nextnonblank(start_line)
        local last_nonblank = vim.fn.prevnonblank(end_line)
        if first_nonblank == 0 or last_nonblank == 0 then
          return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
      end
      local to_col = math.max(vim.fn.getline(end_line):len(), 1)
      return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
    end,
    u = ai.gen_spec.function_call(), -- function call
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- function call without dot
  },
})

-- mini.indentscope - Animated indent guides for current scope
require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
  draw = {
    delay = 100,
    animation = require("mini.indentscope").gen_animation.none(),
  },
})

-- Disable mini.indentscope for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
    "lazy", "mason", "notify", "toggleterm", "lazyterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- mini.bufremove - Better buffer deletion
require("mini.bufremove").setup({})
vim.keymap.set("n", "<leader>bd", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", function()
  require("mini.bufremove").delete(0, true)
end, { desc = "Delete Buffer (Force)" })

-- mini.icons - Icon provider (used by other plugins)
require("mini.icons").setup({})

-- mini.hipatterns - Highlight patterns (like TODO, colors)
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
