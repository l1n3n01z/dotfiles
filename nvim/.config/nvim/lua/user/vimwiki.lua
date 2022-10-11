-- WIP not sure if using lua settings work at all

if not nil then
  return
end

local wiki_1 = {
  path = "~/vimwiki/",
  syntax = "markdown",
  ext = ".md",
}

vim.opt.vimwiki_list = {wiki_1}
vim.opt.vimwiki_ext2syntax = { 
  ['.md'] = "markdown", 
  ['.markdown'] = "markdown",
  ['.mdown'] = "markdown"
}

vim.g.vimwiki_global_ext = 0

-- Makes vimwiki markdown links as [text](text.md) instead of [text](text)
vim.g.vimwiki_markdown_link_ext = 1

vim.g.taskwiki_markup_syntax = "markdown"
vim.g.markdown_folding = 1

-- function! VimwikiLinkHandler(link)
--     let link = a:link
--     if link =~# '^https\?:'
--         try
--             let browser = 'firefox'
--             " silly thing still not working
--             " execute 'silent !'.browser. ' ' . shellescape(escape(a:link, '%'))
--             " execute '!echo ' . shellescape(fnameescape(a:link))
--             execute 'silent !'.browser. ' ' . shellescape(fnameescape(a:link))
--             return 1
--         catch
--             echo "Unable to open the link in firefox"
--         endtry
--         return 0
--     else
--         return 0
--     endif
-- endfunction

