au BufNewFile,BufRead *.rst,*.txt setf rest
au BufNewFile,BufRead *.todo setf todo
au BufNewFile,BufRead *.{rst,txt} setf rest
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} setf markdown
au BufRead,BufNewFile *.app.src setf erlang
