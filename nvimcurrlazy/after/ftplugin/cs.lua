vim.bo.commentstring = "//%s"
vim.bo.makeprg = "just"
-- vim.bo.errorformat = "%f(%l\\,%c): %t%*\\a\\sCS%n:%m [%o]"
vim.opt.errorformat = { "%f(%l\\,%c): %t%.%#", "%f(%l%.%#" }
-- vim.bo.errorformat = "%f%.%#"

-- :setl errorformat=%Z%f:%l:\ %m,%A%p^,%-G%*[^sl]%.%#
-- :setl makeprg=javac\ %:S\ 2>&1\ \\\|\ vim-javac-filter
-- /home/nonni/work/shipment_delivery/src/api/frontendapi/Origo.FrontendApi.Web/Services/DeliveryValidationService.cs(42,9): error CS1585: Member modifier 'public' must precede the member type and name [/home/nonni/work/shipment_delivery/src/api/frontendapi/Origo.FrontendApi.Web/Origo.FrontendApi.Web.csproj]
