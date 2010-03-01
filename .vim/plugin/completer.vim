function! s:Completer()
    call completer#InitUI()
endfunction

function! s:CompleterUpdateCache()
    call completer#UpdateCache(1)
endfunction

command! Completer :call s:Completer()
command! CompleterUpdateCache :call s:CompleterUpdateCache()
