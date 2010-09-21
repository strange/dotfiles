" A simple Vim script that makes sending data from a vim instance to a tmux
" pane (within the same window) easy.
" Maintainer: Gustaf Sjöberg <gs@distrop.com>
" Last Change: 2010 May 18
"
" Drop this script in your ~/.vim/plugin directory.
" Use it with <C-c><C-c> (ooo, slime)

function! TmuxPaste(subject)
    if !exists("b:tmux_pane") || !exists("b:tmux_back_to_vim")
        let b:tmux_pane = input("Pane ID: ", "", "custom,TmuxPaneId")
        let b:tmux_back_to_vim = inputlist(["Go back to vim after pasting?",
                \ '1. Yes', '2. No'])
    endif

    let current_pane = system('tmux display -p "#P" | tr -d "\n"')
    if b:tmux_pane == '' || b:tmux_pane == current_pane
        unlet b:tmux_pane
    unlet b:tmux_back_to_vim
    else
        call system('tmux set-buffer "'.escape(a:subject, '"').'"')
        call system('tmux select-pane -t '.b:tmux_pane)
        call system("tmux paste-buffer -d")
        if b:tmux_back_to_vim == '1'
            call system('tmux select-pane -t '.current_pane)
        endif
    end
endfunction

function! TmuxPaneId(ArgLead, CmdLine, CursorPos)
    return system('tmux list-panes | sed -e "s/\(.*\):.*/\1/"')
endfunction

function! TmuxResetPaneId()
    unlet b:tmux_pane
    unlet b:tmux_back_to_vim
endfunction

vnoremap <silent> <C-c><C-c> "xy:call TmuxPaste(@x)<CR>
nnoremap <silent> <C-c><C-c> gg"xyG'':call TmuxPaste(@x)<CR>
command TmuxPasteReset :call TmuxResetPaneId()
