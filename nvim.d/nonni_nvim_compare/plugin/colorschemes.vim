" stolen from 
" https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/plugin/colors.vim
" and edited to be more boring
"
fun! RestoreColorScheme()
    " let g:gruvbox_contrast_dark = 'hard'
    " if exists('+termguicolors')
    "     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    "     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    " endif
    let g:gruvbox_invert_selection='0'

    set background=dark

    colorscheme gruvbox

    highlight ColorColumn ctermbg=0 guibg=grey
    highlight LineNr guifg=#5eacd3
    highlight netrwDir guifg=#5eacd3
    highlight qfFileName guifg=#aed75f
    hi TelescopeBorder guifg=#5eacd
endfun
call RestoreColorScheme()

nnoremap <leader>cmp :call RestoreColorScheme()<CR>
