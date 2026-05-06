-- Options (LazyVim defaults)
local opt = vim.opt

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General
opt.autowrite = true
opt.confirm = true
opt.mouse = "a"
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmode = false -- lualine shows mode
opt.laststatus = 3 -- global statusline
opt.pumblend = 10
opt.pumheight = 10
opt.winminwidth = 5

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Scrolling
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Folding
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Undo/backup
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200

-- Display
opt.wrap = false
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "  ", trail = ".", nbsp = "." }
opt.conceallevel = 2
opt.virtualedit = "block"

-- Timeout
opt.timeoutlen = 300

-- Wildmenu
opt.wildmode = "longest:full,full"

-- Spelling
opt.spelllang = { "en" }

-- Disable some builtin providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Fix markdown indentation
vim.g.markdown_recommended_style = 0
