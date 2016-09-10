set nocompatible              " be iMproved, required


" Plugin installation  {{{
filetype off                  " required


set rtp+=~/vimfiles/bundle/Vundle.vim/
let path='~/vimfiles/bundle'
call vundle#begin(path)
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" Let's do some plugins!
" ****************************************************

" Plugin 'tpope/vim-sensible' do this by hand

" editing and such plugins
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-abolish'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'tpope/vim-repeat'

" text objects
Plugin 'bkad/CamelCaseMotion'
Plugin 'inkarkat/argtextobj.vim'
Plugin 'terryma/vim-expand-region'

" file directory
Plugin 'tpope/vim-vinegar'
Plugin 'scrooloose/nerdtree'
" Plugin 'jeetsukumaran/vim-filebeagle'

" Git
Plugin 'tpope/vim-fugitive'


" shoug and unite

" basic
Plugin 'shougo/unite.vim'
Plugin 'shougo/vimproc.vim'

" Addons
Plugin 'shougo/neomru.vim'
Plugin 'shougo/unite-outline'
Plugin 'junkblocker/unite-codesearch'
Plugin 'rking/ag.vim'

" rust
Plugin 'rust-lang/rust.vim'
Plugin 'phildawes/racer'

" nim
Plugin 'zah/nim.vim'



" color and themes
Plugin 'altercation/vim-colors-solarized'
" for 256 color terminals
Plugin 'jnurmine/Zenburn'
Plugin 'morhetz/gruvbox'

Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'easymotion/vim-easymotion'
" Missing YCM, multi cursor, colorcoded, though that does not work on Win

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" }}} Plugin installation
" Put your non-Plugin stuff after this line
"
"
" ================ General Config ====================
"
" More sensible settings
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
set shiftwidth=4
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
" ================ Custom Settings ========================

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=utf-8,latin1
endif

" ================ GVim Config ======================
if has("gui_running")
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    " set guifont=Consolas:h12
    set guifont=Droid_Sans_Mono_Slashed_for_Pow:h12:cANSI:qDRAFT
    set background=dark
    colorscheme gruvbox
endif

" ================ Consoles Config ======================

" cursor stuff for mintty
" let &t_ti.="\e[1 q"
" let &t_SI.="\e[5 q"
" let &t_EI.="\e[1 q"
" let &t_te.="\e[0 q"
" echom "Running in conemu"
" set termencoding=utf8
" set term=xterm
" set t_Co=256
" let &t_AB="\e[48;5;%dm"
" let &t_AF="\e[38;5;%dm"

if !has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

if ($ConEmuAnsi ==? 'ON')
    " echom "Running in conemu in ANSI mode"
    " set termencoding=utf8
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    colorscheme zenburn
    " problem with backspace fix
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
    " let mouse wheel scroll file contents
    set mouse=a
    inoremap <Esc>[62~ <C-X><C-E>
    inoremap <Esc>[63~ <C-X><C-Y>
    nnoremap <Esc>[62~ <C-E>
    nnoremap <Esc>[63~ <C-Y>
endif

==================== Airline ===================================

" vim-airline {{{
" NOTE needs utf-8 codepage
" chcp 65001
set laststatus=2                                    " Make the second to last line of vim our status line
set laststatus=2
set cmdheight=2
let g:airline#extensions#branch#enabled = 1         " Do show the git branch in the status line
" let g:airline_section_c = '%<%f%m%#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
" let g:airline#extensions#syntastic#enabled = 1      " Do show syntastic warnings in the status line
"let g:airline#extensions#tabline#show_buffers = 0   " Do not list buffers in the status line
"let g:airline_section_x = ''                        " Do not list the filetype or virtualenv in the status line
"let g:airline_section_y = '[R%04l,C%04v] [LEN=%L]'  " Replace file encoding and file format info with file position
"let g:airline_section_z = ''                        " Do not show the default file position info
"let g:airline#extensions#virtualenv#enabled = 0
" Powerline fonts for the win
" Do the symbols below show up?
" U+E0A0     Version control branch
" U+E0A1     LN (line) symbol
" U+E0A2     Closed padlock
" U+E0B0     Rightwards black arrowhead
" U+E0B1     Rightwards arrowhead
" U+E0B2     Leftwards black arrowhead
" U+E0B3     Leftwards arrowhead
"
" Let's just configure this by hand
" let g:airline_powerline_fonts=1

"let g:airline#extensions#tabline#enabled = 0
"let g:airline#extensions#tabline#fnamemod = ':t'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" unicode symbols
let g:airline_symbols.maxlinenr = "☰"
let g:airline_symbols.paste = 'ρ'
" \u2739 12 pointed black star
let g:airline_symbols.whitespace = "✹"
" \u00a7  Section Sign
" used for spelling error
let g:airline_symbols.spell = "§"
" \u00d8 danish o with stroke
" used for non existing branch or something
let g:airline_symbols.notexists = "Ø"
" \u2022 bullet
let g:airline_symbols.modified = "•"
let g:airline_detect_modified = 0
function! Init()
    call airline#parts#define_raw('modimodi', '%{&modified ? g:airline_symbols.modified : ""}')
    let g:airline_section_c = airline#section#create(['%<%f', 'modimodi'])
endfunction
autocmd VimEnter * call Init()
" }}}


" Solarized
"set background=dark
"colorscheme solarized



let g:racer_cmd = "C:\\bin\\racer\\target\\release\\racer.exe"
let $RUST_SRC_PATH="C:\\Rust_stable_1.1\\src"

" ================      Mappings      ========================

let mapleader = "\<Space>"

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Y yanks until end of line instead of full line
map Y y$

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

"save file with leader
nnoremap <Leader>w :w<CR>

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

" double tap for visual mode
nmap <Leader><Leader> V

" reselect what was just pasted
noremap gV `[v`]

" ================      Unite      ========================
let g:unite_source_history_yank_enable = 1
let g:unite_source_ = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>
" For ag.
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
endif

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

================ Other Plugin Mappings ===================================

" expand and shrink region in visual mode
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

