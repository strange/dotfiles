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
    set completefunc=completer#Completer
    exec 'delete'
    exec 'startinsert'
    let s:lastColumn = 0

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
    if s:_splitbelow
        set splitbelow
    endif
endfunction

function! s:OnInsertLeave()
    call s:ResetUI()
endfunction

function! s:OnBackspace()
    call feedkeys("\<C-X>\<C-U>", 'n')
    let s:lastColumn = col('.') - 1
    return "\<BS>"
endfunction

function! s:OnCursorMoved()
    if col('.') != s:lastColumn
        call feedkeys("\<C-X>\<C-U>", 'n')
        let s:lastColumn = col('.')
    endif
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
    " We need to call OnInsertLeave() explicitly for some reason. The
    " stopinsert-command should suffice in theory?
    call s:OnInsertLeave()

    " Open the actual file for editing
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
        call feedkeys("\<C-P>\<Down>", 'n')
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
        let ignore = '*.jpeg,*.jpg,*.pyo,*.pyc,.DS_Store,*.png,*.bmp,*.gif,*~,*.o, *.class'
        let &wildignore=ignore
        " Build a search cache by traversing the current working directory,
        " omitting all directories, and splitting and reversing each path
        " entry on a slash.
        let s:cache = map(filter(split(globpath('.', "**/*"), '\n'),
            \ '!isdirectory(v:val)'), 'reverse(split(v:val, "/"))')
        let s:path = path
        let &wildignore=s:_wildignore
        echo "Cache update done!"
    endif
endfunction

function! s:FileSeach(pattern)
    call completer#UpdateCache(0)
    let results = []
    let pattern = a:pattern
    if pattern[-1:] == '/'
        " Add an asterisk to patterns ending with slash to expand
        " the directory while searching.
        let pattern = pattern."*"
    endif
    " Escape a few characters that can mess up regular expressions.
    let pattern = escape(pattern, " \t\n.?[{´$#'\"|!<&+\\'}]")
    " Add a few patterns for convenience
    let pattern = substitute(pattern, '\([_]\+\)', '*\1*', 'g') 
    let pattern = substitute(pattern, '[\*]\+', '.*', 'g')
    let bits = reverse(split(pattern, '/'))
    let bitlen = len(bits)
    for entry in s:cache
        if bitlen > len(entry)
            " Skip item as it cannot possibly match.
            continue
        endif
        let index = 0
        let matches = 0
        while index < bitlen
            if match(entry[index], '^'.bits[index]) != -1
                let matches = matches + 1
            endif
            let index = index + 1
            if index > matches
                " Break out of the loop if we've gone through more iterations
                " than we have found matching bits.
                break
            endif
        endwhile
        if matches == bitlen
            call insert(results, join(reverse(entry[:]), '/')[2:])
        endif
        if len(results) > 200
            break
        endif
    endfor
    return results
endfunction
