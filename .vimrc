set nocompatible 
let mapleader=","
filetype off

" Indentation and text formatting ********************************************

set clipboard=unnamed

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set backspace=indent,eol,start
set autoindent
" set smartindent
" set smarttab

set tw=78
set formatoptions=rnql
set nojoinspaces

set iskeyword+=@,_,-

" History, backup and undo ***************************************************

set history=1000
set undolevels=1000
set directory=/tmp//
set writebackup
set backup backupdir=$HOME/.vim/backup

if v:version >= 703
    set undodir=~/.vim/undo
    set undofile
    set undoreload=10000
endif

" Edtitor and Interface ******************************************************

set nomodeline
set matchtime=2
set scrolloff=12
" set scrolljump=50
set vb
set nowrap
set bg=dark
set title
set novisualbell
" set cursorline

set wildmenu
set wildmode=full
set wildignore=*.pyc,*.pyo,*.beam

set nofoldenable
set report=2
set virtualedit=block

set showtabline=0

set ttyfast

if v:version >= 703
    set colorcolumn=80
endif

" Statusline *****************************************************************

set showmode
set showcmd
set shortmess=atI
set laststatus=2

set statusline=%(\ %f%m%r%{&paste?'[PASTE]':''}\ %)%=%(\ y=%l,x=%v:%=%p%%\ %)

set splitbelow
set splitright
set fillchars=stl:-,vert:\|,fold:-,diff:-

" Gutter *********************************************************************

" set number
set numberwidth=1
if v:version >= 703
    " set relativenumber
endif

" Searching *****************************************************************

set noignorecase
set infercase
set smartcase
set hlsearch
set incsearch
set gdefault

" Language *******************************************************************

set encoding=utf-8
let $LANG="en_US.UTF-8"
set langmenu=en_us.utf-8

" Vundle *********************************************************************

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Misc bundles
Bundle 'vim-scripts/YankRing.vim'
Bundle 'gmarik/vundle'
Bundle 'ack.vim'
Bundle 'rking/ag.vim'
Bundle 'ervandew/supertab'
Bundle 'indentpython.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'python.vim--Vasiliev'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'scrooloose/nerdtree'
Bundle 'strange/pyxis-vim'
Bundle 'strange/skeletor-vim'
Bundle 'strange/strange.vim.git'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-surround'
Bundle 'tsaleh/vim-matchit'
Bundle 'wlangstroth/vim-racket'
Bundle 'othree/html5-syntax.vim'
Bundle 'chase/vim-ansible-yaml'
Bundle 'mitsuhiko/vim-jinja'
" Bundle 'jimenezrick/vimerl'

" Python *********************************************************************

let python_highlight_exceptions = 1
let python_highlight_builtin_funcs = 1
let python_highlight_builtin_objs = 1
let python_highlight_doctests = 1
let python_highlight_string_formatting = 1

" Syntax *********************************************************************

syntax sync minlines=256
syntax on
color strange

" SuperTab *******************************************************************

let g:SuperTabDefaultCompletionType = "<C-n>"

" YankRing *******************************************************************

let g:yankring_history_dir = '~/.vim'
 
" Completer ******************************************************************

noremap <leader>e :Pyxis<CR>
noremap <leader>E :PyxisUpdateCache<CR>

let g:pyxis_ignore = "*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,
                     \*.gif,*~,*.o,*.class,*.ai,*.plist,*.swp,*.mp3,*.db,
                     \*.beam,*.pdf,*.swf,*.flv,*.mpeg,*.mp4,*.zip,*.tar,
                     \*.tgz,*.tar.gz,*.wmv,*git*,*.o,*.hi,*.nib,
                     \*.tiff,./env/*,./static/script/tiny_mce/*,./deps/*,
                     \./log/*"

" RagTag *********************************************************************

imap <C-_> <C-X>/

" " NERDTree *******************************************************************

noremap <silent> <leader>x :NERDTreeToggle<CR>

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" Custom Mappings ************************************************************

nnoremap ' `
nnoremap ` '

" For the last time!
command! W w
command! Q q
command! WQ wq
command! Wq wq
nnoremap Q <nop>

" because sometimes i forget
cnoremap w!! w !sudo tee % > /dev/null

" open shell quickly
" noremap <space> :shell<cr>

" Navigate between windows
noremap <C-w><C-j> <C-w>w
noremap <C-w><C-k> <C-W>W
noremap <C-w>j <C-w>w
noremap <C-w>k <C-W>W
noremap <C-w><C-w> <C-w>p

" Explore marks
noremap <leader>m :marks<cr>

" Line navigation
noremap <C-h> ^
noremap <C-l> g_

" Reset search highlighting
nnoremap <silent><c-l> :nohl<cr><esc>

" Toggle paste mode
noremap <silent> <leader>p :set paste!<cr>

" Indenting
vnoremap < <gv
vnoremap > >gv

" Detect file types **********************************************************

filetype plugin indent on

" AutoCommands ***************************************************************

" strip trailing spaces in python
au BufWritePre *.py normal m`:%s/\s\+$//e ``

" remember last cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" | 
    \ endif

" a few per filetype settings
au Filetype python set commentstring=#\ %s
au Filetype actionscript set commentstring=//\ %s
au Filetype rest set formatoptions=tclqn
au Filetype css set foldmethod=syntax foldmarker={,}
au Filetype help map <cr> <c-]>
au Filetype help set colorcolumn=0
au FileType html set tw=0 indentexpr& autoindent
" au BufEnter * :syntax sync minlines=200

" Local Configuration ********************************************************

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
