" ============================================================================
" Minimal .vimrc for DevOps & Multi-language Development
" ============================================================================

" Basic Settings
set nocompatible              " Disable vi compatibility
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable file type detection and smart indenting

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
set history=1000              " Remember more commands and search history

" Security
set nomodeline                " Disable modelines for security
set modelines=0

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

" Persistent Undo
if has('persistent_undo')
  set undodir=~/.vim/undodir
  set undofile
  set undolevels=1000
  set undoreload=10000
endif

" Better Splits
set splitright                " Vertical split to the right
set splitbelow                " Horizontal split below

" Clipboard (if available)
if has('clipboard')
  set clipboard=unnamed       " Use system clipboard
endif

" Key Mappings
let mapleader = " "           " Set leader key to space

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

" Move lines up/down (terminal-friendly)
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
vnoremap <leader>j :m '>+1<CR>gv=gv
vnoremap <leader>k :m '<-2<CR>gv=gv

" Paste mode toggle
set pastetoggle=<F2>
nnoremap <leader>p :set paste!<CR>

" Quick buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Easy indentation in visual mode
vnoremap < <gv
vnoremap > >gv

" Better command-line navigation
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Save with sudo (for system files)
cnoremap w!! w !sudo tee % >/dev/null

" DevOps Specific
" Quick file type toggles for common config files
autocmd BufNewFile,BufRead *.yaml.j2,*.yml.j2 set filetype=yaml
autocmd BufNewFile,BufRead Dockerfile* set filetype=dockerfile
autocmd BufNewFile,BufRead *.tf set filetype=terraform
autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy
autocmd BufNewFile,BufRead *.conf set filetype=conf
autocmd BufNewFile,BufRead nginx*.conf set filetype=nginx
autocmd BufNewFile,BufRead *.hcl set filetype=hcl
autocmd BufNewFile,BufRead .env* set filetype=sh
autocmd BufNewFile,BufRead *inventory set filetype=ini

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

" Quick comment toggle (filetype-aware)
autocmd FileType python,sh,bash,yaml,conf,terraform nnoremap <leader>/ I# <Esc>
autocmd FileType javascript,c,go nnoremap <leader>/ I// <Esc>
autocmd FileType vim nnoremap <leader>/ I" <Esc>

" Format JSON
nnoremap <leader>fj :%!python3 -m json.tool<CR>

" Execute current file
nnoremap <leader>r :!%:p<CR>

" Execute selected bash command
vnoremap <leader>r :!bash<CR>

" Python-specific settings
autocmd FileType python setlocal colorcolumn=80  " PEP8 line length guide

" Mouse support (optional, comment out if not desired)
if has('mouse')
  set mouse=a                   " Enable mouse in all modes
endif
