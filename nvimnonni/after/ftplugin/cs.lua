vim.bo.commentstring = "//%s"
vim.bo.makeprg = "just"
-- vim.bo.errorformat = "%f(%l\\,%c): %t%*\\a\\sCS%n:%m [%o]"
vim.opt.errorformat = { "%f(%l\\,%c): %t%.%#", "%f(%l%.%#" }
