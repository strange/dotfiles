" TODO:
" * Remember recent files?
" * Performance..?
" * No flicker on new keystrokes
" * Come up with a name .. :)

if exists("g:loaded_completer")
    finish
endif
let g:loaded_completer = 1

function! completer#InitUI()
    " Reference window from which we were invoked and settings we'll be
    " changing.
    let s:_winno = winnr()
    let s:_completeopt = &completeopt
    let s:_splitbelow = &splitbelow

    " Create and setup a new window for file-pattern insertion.
    set nosplitbelow
    exec '1split [Type the name of a file or directory ...]'
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
    set completeopt=menuone " Use popup with only one match
    set omnifunc=
    set completefunc=completer#Completefunc
    exec 'delete'
    exec 'startinsert'
    let s:lastColumn = 0

    augroup CompleterMovements
        autocmd!
        autocmd InsertLeave <buffer> call s:Reset()
        autocmd BufLeave <buffer> call s:Reset()
    augroup END

    for chr in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
              \ 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
              \ 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
              \ 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
              \ 'W', 'X', 'Y', 'Z', '-', '_', '~', '^', '.', ',', ';', '!',
              \'#', '=', '%', '$', '@', '<', '>', '/', '\', '<Space>']
        exec 'ino <silent> <buffer> '.chr.' '.chr.'<C-E><C-R>=<SID>Action()<CR>'
    endfor

    inoremap <silent> <buffer> <Tab> <Down>
    inoremap <silent> <buffer> <S-Tab> <Up>
    inoremap <silent> <buffer> <CR> <C-R>=completer#OpenFile()<CR>
    inoremap <silent> <buffer> <C-Y> <C-R>=completer#OpenFile()<CR>
    inoremap <silent> <buffer> <C-C> <C-R>=<SID>Reset()<CR>
    inoremap <silent> <buffer> <BS> <BS><C-E><C-R>=<SID>Action()<CR>
endfunction

function! s:Reset()
    let s:lastColumn = 0
    let &completeopt=s:_completeopt
    exec s:bufno.'bdelete!'
    exec s:_winno.'wincmd w'
    if s:_splitbelow
        set splitbelow
    endif
endfunction

let s:lastColumn = 0
function! s:Action()
    if col('.') != s:lastColumn
        call feedkeys("\<C-X>\<C-U>", 'n')
        let s:lastColumn = col('.')
    endif
    return ''
endfunction

function! completer#OpenFile()
    if pumvisible()
        " The popup menu is visible. Select the current item and re-invoke
        " this function.
        call feedkeys("\<C-Y>\<C-R>=completer#OpenFile()\<CR>", 'n')
        return ''
    endif

    let file = getline('.')
    exec 'stopinsert'
    " We need to call Reset() explicitly for some reason. 'stopinsert' should
    " suffice in theory?
    call s:Reset()

    " Open the actual file for editing
    if !empty(file)
        exec ":silent edit ".file
    endif
    return ''
endfunction

function! completer#Completefunc(start, base)
    if a:start == 1
        " First invocation, return the column from which we should start
        " matching.
        return 0
    endif
    if empty(a:base) || a:base == '.'
        return ''
    endif
    let result = s:FileSeach(a:base)
    call feedkeys("\<C-p>\<Down>", 'n')
    return result
endfunction

let s:path = ''
let s:cache = []
let s:cachelen = 0

function completer#UpdateCache(force)
    let path = getcwd()
    if empty(s:cache) || s:path != path || a:force
        echo "Updating cache ..."
        let s:_wildignore = &wildignore
        let ignore = '*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,*.gif,*~,*.o, *.class'
        let &wildignore=ignore
        let cache = filter(split(globpath('.', "**/*"), '\n'),
                         \ '!isdirectory(v:val)')
        let s:cache = cache
        let s:cachelen = len(s:cache)
        let s:path = path
        let &wildignore=s:_wildignore
        echo "Cache update done!"
    endif
endfunction

function! s:FileSeach(pattern)
    call completer#UpdateCache(0)
    let results = []
    let pattern = a:pattern
    " Escape a few characters that can mess up regular expressions.
    let pattern = escape(pattern, " \t\n.?[{´$#'\"|!<&+\\'}]")
    " Add a few patterns for convenience
    let pattern = substitute(pattern, '\([_]\+\)', '*\1*', 'g') 
    let pattern = substitute(pattern, '\([\/]\+\)', '*\1*', 'g') 
    let pattern = substitute(pattern, '[\*]\+', '.*', 'g')
    if len(split(pattern, '/')) == 1
        let pattern = '.*'.pattern.'[^\/]*$'
    endif
    let index = 0
    for entry in s:cache
        if match(entry, pattern) != -1
            call insert(results, entry[2:])
        endif
        if len(results) > 200
            break
        endif
    endfor
    return results
endfunction
