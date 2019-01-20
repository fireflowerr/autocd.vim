" Plugin for automatically changing to a directory based on file type

" ****************************************************************************************************
" AUTOCD
" ****************************************************************************************************
"

scriptencoding utf-8

" Upward search for specified marker
fun! autocd_main#searchmarker(dir) 
  " Make sure dictionary is initialized
  if !exists("g:autocd#project_markers['default']")
    let g:autocd#project_markers = { 'default': ['disabled'] }
  endif

  let l:test = "g:autocd#project_markers['" . &filetype . "']"
  let l:marks = exists(l:test) ?
\    g:autocd#project_markers[&filetype] : g:autocd#project_markers['default']
  
  let l:dir = s:has_suffix(a:dir, l:marks) 
  if l:dir != 0 
    if g:autocd#project_markers['default'][0] =~# '^disabled$' 
      return 1
    else
      let l:dir = s:has_suffix(a:dir, g:autocd#project_markers['default'])
    endif
  endif 
  
  if l:dir == 0
    return l:dir
  endif

  " So that success can be evaluated with if SearchMarker('%:p') == 0
  return 1
endfun

fun! s:has_suffix(dir, marks)
  let l:fmod = ':h'
  let l:dir = a:dir
  " return true if when appended to the current path a marker in g:autocd#project_markers is valid
  while l:dir !~# '^.$'

    for marker in a:marks
      if(!empty(glob(l:dir . '/' . marker)))
        return l:dir    
      endif
    endfor

    let l:dir = fnamemodify(l:dir, l:fmod) 
  endwhile

  return 1
endfun

" Switch directory or tab directory as appropriate
fun! s:SwitchDir(dir)
  if tabpagenr('$') == 1
    execute('cd ' . a:dir)
  elseif
    execute('lcd ' . a:dir)
  endif
endfun

fun! autocd_main#autocd()
  let l:dir = autocd_main#searchmarker(expand('%:p:h'))
  if l:dir == 0

    call s:SwitchDir(l:dir)
  endif
  
endfun
