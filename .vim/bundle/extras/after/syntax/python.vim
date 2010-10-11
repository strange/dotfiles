syn match pythonOps /[=|!=|+|-|%]/
syn keyword PythonArguments self args kwargs
syn keyword DjangoInternals get_object_or_404 render_to_response

hi def link DjangoInternals Keyword
hi def link PythonArguments Keyword
