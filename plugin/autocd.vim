" ####################################################################################################
" Vim autocd plugin
" ####################################################################################################

scriptencoding utf-8

" INIT
if exists('g:autocd#nts_enable') && g:autocd#nts_enable
  execute('NERDTree | NERDTreeClose')
  call autocd#nts_enable()
else
  let g:autocd#nts_enable = 0
  call autocd#nts_disable()
endif

if exists('g:autocd#autocmd_enable') && g:autocd#autocmd_enable
  augroup Autocd 
    autocmd BufEnter * if bufname('%') !~# 'NERD_tree' |
\    execute('Autocd') |
\   endif  
  augroup END
else
  let g:autocd#autocmd_enable = 0
endif

if !exists('g:autocd#markers_filetype_first') 
  let g:autocd#markers_filetype_first = 1
endif

if !exists('*g:autocd#makers_get_default') 
  fun! g:autocd#makers_get_default()
    return expand('%:p:h')
  endfun
endif

if !exists('g:autocd#markers_default') 
  let g:autocd#markers_default = 0
endif

if !exists('g:autocd#markers_filetype') 
  let g:autocd#markers_filetype = { }
endif

if !exists('g:autocd#markers_path') 
  let g:autocd#markers_path = { }
endif

if !exists('g:autocd#max_depth') 
  let g:autocd#max_depth = -1
endif

if !exists('g:autocd#tab_isolation') 
  let g:autocd#tab_isolation = 1
endif

""
" @section Commands, commands

" This wrapper is required to make NerdTree sync work
fun! s:Autocd()
  call autocd#autocd(expand('%:p'))
endfun

""
" Starts a recursive upward search from the current file to a marker in the dictionary of the
" current file or default if none is provided. If there is a single tab change the cd to the result
" of the search, otherwise change the lcd to the result of the search.
command! Autocd call s:Autocd()
