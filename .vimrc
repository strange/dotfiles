set nocompatible 
let mapleader = ","
set iskeyword+=#,-

" Filetype *******************************************************************

filetype on
filetype plugin indent on

" Indentation and text formatting ********************************************

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set backspace=indent,eol,start
set smartindent
set autoindent
set smarttab

set tw=78
set formatoptions=rnq

" History, backup and undo ***************************************************

set history=1000
set undolevels=1000
set directory=/tmp
set writebackup
set backup backupdir=$HOME/.vim/backup

" Edtitor and Interface ******************************************************

set matchtime=2
set scrolloff=5
set vb
set nowrap
set bg=dark

set wildmenu
set wildmode=list:longest,full
set wildignore=*.pyc

set nofoldenable
set report=2
set virtualedit=block

" Statusline *****************************************************************

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

set ignorecase
set infercase
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

" LaTeX **********************************************************************

let g:tex_flavor='latex'
let g:Tex_ViewRule_pdf = 'Preview'

" NERD Comments **************************************************************
 
let g:NERDShutUp = 1
let g:NERDSpaceDelims = 1
let g:NERDCommentWholeLinesInVMode=1
" let g:NERDDefaultNesting=0

" AutoClose ******************************************************************

"let g:AutoClosePairs = {'(': ')', '{': '}', '[': ']', '"': '"', "'": "'",
                        "\ '<': '>'}

" SnipMate *******************************************************************

let g:snips_author = 'Gustaf Sjöberg'

" SuperTab *******************************************************************

let g:SuperTabDefaultCompletionType = "<C-n>"

" FuzzyFinder ****************************************************************

noremap <leader>e :FuzzyFinderTextMate<CR>
noremap <leader>E :FuzzyFinderTextMateRefreshFiles<CR>
noremap <leader>b :FuzzyFinderBuffer<CR>

let g:fuzzy_ignore = "*.png;*.jpg;*.jpeg;*.gif;*.swp;*.pyc;*.psd;*.ai;*.JPG;"
                    \"*.db;*.class;*.mp3"
let g:fuzzy_path_display = 'full'

" Custom Mappings ************************************************************

nnoremap ' `
nnoremap ` '

" For the last time!
command! W w
command! Q q
command! WQ wq
command! Wq wq

cnoremap w!! w !sudo tee % > /dev/null

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

" Navigate Tabs
noremap <leader>tn :tabnext<CR>
noremap <leader>tp :tabprev<CR>
noremap <leader>t1 :tab 1<CR>
noremap <leader>t2 :tab 2<CR>
noremap <leader>t3 :tab 3<CR>
noremap <leader>t4 :tab 3<CR>
noremap <leader>t5 :tab 4<CR>

" Reset search highlighting
noremap <leader>nh :noh<CR>

" Toggle paste mode
noremap <leader>pp :set paste!<CR>

" Toggle NERDTree
noremap <leader>nn :NERDTreeToggle<CR>

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

" Filetypes ******************************************************************

au BufWritePre *.py normal m`:%s/\s\+$//e ``
au Filetype html,xml,xsl,htmldjango source ~/.vim/scripts/closetag.vim
au Filetype rest set formatoptions=tcqna

" Local Configuration ********************************************************

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
