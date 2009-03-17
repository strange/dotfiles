" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Indent Java anonymous classes correctly.
setlocal cindent cinoptions& cinoptions+=j1
"let b:undo_indent = "set cin< cino< indentkeys< indentexpr<"
