" ####################################################################################################
" Vim autocd plugin
" ####################################################################################################

scriptencoding utf-8

""
" @section Commands, commands

" This wrapper is required to make NerdTree sync work
fun! s:Autocd()
  let l:open = g:NERDTree.IsOpen()
 call autocd_main#autocd()

  if exists('g:loaded_nerd_tree') && g:loaded_nerd_tree == 1 && 
\       exists('g:autocd#sync_nerdtree') && g:autocd#sync_nerdtree == 1 

    execute('NERDTreeCWD')
    if !l:open
      execute('NERDTreeClose')
    endif

  endif
endfun

""
" Starts a recursive upward search from the current file to a marker in the dictionary of the
" current file or default if none is provided. If there is a single tab change the cd to the result
" of the search, otherwise change the lcd to the result of the search.
command! Autocd call s:Autocd()

