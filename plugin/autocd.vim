" ####################################################################################################
" Vim autocd plugin
" ####################################################################################################

scriptencoding utf-8

" INIT
if exists('g:autocd#nts_enable') && g:autocd#nts_enable
  call autocd#nts_enable()
else
  let g:autocd#nts_enable = 0
  call autocd#nts_disable()
endif 
if exists('g:autocd#autocmd_enable') && g:autocd#autocmd_enable
  augroup Autocd 
    autocmd VimEnter,BufEnter * execute('Autocd')
  augroup END
else
  let g:autocd#autocmd_enable = 0
endif

if !exists('*g:autocd#makers_get_default') 
  fun! g:autocd#makers_get_default()
    return expand('%:p:h')
  endfun
endif

if !exists('g:autocd#markers_default') 
  let g:autocd#markers_default = 0
endif

if !exists('g:autocd#markers') 
  let g:autocd#markers = { }
endif

if !exists('g:autocd#max_depth') 
  let g:autocd#max_depth = -1
endif

if !exists('g:autocd#tab_isolation') 
  let g:autocd#tab_isolation = 1
endif

if !exists('g:autocd#generate_log')
  let g:autocd#generate_log = 0
endif

if !exists('g:autocd#log_path')
  let g:autocd#log_path = $HOME
endif

if !exists('g:autocd#ignore')
  let g:autocd#ignore = ['^term://']
endif

if !(exists('g:autocd#loaded') && g:autocd#loaded)
  call autocd#load()
  let g:autocd#loaded = 1
endif

""
" Starts a recursive upward search from the current file to a marker in the dictionary of the
" current file or default if none is provided. If there is a single tab change the cd to the result
" of the search, otherwise change the lcd to the result of the search.
command! Autocd call autocd#autocd(expand('%:p'))
