set nocompatible 
let mapleader=","
"set runtimepath=$HOME/.vim

" Filetype *******************************************************************

filetype off " as suggested by Tim Pope
call pathogen#runtime_append_all_bundles() 
call pathogen#helptags() 
filetype plugin indent on

" Indentation and text formatting ********************************************

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
set scrolloff=8
set vb
set nowrap
set bg=dark
set title
set visualbell

set wildmenu
set wildmode=full
set wildignore=*.pyc,*.pyo,*.beam

set nofoldenable
set report=2
set virtualedit=block

set showtabline=0

set ttyfast
set ttymouse=

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

" Syntax *********************************************************************

syntax on
color strange

" SuperTab *******************************************************************

let g:SuperTabDefaultCompletionType = "<C-n>"

" Completer ******************************************************************

noremap <leader>e :Pyxis<CR>
noremap <leader>E :PyxisUpdateCache<CR>

let g:pyxis_ignore = '*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,
                     \*.gif,*~,*.o,*.class,*.ai,*.plist,*.swp,*.mp3,*.db,
                     \*.beam'

" RagTag *********************************************************************

imap <C-_> <C-X>/

" Yankring *******************************************************************

let g:yankring_history_dir = '$HOME/.vim'

" BufSwitch ******************************************************************

map <leader>l :BufSwitch<CR>

" Gundo **********************************************************************

map <leader>g :GundoToggle<CR>

" NERDTree *******************************************************************

noremap <silent> <leader>x :NERDTreeToggle<cr>

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" Custom Mappings ************************************************************

nnoremap ' `
nnoremap ` '

inoreabbrev lorem Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy
            \nnibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi
            \enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis
            \nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in
            \hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
            \feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui
            \blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla
            \facilisi.

" For the last time!
command! W w
command! Q q
command! WQ wq
command! Wq wq

" johan uses two spaces to indent everything
command! JFD set ts=2 sw=2

" because sometimes i forget
cnoremap w!! w !sudo tee % > /dev/null

" open shell quickly
" noremap <space> :shell<cr>

" Navigate between windows
noremap <C-j> <C-w>w
noremap <C-k> <C-W>W
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
nnoremap <silent> <C-l> :nohl<cr><C-l>

" Toggle paste mode
noremap <silent> <leader>p :set paste!<cr>

" Indenting
vnoremap < <gv
vnoremap > >gv

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
au Filetype html set formatoptions=q
au Filetype help map <cr> <c-]>
au Filetype help set colorcolumn=0
au FileType html set indentexpr& autoindent
au BufEnter * :syntax sync minlines=200
au Filetype erlang :ErlangDisableShowErrors

" Local Configuration ********************************************************

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
