function! pywin#util#add_path(path) abort
  let pathlist = split($PATH, ';')
  if isdirectory(a:path) && index(pathlist, a:path) == -1
    call insert(pathlist, a:path, 0)
  endif
  let $PATH = join(pathlist, ';')
endfunction
