set nocompatible 
let mapleader = ","

" Filetype *******************************************************************

filetype on
filetype plugin indent on

" LaTeX **********************************************************************

let g:tex_flavor='latex'
let g:Tex_ViewRule_pdf = 'Preview'

" Indentation ****************************************************************

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

set backspace=indent,eol,start
set autoindent
set smarttab
set smartindent
set nofoldenable

" Statusline *****************************************************************

set showcmd
set shortmess=atI
set laststatus=2
set statusline=%f%m\ %=[y=%l,x=%v]\ %=%p%%
set splitbelow
set splitright

" NERD  **********************************************************************
 
" Don't bother us when editing rest-files
let g:NERDShutUp = 1

" AutoClose ******************************************************************

"let g:AutoClosePairs = {'(': ')', '{': '}', '[': ']', '"': '"', "'": "'", '<': '>'}

" Gutter *********************************************************************

"set number
set numberwidth=1

" History, backup and undo ***************************************************

set history=1000
set undolevels=1000
set directory=/tmp
set writebackup
set backup backupdir=$HOME/.vim/backup

" Misc ***********************************************************************

set matchtime=2
set nowrap
set vb
set bg=dark

" Wildmenu *******************************************************************

set wildmenu
set complete=.,w,b,u,U,t,i
set wildmode=list:longest,list:full
set wildignore=*.pyc

" Searching *****************************************************************

"set ignorecase
set smartcase
set hlsearch
set incsearch

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

" Custom Mappings ************************************************************

nnoremap ' `
nnoremap ` '

" Some cool bash-hooks
command! -nargs=1 -complete=file CreateTemplate !bash ~/bin/create_template.sh <args>

" For the last time!
command W w
command Q q
command WQ wq
command Wq wq

" Navigate between windows
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" Navigate Tabs
noremap <leader>tn :tabnext<CR>
noremap <leader>tp :tabprev<CR>
noremap <leader>t1 :tab 1<CR>
noremap <leader>t2 :tab 2<CR>
noremap <leader>t3 :tab 3<CR>
noremap <leader>t4 :tab 3<CR>
noremap <leader>t5 :tab 4<CR>

" Open files
noremap <leader>e :FuzzyFinderTextMate<CR>
noremap <leader>E :FuzzyFinderTextMateRefreshFiles<CR>
noremap <leader>b :FuzzyFinderBuffer<CR>
let g:fuzzy_ignore = "*.png;*.jpg;*.jpeg;*.gif;*.swp;*.pyc;*.psd;*.ai;*.JPG;*.db;*.class;*.mp3"
let g:fuzzy_path_display = 'full'

" Reset search highlighting
noremap <leader>nh :noh<CR>

" Toggle paste mode
noremap <leader>pp :set paste!<CR>

" Toggle NERDTree
noremap <leader>nn :NERDTreeToggle<CR>

" Edit vim-file
noremap <C-A> :Explore ~/Documents/<CR>

" Space scrolls half a page
noremap <Space> <C-d>

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

" Remove trailing whitespace from lines
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

"autocmd BufRead,BufNewFile *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead,BufNewFile *.html set filetype=htmldjango.html
autocmd BufRead,BufNewFile models.py set filetype=python.djangomodels
autocmd BufRead,BufNewFile *.txt set filetype=rest
autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd Filetype html,xml,xsl source ~/.vim/scripts/closetag.vim

" Source local configuration
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
