" Remember recent files? Could be nice.

if exists("g:loaded_completer")
    finish
endif
let g:loaded_completer = 1

if !exists("g:completer_ignore")
    let g:completer_ignore = "*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,
                            \ *.gif,*~,*.o, *.class,*.ai,*.plist,*.swp,*.mp3
                            \ *.db"
endif

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
    set completefunc=completer#Completefunc
    delete " Delete any text
    startinsert! " Enter insert mode

    augroup CompleterMovements
        autocmd!
        autocmd InsertLeave <buffer> call s:Reset()
        autocmd BufLeave <buffer> call s:Reset()
    augroup END
    inoremap <silent> <buffer> <Tab> <Down>
    inoremap <silent> <buffer> <S-Tab> <Up>
    inoremap <silent> <buffer> <CR> <C-R>=completer#OpenFile()<CR>
    inoremap <silent> <buffer> <C-Y> <C-R>=completer#OpenFile()<CR>
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
    exec s:bufno.'bdelete!'
    exec s:_winno.'wincmd w'
    if s:_splitbelow
        set splitbelow
    endif
endfunction

function! s:Action()
    call feedkeys("\<C-X>\<C-U>\<C-P>\<Down>", 'n')
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
    stopinsert! " This should trigger InsertLeave?
    call s:Reset()

    " Open the actual file for editing
    if !empty(file)
        exec ":silent edit ".file
    endif
endfunction

function! completer#Completefunc(start, base)
    if a:start == 1
        " First invocation, return the column from which we should start
        " matching.
        return 0
    endif
    if empty(a:base) || a:base == '.'
        return []
    endif
    let result = s:FileSeach(a:base)
    if !empty(result)
        call feedkeys("\<C-P>\<Down>", 'n')
    endif
    return result
endfunction

function s:BuildCacheFind()
    let ignore = split(g:completer_ignore, ',')
    let input = map(ignore, '" -not -iname \x27".v:val."\x27"')
    call add(input, " -not -path './.\*'")
    return split(system('find -L . -type f '.join(input, ' ')), '\n')
endfunction

function s:BuildCacheNative()
    return filter(split(globpath('.', "**/*"), '\n'), '!isdirectory(v:val)')
endfunction

let s:path = ''
let s:cache = []
function completer#UpdateCache(force)
    let path = getcwd()
    if empty(s:cache) || path != s:path || a:force
        echo "Updating cache ..."
        let wildignore = &wildignore
        let &wildignore=g:completer_ignore
        let s:cache = map(s:BuildCacheFind(), 'v:val[2:]')
        let s:path = path
        let &wildignore=wildignore
        echo "Cache update done!"
    endif
endfunction

function! s:FileSeach(pattern)
    call completer#UpdateCache(0)
    let pattern = escape(a:pattern, " *\t\n.?[{´$#'\"|!<&+\\'}]")
    let pattern = substitute(pattern, '\/', '.*\/.*', 'g').'[^\/]*$'
    return filter(s:cache[:], 'v:val =~? pattern')[:300]
endfunction
