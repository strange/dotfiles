if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.txt set filetype=rest
    au! BufRead,BufNewFile *.as set filetype=actionscript
    au! BufRead,BufNewFile *.xul set filetype=xml
augroup END
