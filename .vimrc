set nocompatible 
filetype on
filetype plugin indent on

syntax on

let python_highlight_indent_errors = 0
let python_highlight_space_errors = 0
let python_highlight_all = 1

let g:tex_flavor='latex'
let g:Tex_ViewRule_pdf = 'Preview'

let mapleader = ","

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

set backspace=indent,eol,start
set autoindent
set smarttab
set smartindent
set nofoldenable

set showcmd
set matchtime=2

set laststatus=2

nnoremap ' `
nnoremap ` '

"set number
set numberwidth=1

" Some cool bash-hooks
command! -nargs=1 -complete=file CreateTemplate !bash ~/bin/create_template.sh <args>

" Don't bother us when editing rest-files
let g:NERDShutUp = 1

set vb
set ruler
set nosplitbelow
set splitright
set wildmenu " Display tab-complete matches above commandline
set bg=dark
set nowrap
set history=1000
set ul=1000

set complete=.,w,b,u,U,t,i
set wildmode=list:longest,list:full

set shortmess=atI

"set ignorecase
set smartcase
set hlsearch
set incsearch

" Go away, pesky .swp files
set directory=/tmp

" Backup settings
set writebackup
set backup backupdir=$HOME/.vim/backup

set encoding=utf-8
let $LANG="en_US.UTF-8"
set langmenu=en_us.utf-8

set wildignore=*.pyc

color gconsole

" Navigate windows
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
let g:fuzzy_ignore = "*.png;*.jpg;*.jpeg;*.gif;*.swp;*.pyc;*.psd;*.ai;*.JPG;*.db"
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

" Simple Snippets ;)
inoremap <c-e> <C-r>=Snips()<CR>
function! Snips()
    let line = getline('.')
    let cursor = col('.')
    let match = matchlist(line[:cursor - 1], '\v(\w+)$')
    if !empty(match) && match(line[cursor], '\v\s|^$') == 0
        let trigger = match[1]
        let bs = repeat("\<BS>", strlen(trigger))
        " Django Template Snippets
        if &filetype == "htmldjango"
            if trigger == 'load'
                return bs."{% load  %}\<Left>\<Left>\<Left>"
            elseif trigger == 'extends'
                return bs."{% extends  %}\<Left>\<Left>\<Left>"
            elseif trigger == 'if'
                return bs."{% if  %}\<CR>\<Tab>\<CR>{% endif %}\<Up>\<Up>\<Left>\<Left>\<Left>"
            elseif trigger == 'ifequal'
                return bs."{% ifequal  %}\<CR>\<Tab>\<CR>{% endifequal %}\<Up>\<Up>\<Left>\<Left>\<Left>"
            elseif trigger == 'else'
                return bs."{% else %}"
            elseif trigger == 'html_base'
                return bs."<!DOCTYPE html PUBLIC \"-\/\/W3C\/\/DTD XHTML 1.0 Strict\/\/EN\"\<CR>\<Tab>\"http:\/\/www.w3.org\/TR\/xhtml1\/DTD\/xhtml1-strict.dtd\">\<CR>\<CR>\<BS><html xmlns=\"http:\/\/www.w3.org\/1999\/xhtml\" xml:lang=\"en\" lang=\"en\">\<CR>\<CR>\<BS><head>\<CR><meta http-equiv=\"Content-type\" content=\"text\/html; charset=utf-8\" />\<CR><title></title>\<CR>\<BS></head>\<CR>\<CR><body></body>\<CR>\<CR></html>"
            endif
        elseif &filetype == "python"
            if trigger == "pdb"
                return bs."import pdb; pdb.set_trace()" 
            endif
        elseif &filetype == "djangomodels"
            if trigger == 'mdf'
                return bs."models.DecimalField()\<left>"
            elseif trigger == 'mcf'
                return bs."models.CharField(max_length=)\<Left>"
            endif
        endif
        return ""
    endif
endfunction

" Remove trailing whitespace from lines
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType actionscript set omnifunc=actionscriptcomplete#Complete

"autocmd BufRead,BufNewFile *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead,BufNewFile *.html set filetype=htmldjango
autocmd BufRead,BufNewFile models.py set filetype=python.djangomodels
autocmd BufRead,BufNewFile *.txt set filetype=rest
autocmd BufRead,BufNewFile *.as set filetype=actionscript

" Source local configuration
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
