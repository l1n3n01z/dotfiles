local opt = vim.opt

----- Interesting Options -----

-- You have to turn this one on :)
opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----
---- default tab settings ----
opt.expandtab = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.showtabline = 2
opt.softtabstop = 4

opt.showmode = false

opt.list = true
opt.listchars = "tab:·┈,trail:~,multispace:|···,extends:▶,precedes:◀,nbsp:‿"

opt.number = true
-- opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

-- opt.signcolumn = "yes"

-- no idea what this does
opt.shada = { "'10", "<0", "s10", "h" }

opt.clipboard = "unnamedplus"

-- Don't have `o` add a comment
opt.formatoptions:remove "o"
