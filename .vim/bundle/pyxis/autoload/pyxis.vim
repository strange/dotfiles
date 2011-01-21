" A simple Vim script that makes for quick finding and opening files
" Maintainer: Gustaf Sjöberg <gs@distrop.com>
" Last Change: 2010 Mar 07
"
" Drop this script in your ~/.vim/autoload directory.

if exists("g:loaded_pyxis")
    finish
endif
let g:loaded_pyxis = 1

if !exists("g:pyxis_ignore")
    let g:pyxis_ignore = "*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,*.gif,
                         \*~,*.o,*.class,*.ai,*.plist,*.swp,*.mp3,*.db,*.beam"
endif

function! pyxis#InitUI()
    let s:_winno = winnr()
    let s:_completeopt = &completeopt
    let s:_splitbelow = &splitbelow
    let s:_paste = &paste

    set nosplitbelow " Always show the completion-window above current
    exec '1split [Start typing the name of a file ...]'
    let s:bufno = bufnr('%')
    setlocal nobuflisted " Do not show in buf list
    setlocal nonumber " Do not display line numbers
    setlocal noswapfile " Do not use a swapfile for the buffer
    setlocal buftype=nofile " The buffer is not related to any file
    setlocal bufhidden=delete " The buffer dies with the window
    setlocal noshowcmd " Be restrictive with what to show in statusbar
    setlocal nowrap " Do not wrap long lines
    setlocal winfixheight " Keep height when other windows are opened
    setlocal textwidth=0 " No maximum text width
    setlocal nopaste " Paste mode interferes
    set completeopt=menuone " Use popup with only one match
    set completefunc=pyxis#CompleteFunc
    delete " Delete any text
    startinsert! " Enter insert mode

    augroup CompleterMovements
        autocmd!
        autocmd InsertLeave <buffer> call s:Reset()
        autocmd BufLeave <buffer> call s:Reset()
    augroup END
    inoremap <silent> <buffer> <Tab> <Down>
    inoremap <silent> <buffer> <S-Tab> <Up>
    inoremap <silent> <buffer> <CR> <C-Y><C-R>=pyxis#OpenFile()<CR>
    inoremap <silent> <buffer> <C-Y> <C-Y><C-R>=pyxis#OpenFile()<CR>
    inoremap <silent> <buffer> <C-C> <C-R>=<SID>Reset()<CR>
    inoremap <silent> <buffer> <C-H> <C-R>=<SID>Action()<CR><C-H>
    inoremap <silent> <buffer> <BS> <C-R>=<SID>Action()<CR><BS>
    inoremap <silent> <buffer> <Space> <Space><C-R>=<SID>Action()<CR>
    " CursorMovedI does not seem to work consistently. This is a temp fix.
    let ino = "inoremap <silent> <buffer> %c %c\<C-R>=\<SID>Action()\<CR>"
    for chr in range(33, 123) + range(125, 126)
        exec printf(ino, chr, chr)
    endfor
endfunction

function! s:Reset()
    let &completeopt=s:_completeopt
    exec 'bdelete! '.s:bufno
    exec s:_winno.'wincmd w'
    if s:_paste
        set paste
    endif
    if s:_splitbelow
        set splitbelow
    endif
    return ''
endfunction

function! s:Action()
    call feedkeys("\<C-X>\<C-U>\<C-P>\<Down>", 'n')
    return ''
endfunction

function! pyxis#OpenFile()
    let filename = getline('.')
    stopinsert! " This should trigger InsertLeave?
    call s:Reset()
    if !empty(filename)
        exec ":silent edit ".filename
    endif
endfunction

function! pyxis#CompleteFunc(start, base)
    if a:start == 1
        return 0
    endif
    if empty(a:base)
        return []
    endif
    let result = s:FileSeach(a:base)
    if !empty(result)
        call feedkeys("\<C-P>\<Down>", 'n')
    endif
    return result
endfunction

function! s:BuildCacheFind()
    let ignore = split(g:pyxis_ignore, ',')
    let input = map(ignore, '" -not -iname \x27".v:val."\x27"')
    call add(input, " -not -path './.\*'")
    return split(system('find -L . -type f '.join(input, ' ')), '\n')
endfunction

function! s:BuildCacheNative()
    let wildignore = &wildignore
    let &wildignore = g:pyxis_ignore
    let results = globpath('.', "**/*")
    let &wildignore = wildignore
    return filter(split(results, '\n'), '!isdirectory(v:val)')
endfunction

let s:path = ''
let s:cache = []
function! pyxis#UpdateCache(force)
    let path = getcwd()
    if a:force || empty(s:cache) || path != s:path
        echo "Updating cache ..."
        let s:cache = map(s:BuildCacheFind(), 'v:val[2:]')
        let s:path = path
        echo "Cache update done!"
    endif
endfunction

function! s:FileSeach(needle)
    call pyxis#UpdateCache(0)
    let n = substitute(fnameescape(a:needle), '\/', '.*\/.*', 'g').'[^\/]*$'
    return filter(s:cache[:], 'v:val =~? n')[:300]
endfunction
