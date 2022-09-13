"--------------------------------------------------------------------------
" General settings
"--------------------------------------------------------------------------

" sets from Jess Archer https://github.com/jessarcher/dotfiles/blob/master/nvim/init.vim
" compare to https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/plugin/sets.vim
"

" allow switching buffers without complaining
set hidden

" tabs, spaces bla
set expandtab
" hmmmm this is maybe not the best
set tabstop=4
set softtabstop=4
set shiftwidth=4

function! s:setAltPrefs()
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
endfunction

autocmd FileType xml,html,xhtml,javascript call s:setAltPrefs()
" 
set signcolumn=yes:2
set number
set termguicolors

" spell is annoying, it underlines everything in code!
" set spell

" show title of file
set title

" ignore case in patterns 
set ignorecase
" do not ignore case if there is something upper case in the pattern
set smartcase

" meh, seems to work fine
set smartindent

" should read up on wildmode, I probably want to have similar behaviour in
" shell and vim command
set wildmode=longest:full,full

set nowrap

" show tabs and trailing using listchars
set list
set listchars=tab:▸\ ,trail:·

"  mouse mode all
set mouse=a

" when curser gets close to edge, start scrolling the view
set scrolloff=8
set sidescrolloff=8

" this is the default setting. joinspaces adds two spaces after sentence end.
" Yuck!
set nojoinspaces

" horizontal split creates new window on right. 
set splitright

" os clipboard goes to and from unnamed 
set clipboard=unnamedplus

" always ask for confirmation when about to overwrite or quit without saving
set confirm

set undofile


set backup
set backupdir=~/.local/share/nvim/backup//


" CursorHold and swap file creation
set updatetime=300 " Reduce time for highlighting other references


" set redrawtime=10000 " Allow more time for loading syntax on large files
" default is 2000 ms

set incsearch " this is actually the default
set nohlsearch " so undecided whether to use this or not


function! IsWsl()
  if has("unix")
    let lines = readfile("/proc/version")
    if lines[0] =~? "microsoft"
      return 1
    endif
  endif
  return 0
endfunction


" requires installing win32yank in windows
" scoop install win32yank
if IsWsl()
    let g:clipboard = {
    \    'name': 'clipfunctions',
    \    'copy': {
    \       '+': 'win32yank.exe -i --crlf',
    \       '*': 'win32yank.exe -i --crlf',
    \       },
    \   'paste': {
    \       '+': 'win32yank.exe -o --lf',
    \       '*': 'win32yank.exe -o --lf',
    \       },
    \   'cache_enabled': 0,
    \   }
endif

" set relativenumber
" set exrc

"--------------------------------------------------------------------------
" Plugins
"--------------------------------------------------------------------------

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

" ----- colorschemes -------------

Plug 'gruvbox-community/gruvbox'
" Plug 'rktjmp/lush.nvim'
" Plug 'ellisonleao/gruvbox.nvim'
" Plug 'sickill/vim-monokai'
" Plug 'noah/vim256-color'
" Plug 'altercation/vim-colors-solarized'
" Plug 'chriskempson/base16-vim'
" Plug 'w0ng/vim-hybrid'

" ------ text editing -------------------
Plug 'vim-scripts/argtextobj.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'

" ------- lsp and completion -----------

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
" Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
" Plug 'onsails/lspkind-nvim'
" Plug 'github/copilot.vim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'williamboman/nvim-lsp-installer'

" ------- fuzzy finders, file navigation -------

" this is a very silly plugin
" Plug 'vim-scripts/a.vim'
" " fzf, let's try telescope instead
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
" telescope requirements...

" Plug 'junegunn/goyo.vim'

" " prequisite? probably not
" Plug 'nvim-lua/popup.nvim'
" " prequisite
Plug 'nvim-lua/plenary.nvim'

Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-fzy-native.nvim'
"
" deprecated
" Plug 'jeetsukumaran/vim-filebeagle'
"
" Plug 'tpope/vim-vinegar'
" Plug 'scrooloose/nerdtree'

" Plug 'kyazdani42/nvim-web-devicons' " for file icons
" Plug 'kyazdani42/nvim-tree.lua'
" ---------- treesitter ---------

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

" ----------- git ---------------
Plug 'tpope/vim-fugitive'

" ----------- notes -------------
" note, using dev to support files with dot in name
" see https://github.com/vimwiki/vimwiki/issues/1177
Plug 'vimwiki/vimwiki', { 'branch': 'dev'}

" ------------ status bar ---------------
" all the bling
" Plug 'bling/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" fast testing of startuptime
" Plug 'dstein64/vim-startuptime'

" ----------- open in browsers and stuff ---
Plug 'felipec/vim-sanegx' " gx is broken in wsl, this is a simple fix and is cross platform

call plug#end()

let $BASH_ENV = '~/.bashrc' " this is safe as bashrc check for non-interacive shell before doing stuff

colorscheme gruvbox " uses community

if IsWsl()
    " use hacked wslview, which opens regular https urls directly in firefox
    let g:netrw_browsex_viewer = 'wsl-open'
endif

"--------------------------------------------------------------------------
" Key maps
"--------------------------------------------------------------------------

let mapleader = "\<space>"

nmap <leader>ve :edit ~/.config/nvim/init.vim<CR>
nmap <leader>vr :source ~/.config/nvim/init.vim<CR>
nmap <leader>on :edit ~/notes.md<CR>


" Allow gf to open non-existent files
map gf :edit <cfile><CR>

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

"Automatically jump to end of text you pasted
" vnoremap y y`]
" vnoremap p p`]
" nnoremap p p`]

" move vertically by visual line, with a twist
" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Paste replace visual selection without copying it
vnoremap <leader>p "_dP

" Make Y behave like the other capitals
nnoremap Y y$

" Keep it centered
" What happens to my folds though? - nonni
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" disable Ex mode
nnoremap Q <nop>
" nmap <leader>k :nohlsearch<CR>
" nmap <leader>l :nohlsearch<CR>

" Clear screen removes highlighting
noremap <C-L> :nohlsearch<CR><C-L>
" DO NOT DO THIS: turn off search highlight using esc
" actually this is dangerous as fuck
" see http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
" nnoremap <esc> :noh<CR><esc>

" From Jess Archer. What does this do really?
" Oh ok, it runs bdelete on all open buffers
" so close all buffers
nmap <leader>Q :bufdo bdelete<cr>

"save file with leader
nnoremap <Leader>w :w<CR>
"save all the files with double leader
nnoremap <Leader><Leader>w :wall<CR>


"just use the clipboard=unnamedplus
"
"Copy & paste to system clipboard
" vmap <Leader>y "+y
" nmap <Leader>y "+yy
" vmap <Leader>d "+d
" nmap <Leader>d "+dd
" nmap <Leader>p "+p
" nmap <Leader>P "+P
" vmap <Leader>p "+p
" vmap <Leader>P "+P

" toggle fold
" nah, just practice using folds
" nnoremap <Leader>z za
"

" shows highlight groups
nnoremap <silent><leader>sh :TSHighlightCapturesUnderCursor<CR>

" the command above is better
" nnoremap <leader>sh :call <SID>SynStack()<CR>
" function! <SID>SynStack()
"   if !exists("*synstack")
"     return
"   endif
"   echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
" endfunc


" todo add a nice treesitter.lua

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
