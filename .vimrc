set nocompatible 
let mapleader=","
set runtimepath=$HOME/.vim

" Filetype *******************************************************************

filetype off " as suggested by Tim Pope
call pathogen#runtime_append_all_bundles() 
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

" Edtitor and Interface ******************************************************

set nomodeline
set matchtime=2
set scrolloff=5
set vb
set nowrap
set bg=dark
set title
set visualbell

set wildmenu
set wildmode=list:longest
set wildignore=*.pyc

set nofoldenable
set report=2
set virtualedit=block

set showtabline=0

set ttyfast
set ttymouse=

" Statusline *****************************************************************

set showmode
set showcmd
set shortmess=atI
set laststatus=2
set statusline=%(\ %f%m%r\ %)%=%(\ y=%l,x=%v:%=%p%%\ %)

set splitbelow
set splitright
set fillchars=stl:-,vert:\|,fold:-,diff:-

" Gutter *********************************************************************

"set number
set numberwidth=1

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

let python_highlight_indent_errors = 0
let python_highlight_space_errors = 0
let python_highlight_all = 1

syntax on
color strange

" SuperTab *******************************************************************

let g:SuperTabDefaultCompletionType = "<C-n>"

" Completer ******************************************************************

noremap <leader>e :Pyxis<CR>
noremap <silent> <leader>E :PyxisUpdateCache<CR>

let g:pyxis_ignore = '*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,
                     \*.gif,*~,*.o,*.class,*.ai,*.plist,*.swp,*.mp3,*.db,*.beam'

" RagTag *********************************************************************

imap <C-_> <C-X>/

" Yankring *******************************************************************

let g:yankring_history_dir = '$HOME/.vim'

" BufSwitch ******************************************************************

map <leader>l :BufSwitch<CR>

" Custom Mappings ************************************************************

nnoremap ' `
nnoremap ` '

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
noremap <space> :shell<cr>

" Navigate between windows
noremap <C-j> <C-w>w
noremap <C-k> <C-W>W
noremap <C-w><C-j> <C-w>w
noremap <C-w><C-k> <C-W>W
noremap <C-w>j <C-w>w
noremap <C-w>k <C-W>W
noremap <C-w><C-w> <C-w>p

" Line navigations
noremap <C-h> ^
noremap <C-l> g_

" Reset search highlighting
noremap <silent> <leader>n :silent :noh<CR>

" Toggle paste mode
noremap <silent> <leader>p :set paste!<CR>

" Explore
noremap <silent> <leader>x :Explore<CR>

" Keep hands on home row
inoremap jj <Esc>

" Expand braces
inoremap <silent> <CR> <C-R>=ExpandBraces()<CR>
function! ExpandBraces()
    let column = col('.')
    let line = getline('.')
    let current = line[column - 2]
    let next = line[column - 1]
    let valids = { '{': '}', '[': ']', '(': ')' }
    if column > 1 && has_key(valids, current) && next == valids[current]
        return "\<CR>\<CR>\<Up>\<Tab>"
    else
        return "\<CR>"
    endif
endfunction

" Indenting
vnoremap < <gv
vnoremap > >gv

" AutoCommands ***************************************************************

au BufWritePre *.py normal m`:%s/\s\+$//e ``
au Filetype python set commentstring=#\ %s
au Filetype rest set formatoptions=tcqn
au Filetype css set foldmethod=syntax foldmarker={,}
au Filetype help map <cr> <c-]>
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" | 
    \ endif

" Local Configuration ********************************************************

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
