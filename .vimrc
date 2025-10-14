" ============================================================================
" Minimal .vimrc for DevOps & Multi-language Development
" ============================================================================

" Basic Settings
set nocompatible              " Disable vi compatibility
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable file type detection and smart indenting

" Color Scheme
set t_Co=256                  " Enable 256 colors
set background=dark
" Try tokyonight-storm if available, fallback to slate
silent! colorscheme tokyonight-storm
if !exists('g:colors_name') || g:colors_name != 'tokyonight-storm'
  colorscheme slate
endif

" UI & Display
set number                    " Show line numbers
set relativenumber            " Relative line numbers for easier navigation
set ruler                     " Show cursor position
set showcmd                   " Show incomplete commands
set wildmenu                  " Enhanced command line completion
set wildmode=longest:full,full
set laststatus=2              " Always show status line
set cursorline                " Highlight current line
set showmatch                 " Highlight matching brackets
set scrolloff=3               " Keep 3 lines visible above/below cursor

" Search
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive when uppercase present

" Indentation & Formatting
set autoindent                " Copy indent from current line
set smartindent               " Smart auto-indenting
set expandtab                 " Use spaces instead of tabs
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set softtabstop=4             " Backspace removes 4 spaces
set backspace=indent,eol,start " Make backspace work properly

" Language-specific indentation
autocmd FileType javascript,json setlocal ts=2 sw=2 sts=2
autocmd FileType python setlocal ts=4 sw=4 sts=4
autocmd FileType go setlocal ts=4 sw=4 sts=4 noexpandtab
autocmd FileType c setlocal ts=4 sw=4 sts=4
autocmd FileType yaml,yml setlocal ts=2 sw=2 sts=2

" Performance
set lazyredraw                " Don't redraw during macros
set ttyfast                   " Faster terminal connection

" File Handling
set autoread                  " Auto reload files changed outside vim
set encoding=utf-8            " UTF-8 encoding
set fileformats=unix,dos,mac  " Handle different line endings
set hidden                    " Allow hidden buffers with unsaved changes

" Backup & Swap
set nobackup                  " No backup files (good for servers)
set nowritebackup             " No backup while editing
set noswapfile                " No swap files

" Better Splits
set splitright                " Vertical split to the right
set splitbelow                " Horizontal split below

" Clipboard (if available)
if has('clipboard')
  set clipboard=unnamed       " Use system clipboard
endif

" Key Mappings
let mapleader = ","           " Set leader key to comma

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Quick buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Easy indentation in visual mode
vnoremap < <gv
vnoremap > >gv

" DevOps Specific
" Quick file type toggles for common config files
autocmd BufNewFile,BufRead *.yaml.j2,*.yml.j2 set filetype=yaml
autocmd BufNewFile,BufRead Dockerfile* set filetype=dockerfile
autocmd BufNewFile,BufRead *.tf set filetype=terraform
autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Show trailing whitespace
set list
set listchars=tab:▸\ ,trail:·,nbsp:·

" Status Line (minimal but informative)
set statusline=%f               " Filename
set statusline+=\ %m            " Modified flag
set statusline+=\ %r            " Read-only flag
set statusline+=%=              " Right align
set statusline+=\ %y            " File type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}]
set statusline+=\ %p%%          " Percentage through file
set statusline+=\ %l:%c         " Line:Column

" Netrw (built-in file explorer) settings
let g:netrw_banner = 0          " Disable banner
let g:netrw_liststyle = 3       " Tree view
let g:netrw_browse_split = 4    " Open in previous window
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Quick file explorer
nnoremap <leader>e :Explore<CR>

" Go-specific settings
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4

" Python-specific settings
autocmd FileType python setlocal colorcolumn=80  " PEP8 line length guide

" Mouse support (optional, comment out if not desired)
if has('mouse')
  set mouse=a                   " Enable mouse in all modes
endif
