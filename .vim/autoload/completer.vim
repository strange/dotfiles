" TODO:
" * remember recent files
" * smarter matching?
" * ignore patterns
" * remove leading dot
" * dynamic window title?
" * filenames should take precedence

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

    let result = s:FindSeach(a:base)

    if !empty(result)
        call feedkeys("\<C-p>\<Down>", 'n')
    endif

    return result
endfunction

let s:path = ''
let s:cache = ''
function s:UpdateCache(path, force)
    if empty(s:cache) || a:path != s:path || a:force
        let command = "find . -maxdepth 6 -type f"
        let ignorePatterns = ['*.pyc', '*~', '*.git*', '*.jpg', '*.gif', '*.png']
        for ignorePattern in ignorePatterns
            let command = command." -not -ipath '".ignorePattern."'"
        endfor
        let s:cache = system(command)
        let s:path = a:path
    endif
    return s:cache
endfunction

function s:Regexpify(pattern)
    " Escape a few characters that can mess up regular expressions.
    let pattern = escape(a:pattern, " \t\n.?[{´$#'\"|!<&+\\")
    " Add a few wildcards suitable for greping.
    let pattern = substitute(pattern, '\/', '*\/*', '')
    let pattern = substitute(pattern, '*', '.*', '')
    return pattern
endfunction

function! s:FindSeach(pattern)
    call s:UpdateCache(getcwd(), 0)

    let pattern = s:Regexpify(a:pattern)
    let command = "grep -i --regexp '.*".pattern.".*$'"
    let result = split(system(command, s:cache), "\n")

    return result
endfunction
