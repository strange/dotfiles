function! Skeletor()
    if &filetype == ''
        echo "No filetype set"
        return ''
    endif
    let files = split(globpath(&runtimepath, 'skels/'.&filetype.'/*'))
    let entries = []
    let counter = 1
    for file in files
        call add(entries, counter.") ".fnamemodify(file, ':t'))
        let counter += 1
    endfor
    if len(files)
        let choice = inputlist(entries)
        if choice > 0 && choice <= len(files)
            let cpoptions = &cpoptions
            set cpoptions-=a
            silent execute '0r '.files[choice - 1]
            let cpoptions = cpoptions
        endif
    else
        echo "No skeleton files available"
    endif
endfunction

command! Skeletor :call Skeletor()
