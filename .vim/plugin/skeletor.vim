function! Skeletor()
    if &filetype == ''
        return ''
    endif
    let paths = split(&runtimepath, ',')
    let files = []
    let entries = []
    let counter = 1
    for path in paths
        let x = path."/skels/".&filetype
        if isdirectory(x)
            let subjects = split(glob(x."/*"), '\n')
            for subject in subjects
                call insert(entries, counter.") ".fnamemodify(subject, ':t'))
                call insert(files, subject)
                let counter = counter + 1
            endfor
        endif
    endfor
    call reverse(entries)
    call reverse(files)
    let choice = inputlist(entries)
    if choice > 0 && choice <= len(files)
        exe 'r '.files[choice - 1]
    endif
endfunction

command! Skeletor :call Skeletor()
