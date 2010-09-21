function! BufSwitch()
    let bufs = []
    let buflen = bufnr("$")
    if buflen > 0
        for bufno in range(1, buflen)
            let bufname = bufname(bufno)
            if buflisted(bufno) && bufname != ""
                call add(bufs, bufno.": ".bufname(bufno))
            endif
        endfor
    endif
    if len(bufs)
        let choice = inputlist(bufs)
        if choice > 0 && buflisted(choice)
            silent execute 'b '.choice
        endif
    else
        echo "No buffers available"
    endif
endfunction

command! BufSwitch :call BufSwitch()
