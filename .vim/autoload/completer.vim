" TODO:
" * remember recent files
" * Dynamic window title?
" * Fuzzy matching? 
" * Match directories on slash?
" * Performance..?

function! completer#InitUI()
    " Reference window from which we were invoked and settings we'll be
    " changing.
    let s:_winno = winnr()
    let s:_completeopt = &completeopt

    " Create and setup a new window for file-pattern insertion.
    exec 'topleft 1split [Type the name of a file or directory ...]'
    let s:bufno = bufnr('%')
    setlocal nobuflisted 
    setlocal nonumber 
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noshowcmd
    setlocal nowrap 
    setlocal wrap
    setlocal bufhidden=hide
    setlocal winfixheight
    setlocal wrapmargin=0
    setlocal textwidth=0
    set completeopt=menuone
    set completefunc=completer#Completer
    exec 'delete'
    exec 'startinsert'

    augroup CompleterMovements
        autocmd!
        autocmd InsertLeave <buffer> call s:OnInsertLeave()
        autocmd BufLeave <buffer> call s:OnInsertLeave()
        autocmd CursorMovedi <buffer> call s:OnCursorMoved()
    augroup END

    inoremap <silent> <buffer> <CR> <C-r>=completer#OpenFile()<CR>
    inoremap <silent> <buffer> <C-y> <C-r>=completer#OpenFile()<CR>
    inoremap <silent> <buffer> <C-c> <C-r>=<SID>ResetUI()<CR>
    inoremap <silent> <buffer> <BS> <C-r>=<SID>OnBackspace()<CR>
    inoremap <silent> <buffer> <C-h> <C-r>=<SID>OnBackspace()<CR>
    inoremap <silent> <buffer> <Tab> <Down>
    inoremap <silent> <buffer> <S-Tab> <Up> " Does not work in console vim
endfunction

function s:ResetUI()
    let s:lastColumn = 0
    let &completeopt=s:_completeopt
    exec s:bufno.'bdelete!'
    exec s:_winno.'wincmd w'
endfunction

function! s:OnInsertLeave()
    call s:ResetUI()
endfunction

function! s:OnBackspace()
    if pumvisible()
        call feedkeys("\<C-x>\<C-u>", 'n')
    endif
    return "\<BS>"
endfunction

let s:lastColumn = 0
function! s:OnCursorMoved()
    if col('.') != s:lastColumn
        let s:lastColumn = col('.')
        call feedkeys("\<C-x>\<C-u>", 'n')
    endif
endfunction

function! completer#OpenFile()
    if pumvisible()
        " The popup menu is visible. Select the current item and re-invoke
        " this function.
        call feedkeys("\<C-y>\<C-r>=completer#OpenFile()\<CR>", 'n')
        return ''
    endif

    let file = getline('.')

    exec 'stopinsert'
    " We need to call OnInsertLeave() explicitly for some reason. The
    " stopinsert-command should suffice in theory?
    call s:OnInsertLeave()

    if !empty(file)
        exec ":silent edit ".file
    endif
    return ''
endfunction

function! completer#Completer(start, base)
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
        call feedkeys("\<C-p>\<Down>", 'n')
    endif

    return result
endfunction

let s:path = ''
let s:cache = []
function completer#UpdateCache(force)
    let path = getcwd()
    if empty(s:cache) || path != s:path || a:force
        echo "Updating cache ..."
        let s:_wildignore = &wildignore
        set wildignore=*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp
        let s:cache = []
        let files = split(globpath('.', "**/*"), '\n')
        for row in files 
            if isdirectory(row) == 0
                call insert(s:cache, reverse(split(row, '/')[1:]))
            endif
        endfor
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
    let pattern = substitute(pattern, '_', '.*_.*', '')
    " Add a few patterns for convenience
    let pattern = substitute(pattern, '*', '.*', '')
    let bits = reverse(split(pattern, '/'))
    let bitlen = len(bits)
    for entry in s:cache
        if bitlen > len(entry)
            continue
        endif
        let index = 0
        let matches = 0
        while index < bitlen
            if match(entry[index], bits[index]) != -1
                let matches = matches + 1
            endif
            let index = index + 1
            if index > matches
                break
            endif
        endwhile
        if matches == bitlen
            call insert(results, join(reverse(entry[:]), '/'))
        endif
    endfor
    return results
endfunction
