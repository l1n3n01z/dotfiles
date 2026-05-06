-- Keymaps (LazyVim style)
local map = vim.keymap.set

-- Better movement on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Lines Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Lines Up" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<cr>", { desc = "Delete Other Buffers" })

-- Clear search highlight
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Search result centering
map("n", "n", "nzzzv", { desc = "Next Search Result" })
map("n", "N", "Nzzzv", { desc = "Prev Search Result" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
map("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Next Warning" })
map("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Prev Warning" })

-- Quickfix
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Formatting
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

-- Toggle options
map("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
end, { desc = "Toggle Auto Format" })

map("n", "<leader>us", function() vim.opt.spell = not vim.opt.spell:get() end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle Wrap" })
map("n", "<leader>ul", function() vim.opt.number = not vim.opt.number:get() end, { desc = "Toggle Line Numbers" })
map("n", "<leader>uL", function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end, { desc = "Toggle Relative Numbers" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle Diagnostics" })

-- Telescope
map("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>,", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
map("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
map("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Git Files" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git Commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })
map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer Lines" })
map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
map("n", "<leader>sr", "<cmd>Telescope resume<cr>", { desc = "Resume" })
map("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Word under Cursor" })
map("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
map("n", "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-- Neo-tree
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer" })
map("n", "<leader>fe", "<cmd>Neotree toggle<cr>", { desc = "Explorer" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP References (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

-- Todo-comments
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev Todo" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
map("n", "<leader>st", "<cmd>Telescope todo-comments<cr>", { desc = "Todo" })

-- Flash
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

-- Grug-far (search and replace)
map("n", "<leader>sr", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search and Replace" })

-- Gitsigns (set in plugin config on attach)

-- Persistence (sessions)
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
map("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Session" })

-- Lazygit
map("n", "<leader>gg", function()
  local snacks = require("snacks")
  snacks.lazygit()
end, { desc = "Lazygit" })

-- Terminal (via snacks)
map("n", "<leader>ft", function() require("snacks").terminal() end, { desc = "Terminal" })
map("n", "<C-/>", function() require("snacks").terminal() end, { desc = "Terminal" })

-- Notifications
map("n", "<leader>un", function() require("snacks").notifier.hide() end, { desc = "Dismiss Notifications" })

-- DAP (Debug)
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Breakpoint Condition" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
map("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step Over" })
map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map("n", "<leader>ds", function() require("dap").session() end, { desc = "Session" })
map("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP UI" })
