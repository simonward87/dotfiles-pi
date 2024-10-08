filetype plugin indent on
syntax enable

set backspace=indent,eol,start                    " restore default backspace behaviour
set completeopt=menuone,longest,noinsert,noselect " text completion
set cursorline                                    " current line highlight
set encoding=utf-8                                " set internal encoding
set expandtab                                     " convert tabs to spaces
set hlsearch                                      " highlight all search results
set hidden                                        " keep multiple buffers open
set ignorecase                                    " case-insensitive search
set incsearch                                     " updates search results per-character
set iskeyword+=-                                  " treat dash-separation as word text object
set laststatus=1                                  " hide statusbar when editing a single file
set mouse=nicr                                    " enable mouse
set nobackup                                      " coc recommendation
set noerrorbells                                  " mute error sound
set noswapfile                                    " new buffers created without swapfiles
set nowrap                                        " disable line wrapping
set nowritebackup                                 " coc recommendation
set nrformats-=octal                              " disallow octals for math operations
set number                                        " enable line numbers
set relativenumber                                " enable relative line numbers
set noruler                                       " hide cursor location
set scrolloff=4                                   " scroll limit from screenY boundaries
set shiftwidth=4                                  " updates shift-width value
set shortmess+=c                                  " avoid file message prompts
set sidescrolloff=12                              " scroll limit from screenX boundaries
set smartcase                                     " case-sensitive search on capital letter
set smarttab                                      " indents according to shiftwidth
set softtabstop=4                                 " 2 spaces for tabs during editing
set tabstop=4                                     " 2 spaces for tabs
set ttyfast                                       " optimize for fast terminal connections
set undodir=~/.vim/undodir                        " directory for undo history files
set undofile                                      " save undo history to dedicated file
set updatetime=300                                " swapfile written after time in ms
set wildmenu                                      " enhanced command completion

if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Auto-initialize Vim Plug if not already set up
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

" Plugins
Plug 'alvan/vim-closetag'                         " auto-close html, jsx, tsx tags
Plug 'cormacrelf/vim-colors-github'               " theme
Plug 'ctrlpvim/ctrlp.vim'                         " fuzzy finder
Plug 'djoshea/vim-autoread'                       " auto reload files when changed externally
Plug 'evanleck/vim-svelte', {'branch': 'main'}    " syntax highlighting & indentation, Svelte
Plug 'gosukiwi/vim-atom-dark'                     " theme
Plug 'jacoborus/tender.vim'                       " theme
Plug 'leafgarland/typescript-vim'                 " ts syntax files
Plug 'lilydjwg/colorizer'                         " hex code colourizer
Plug 'pangloss/vim-javascript'                    " syntax highlighting & indentation, JavaScript
Plug 'tpope/vim-capslock'                         " software capslock
Plug 'tpope/vim-commentary'                       " comment stuff out
Plug 'tpope/vim-fugitive'                         " git wrapper
Plug 'tpope/vim-surround'                         " easily change surrounds
Plug 'tpope/vim-vinegar'                          " netrw enhancements

call plug#end()

autocmd BufNewFile,BufReadPost '*.md' set filetype=markdown
autocmd BufRead,BufNewFile Dockerfile.dev setf dockerfile
autocmd BufRead,BufNewFile zprofile setf zsh
autocmd FileType css setlocal sts=2 sw=2 ts=2
autocmd FileType gitcommit setlocal wrap spell
autocmd FileType go setlocal noet
autocmd FileType graphql setlocal sts=2 sw=2 ts=2
autocmd FileType html setlocal sts=2 sw=2 ts=2
autocmd FileType javascript setlocal sts=2 sw=2 ts=2
autocmd FileType javascriptreact setlocal sts=2 sw=2 ts=2
autocmd FileType json setlocal sts=2 sw=2 ts=2
autocmd FileType less setlocal sts=2 sw=2 ts=2
autocmd FileType make setlocal noet sts=0 sw=8 ts=8
autocmd FileType markdown setlocal wrap spell sts=2 sw=2 ts=2
autocmd FileType scss setlocal sts=2 sw=2 ts=2
autocmd FileType svelte setlocal sts=2 sw=2 ts=2
autocmd FileType typescript setlocal sts=2 sw=2 ts=2
autocmd FileType typescriptreact setlocal sts=2 sw=2 ts=2
autocmd FileType vim setlocal sts=2 sw=2 ts=2
autocmd FileType vue setlocal sts=2 sw=2 ts=2
autocmd FileType yaml setlocal sts=2 sw=2 ts=2

let mapleader=" "

let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.js,*.tsx,*.svelte'
let g:closetag_xhtml_filenames = '*.xml,*.xhtml,*.jsx,*.js,*.tsx,*.svelte'
let g:closetag_filetypes = 'html,xhtml,jsx,js,tsx,svelte'
let g:closetag_xhtml_filetypes = 'xml,xhtml,jsx,js,tsx,svelte'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:ctrlp_use_caching=0
let g:ctrlp_custom_ignore='node_modules\|DS_Store\|git\|__sapper__\|dist\|dotbot\|build'
let g:ctrlp_working_path_mode='ra'
let g:svelte_preprocessor_tags = [
\ { 'name': 'ts', 'tag': 'script', 'as': 'typescript'}
\ ]
let g:svelte_preprocessors = ['ts']

" window navigation
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>o :wincmd o<CR>
nnoremap <leader>f :CtrlP<CR>

" git
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gp :Git push<CR>

" buffer navigation
nnoremap <Right> :bn<CR>
nnoremap <Left> :bp<CR>
"
" shift text blocks vertically
xnoremap J :move '>+1<CR>gv-gv
xnoremap K :move '<-2<CR>gv-gv
inoremap <C-j> <esc>:move .+1<CR>==a
inoremap <C-k> <esc>:move .-2<CR>==a
nnoremap <leader>j :move .+1<CR>==
nnoremap <leader>k :move .-2<CR>==

" undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" autocenter when word searching
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" clear highlight search
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

let  theme = "lunaperche"
execute "colorscheme ".theme

" custom syntax match
syntax match WhitespaceEOL /\s\+$/

" custom highlights
highlight EndOfBuffer guifg=bg guibg=bg
highlight LineNr guibg=bg

if theme == "tender"
  highlight Normal guibg=#1d1d1d ctermbg=NONE
  highlight WhitespaceEOL guibg=#666666 ctermbg=gray
elseif theme == "github"
  set background=light
  highlight Normal guibg=#ffffff ctermbg=white
  highlight WhitespaceEOL guibg=#d73a49 ctermbg=white
endif
