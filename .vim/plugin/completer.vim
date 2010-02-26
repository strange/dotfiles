function! s:Completer()
    call completer#InitUI()
endfunction

command! Completer :call s:Completer()
