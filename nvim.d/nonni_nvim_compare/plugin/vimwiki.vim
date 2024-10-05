let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'

let g:vimwiki_list = [wiki_1]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_global_ext = 0

" Makes vimwiki markdown links as [text](text.md) instead of [text](text)
let g:vimwiki_markdown_link_ext = 1

let g:taskwiki_markup_syntax = 'markdown'
let g:markdown_folding = 1

function! VimwikiLinkHandler(link)
    let link = a:link
    if link =~# '^https\?:'
        try
            let browser = 'firefox'
            " silly thing still not working
            " execute 'silent !'.browser. ' ' . shellescape(escape(a:link, '%'))
            " execute '!echo ' . shellescape(fnameescape(a:link))
            execute 'silent !'.browser. ' ' . shellescape(fnameescape(a:link))
            return 1
        catch
            echo "Unable to open the link in firefox"
        endtry
        return 0
    else
        return 0
    endif
endfunction

