set nocompatible 
filetype on
filetype plugin indent on

syntax on

let python_highlight_indent_errors = 0
let python_highlight_space_errors = 0
let python_highlight_all = 1

let mapleader = ","

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4 " Use the < and > keys from visual mode to block indent/unindent
set backspace=indent,eol,start
set autoindent
set smarttab
set smartindent

set showcmd

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
set splitbelow
set splitright
set wildmenu " Display tab-complete matches above commandline
set bg=dark
set nowrap
set history=1000
set ul=1000

set shortmess=atI

" Ignore case when searching if only lowecase characters are used
set ignorecase
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

" Open files
noremap <leader>e :FuzzyFinderTextMate<CR>
noremap <leader>E :FuzzyFinderTextMateRefreshFiles<CR>
noremap <leader>b :FuzzyFinderBuffer<CR>
let g:fuzzy_ignore = "*.png;*.jpg;*.jpeg;*.gif;*.swp;*.pyc;*.psd;*.ai;*.JPG"
let g:fuzzy_path_display = 'full'

" Reset search highlighting
noremap <leader>n :noh<CR>

" Edit vim-file
nmap <C-A> :Explore ~/Documents/<CR>

" Space scrolls half a page
noremap <Space> <C-d>

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
inoremap <S-Tab> <C-r>=Snips()<CR>
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
                return "import pdb; pdb.set_trace()" 
            endif
        elseif &filetype == "vim"
            if trigger == 'mdf'
                return bs."models.DecimalField()\<left>"
            elseif trigger == 'mcf'
                return bs."models.CharField(max_length=)\<Left>"
            endif
        endif
        return ""
    endif
endfunction

" Omni completion using tab
inoremap <silent> <Tab> <C-r>=<SID>InsertTabWrapper(1)<CR>
"inoremap <silent> <S-Tab> <C-r>=<SID>InsertTabWrapper(-1)<CR>
function! <SID>InsertTabWrapper(direction)
  let idx = col('.') - 1
  let str = getline('.')
  if a:direction > 0 && idx >= 2 && str[idx - 1] == ' '
	\&& str[idx - 2] =~? '[a-z]'
    if &softtabstop && idx % &softtabstop == 0
      return "\<BS>\<Tab>\<Tab>"
    else
      return "\<BS>\<Tab>"
    endif
  elseif idx == 0 || str[idx - 1] !~? '[a-z]'
    return "\<Tab>"
  elseif a:direction > 0
    return "\<C-n>"
  else
    return "\<C-p>"
  endif
endfunction

" Remove trailing whitespace from lines
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCS

autocmd BufRead,BufNewFile *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead,BufNewFile *.html set filetype=htmldjango
autocmd BufRead,BufNewFile *.txt set filetype=rest
