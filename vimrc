" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

NeoBundle 'junkblocker/unite-codesearch'
"NeoBundle 'tpope/vim-vinegar'
NeoBundle 'jeetsukumaran/vim-filebeagle'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-surround' 
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'rking/ag.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'bling/vim-airline'
" NeoBundle 'Valloric/YouCompleteMe'
" NeoBundle 'rdnetto/YCM-Generator'
" doesn't seem to work any more, since qch :(
NeoBundle 'xaizek/vim-qthelp'
NeoBundle 'nelstrom/vim-visual-star-search'
NeoBundle 'vim-scripts/a.vim'

" rust!
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'phildawes/racer'
NeoBundle 'vim-scripts/argtextobj.vim'
" NeoBundle 'octol/vim-cpp-enhanced-highlight'
NeoBundle 'majutsushi/tagbar'

" text objects
Plugin 'bkad/CamelCaseMotion'
Plugin 'inkarkat/argtextobj.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'terryma/vim-expand-region'
Plugin 'bling/vim-airline'

" NeoBundleLazy 'jeaye/color_coded', {
"   \ 'build': {
"     \   'unix': 'cmake . && make && make install',
"   \ },
"   \ 'autoload': { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] },
"   \ 'build_commands' : ['cmake', 'make']
"   \}
" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

set number "Line numbers are good
set backspace=indent,eol,start "Allow backspace in insert mode
set history=1000 "Store lots of :cmdline history
set showcmd "Show incomplete cmds down the bottom
set showmode "Show current mode down the bottom
set gcr=a:blinkon0 "Disable cursor blink
set visualbell "No sounds
set autoread "Reload files changed outside vim
" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden
"turn on syntax highlighting
syntax on
" ================ Indentation ======================
set autoindent
set smartindent
set smarttab
" set shiftwidth=2
set softtabstop=4
set tabstop=4
set expandtab
" Display tabs and trailing spaces visually
" set list listchars=tab:\ \ ,trail:·
set nowrap "Don't wrap lines
set linebreak "Wrap lines at convenient points
" ================ Folds ============================
set foldmethod=indent "fold based on indent
set foldnestmax=3 "deepest fold is 3 levels
set nofoldenable "dont fold by default
" ================ Completion =======================
set wildmode=list:longest
set wildmenu "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
"
" ================ Scrolling ========================
set scrolloff=8 "Start scrolling when we're 8 lines away from margins
" ================ Search ===========================
set incsearch " Find the next match as we type the search
set hlsearch " Highlight searches by default
set ignorecase " Ignore case when searching...
set smartcase " ...unless we type a capital

set cmdheight=2

" ================ Leader     ========================
let mapleader = "\<Space>"

" ============ OS and shell based settings ================
"
" leave insert mode quickly
if ! has('gui_running')
        set ttimeoutlen=10
        augroup FastEscape
                autocmd!
                au InsertEnter * set timeoutlen=0
                au InsertLeave * set timeoutlen=1000
        augroup END
endif


" cursor stuff for mintty
" see https://code.google.com/p/mintty/wiki/Tips
let term_emulator = 'konsole'
if has("win32unix") && $CYGWIN =~ "mintty"
        let term_emulator = 'mintty'
endif


" ==== Cursor shapes in terminals
" http://vim.wikia.com/wiki/Configuring_the_cursor
" 1 or 0 -> blinking block
" 3 -> blinking underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
" 2 seems to be an underline
"open tmux escape
" http://vi.stackexchange.com/questions/3379/cursor-shape-under-vim-tmux
" http://blog.terriblelabs.com/blog/2013/02/09/stupid-vim-tricks-how-to-change-insert-mode-cursor-shape-with-tmux/
if exists('$TMUX')
  " let &t_SI = "\<Esc>Ptmux;\<Esc>\e]50;CursorShape=1\x7\<Esc>\\"
  " instead of doing tmux with explicit escapes, we wrap the term caps in
  " start-of-tmux-escape
  " and end-of-tmux-escape
  let &t_SI = "\<Esc>Ptmux;\<Esc>"
  let &t_SR = "\<Esc>Ptmux;\<Esc>"
  let &t_EI = "\<Esc>Ptmux;\<Esc>"
endif

" see https://code.google.com/p/mintty/wiki/Tips
if term_emulator ==? "mintty"
        let &t_SI.="\e[5 q"
        let &t_SR.="\e[1 q"
        let &t_EI.="\e[1 q"
        let &t_ti.="\e[1 q\e[?7727h"
        let &t_te.="\e[0 q\e[?7727l"
        noremap <Esc>O[ <Esc>
        noremap! <Esc>O[ <C-c>
endif
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if term_emulator ==? "konsole"
  " for some reason 1 is vertical bar in konsole
  let &t_SI .= "\e]50;CursorShape=1\x7"
  let &t_SR .= "\e]50;CursorShape=2\x7"
  let &t_EI .= "\e]50;CursorShape=0\x7"
endif

" end tmux escape code for terminal caps
if exists('$TMUX')
  let &t_SI .= "\<Esc>\\"
  let &t_SR .= "\<Esc>\\"
  let &t_EI .= "\<Esc>\\"
endif
" close tmux escape
" if exists('$TMUX')
"   let &t_SI .= "\<Esc>\\"
"   let &t_EI .= "\<Esc>\\"
"   let &t_SR .= "\<Esc>\\"
"   let &t_ti .= "\<Esc>\\"
"   let &t_te .= "\<Esc>\\"
"   " let &t_EI .= "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
" endif

" ==== Other terminal stuff
" this is for correct colors in konsole
if &term =~ '^xterm\\|rxvt'
  let &t_Co=16
endif

" ------------------------------------------------------------------
" Unite
" ------------------------------------------------------------------
" unite.vim {{{
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
                        \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
                        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''

let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>
" nnoremap <leader>u :<C-u>Unite -no-split -buffer-name=grep grep:.<cr>
" nnoremap <leader>u :UniteWithCursorWord -no-split -start-insert -no-quit -buffer-name=ag grep:.:<CR>
" nnoremap <leader>u :Unite -no-split -buffer-name=ag -default-action=smart-preview grep:.::\\W<C-R><C-W>\\W<CR>
nnoremap <leader>u :UniteWithProjectDir -no-split -auto-preview -select=0 -vertical -buffer-name=ag grep:.::\\b<C-R><C-W>\\b<CR>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <buffer> '     <Plug>(unite_quick_match_jump)
  nmap <buffer> '     <Plug>(unite_quick_match_jump)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
endfunction
" ashtneioqdwrfup;;;p;
let g:unite_quick_match_table = {
						\ 'a' : 7, 's' : 5, 'h' : 3, 't' : 1, 
						\ 'n' : 2, 'e' : 4, 'i' : 6, 'o' : 8,
						\ 'c' : 9, 'l' : 10, 
						\ 'r' : 11, 'f' : 12, 
						\ 'd' : 13, 'u' : 14, 
						\ 'g' : 15, 'k' : 16, 
						\}
" }}}

" ------------------------------------------------------------------
" Solarized Colorscheme Config
" ------------------------------------------------------------------
syntax enable
set background=dark
colorscheme solarized
" ------------------------------------------------------------------
" The following items are available options, but do not need to be
" included in your .vimrc as they are currently set to their defaults.

" let g:solarized_termtrans=0
" let g:solarized_degrade=0
" let g:solarized_bold=1
" let g:solarized_underline=1
" let g:solarized_italic=1
" let g:solarized_termcolors=16
" let g:solarized_contrast="normal"
" let g:solarized_visibility="normal"
" let g:solarized_diffmode="normal"
" let g:solarized_hitrail=0
" let g:solarized_menu=1

" ------------------------------------------------------------------
" Airline (powerline)
" ------------------------------------------------------------------
" vim-airline {{{
set laststatus=2                                    " Make the second to last line of vim our status line
 
" let g:airline_section_a       (mode, crypt, paste, iminsert)
" let g:airline_section_b       (hunks, branch)
" let g:airline_section_c       (bufferline or filename)
" let g:airline_section_gutter  (readonly, csv)
" let g:airline_section_x       (tagbar, filetype, virtualenv)
" let g:airline_section_y       (fileencoding, fileformat)
" let g:airline_section_z       (percentage, line number, column number)
" let g:airline_section_warning (syntastic, whitespace)

" " here is an example of how you could replace the branch indicator with
" " the current working directory, followed by the filename.
" let g:airline_section_b = '%{getcwd()}'
" let g:airline_section_c = '%t'
let g:airline#extensions#branch#enabled = 0         " Do not show the git branch in the status line
let g:airline#extensions#syntastic#enabled = 1      " Do show syntastic warnings in the status line
let g:airline#extensions#tabline#show_buffers = 0   " Do not list buffers in the status line
" let g:airline_section_x = ''                        " Do not list the filetype or virtualenv in the status line
" let g:airline_section_y = '[R%04l,C%04v] [LEN=%L]'  " Replace file encoding and file format info with file position
" let g:airline_section_z = ''                        " Do not show the default file position info
let g:airline_section_b = '%{getcwd()}'
let g:airline#extensions#virtualenv#enabled = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:Powerline_symbols="fancy"
" let g:airline_symbols = {}
" let g:airline_left_sep = "\u2b80" "use double quotes here
" let g:airline_left_alt_sep = "\u2b81"
" let g:airline_right_sep = "\u2b82"
" let g:airline_right_alt_sep = "\u2b83"
" let g:airline_symbols.branch = "\u2b60"
" let g:airline_symbols.readonly = "\u2b64"
" let g:airline_symbols.linenr = "\u2b61"
" }}}

" cursor stuff for mintty
" let &t_ti.="\e[1 q"
" let &t_SI.="\e[5 q"
" let &t_EI.="\e[1 q"
" let &t_te.="\e[0 q"

" ------------------------------------------------------------------
" Regular mappings
" ------------------------------------------------------------------
let mapleader = "\<Space>"

" Y yanks until end of line instead of full line
map Y y$

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" DO NOT DO THIS: turn off search highlight using esc
" actually this is dangerous as fuck
" see http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
" nnoremap <esc> :noh<CR><esc>

" Clear screen removes highlighting
noremap <C-L> :nohlsearch<CR><C-L>

"save file with leader
" nnoremap <Leader>w :w<CR>
"save all the files with leader
nnoremap <Leader>w :wall<CR>

"Automatically jump to end of text you pasted
vnoremap y y`]
vnoremap p p`]
nnoremap p p`]

"Copy & paste to system clipboard 
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" toggle fold
nnoremap <Leader>z za

" goto definition using Ycm
nnoremap <Leader>n :YcmCompleter GoTo<CR> 

" goto alternate file using a.vim
nnoremap <Leader>a :A<CR> 

" navigate windows
nnoremap <Bslash>l <C-W>l
nnoremap <Bslash>h <C-W>h
nnoremap <Bslash>k <C-W>k
nnoremap <Bslash>j <C-W>j

" exchange windows
nnoremap <Bslash>x <C-W>x
" rotate
nnoremap <Bslash>r <C-W>r

" create a scratch buffer. 
function! ScratchEdit(cmd, options)
	exe a:cmd tempname()
	" setl buftype=nofile bufhidden=wipe nobuflisted
	setl buftype=nofile bufhidden=wipe
	if !empty(a:options) | exe 'setl' a:options | endif
endfunction

command! -bar -nargs=* Sedit call ScratchEdit('edit', <q-args>)
command! -bar -nargs=* Ssplit call ScratchEdit('split', <q-args>)
command! -bar -nargs=* Svsplit call ScratchEdit('vsplit', <q-args>)
command! -bar -nargs=* Stabedit call ScratchEdit('tabe', <q-args>

" Compatible with ranger 1.4.2 through 1.7.*
"
" Add ranger as a file chooser in vim
"
" If you add this code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.

function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>
