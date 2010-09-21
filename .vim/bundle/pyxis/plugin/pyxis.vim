" A simple Vim script that makes finding and opening files fast
" Maintainer: Gustaf Sjöberg <gs@distrop.com>
" Last Change: 2010 Mar 07
"
" Drop this script in your ~/.vim/plugin directory.
"
" Open a search prompty with :Pyxis. Manually update the local search cache
" with :PyxisUpdateCache.
"
" Example mappings:
"
" noremap <leader>e :Pyxis<CR>
" noremap <silent> <leader>E :PyxisUpdateCache<CR>

command! Pyxis :call pyxis#InitUI()
command! PyxisUpdateCache :call pyxis#UpdateCache(1)
