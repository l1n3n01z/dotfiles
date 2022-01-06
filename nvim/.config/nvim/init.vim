"--------------------------------------------------------------------------
" General settings
"--------------------------------------------------------------------------

" sets from Jess Archer https://github.com/jessarcher/dotfiles/blob/master/nvim/init.vim
" compare to https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/plugin/sets.vim
"

set hidden
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set signcolumn=yes:2
set number
set termguicolors
set spell
set title
set ignorecase
set smartcase
set smartindent
set wildmode=longest:full,full
set nowrap
set list
set listchars=tab:▸\ ,trail:·
set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitright
set clipboard=unnamedplus
set confirm
set undofile
set backup
set backupdir=~/.local/share/nvim/backup//
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files
set nospell

set nohlsearch

function! IsWsl()
  if has("unix")
    let lines = readfile("/proc/version")
    if lines[0] =~? "microsoft"
      return 1
    endif
  endif
  return 0
endfunction



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

" " prequisite?
" Plug 'nvim-lua/popup.nvim'
" " prequisite
" Plug 'nvim-lua/plenary.nvim'

" Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Plug 'jeetsukumaran/vim-filebeagle'
" Plug 'tpope/vim-vinegar'
" Plug 'scrooloose/nerdtree'

" Plug 'kyazdani42/nvim-web-devicons' " for file icons
" Plug 'kyazdani42/nvim-tree.lua'
" ---------- treesitter ---------

" Plug 'nvim-treesitter/nvim-treesitter'
" Plug 'nvim-treesitter/playground'

" ----------- git ---------------
Plug 'tpope/vim-fugitive'

" ----------- notes -------------

" Plug 'vimwiki/vimwiki'

" ------------ status bar ---------------
" all the bling
" Plug 'bling/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Plug 'dstein64/vim-startuptime'
call plug#end()

colorscheme gruvbox

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
nmap <leader>Q :bufdo bdelete<cr>

"save file with leader
nnoremap <Leader>w :w<CR>
"save all the files with double leader
nnoremap <Leader><Leader>w :wall<CR>


"just use the clipboard
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
" nnoremap <Leader>z za
"

" shows highlight groups
nnoremap <silent><leader>sh :TSHighlightCapturesUnderCursor<CR>

" nnoremap <leader>sh :call <SID>SynStack()<CR>
" function! <SID>SynStack()
"   if !exists("*synstack")
"     return
"   endif
"   echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
" endfunc

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   -- One of "all", "maintained" (parsers with maintainers), or a list of languages
"   ensure_installed = { "c_sharp" },

"   -- Install languages synchronously (only applied to `ensure_installed`)
"   sync_install = false,

"   -- List of parsers to ignore installing
"   ignore_install = { "javascript" },

"   highlight = {
"     -- `false` will disable the whole extension
"     enable = true,

"     -- list of language that will be disabled
"     disable = { "c", "rust" },

"     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
"     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
"     -- Using this option may slow down your editor, and you may see some duplicate highlights.
"     -- Instead of true it can also be a list of languages
"     additional_vim_regex_highlighting = false,
"   },
" }
" EOF

" --snippet = {
" --    expand = function(args)
"     vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
"     -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
"     -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
"     -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
" end,
  " { name = 'vsnip' }, -- For vsnip users.
  " -- { name = 'luasnip' }, -- For luasnip users.
  " -- { name = 'snippy' }, -- For snippy users.
  " -- { name = 'ultisnips' }, -- For ultisnips users.
  " }, {
" },

" are we doing this twice?
" lua <<EOF
" local cmp = require'cmp'
" -- Global setup.
" cmp.setup({
"     mapping = {
"         ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
"         ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
"         ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
"         ['<C-e>'] = cmp.mapping({
"             i = cmp.mapping.abort(),
"             c = cmp.mapping.close(),
"         }),
"         -- Accept currently selected item. If none selected, `select` first item.
"         -- Set `select` to `false` to only confirm explicitly selected items.
"         ['<CR>'] = cmp.mapping.confirm({ select = true }),
"     },
"     sources = cmp.config.sources({
"         { name = 'nvim_lsp' },
"         { name = 'buffer' },
"     })
" })
" -- `/` cmdline setup.
" cmp.setup.cmdline('/', {
"     sources = {
"         { name = 'buffer' }
"     }
" })
" -- `:` cmdline setup.
" cmp.setup.cmdline(':', {
"     sources = cmp.config.sources({
"         { name = 'path' }
"     }, {
"         { name = 'cmdline' }
"     })
" })
" -- Setup lspconfig.
" local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
" local pid = vim.fn.getpid()
" -- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
" local omnisharp_bin = "/home/nonni/.local/share/nvim/lsp_servers/omnisharp/omnisharp/run"
" -- on Windows
" -- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
" require('lspconfig').omnisharp.setup {
"     capabilities = capabilities,
"     cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
" }
" EOF

" let wiki_1 = {}
" let wiki_1.path = '~/vimwiki/'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'

" let g:vimwiki_list = [wiki_1]
" let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
" let g:vimwiki_global_ext = 0


" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
