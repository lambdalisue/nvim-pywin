let s:python_host_paths = {}
let s:python3_host_paths = {}


function! pywin#assign() abort
  if g:pywin#check_current_user
    call pywin#reg#find_install_paths(
          \ 'HKCU', function('s:on_find', ['HKCU'])
          \)
  else
    let s:python_host_paths['HKCU'] = ''
    let s:python3_host_paths['HKCU'] = ''
  endif
  if g:pywin#check_local_machine
    call pywin#reg#find_install_paths(
          \ 'HKLM', function('s:on_find', ['HKLM'])
          \)
  else
    let s:python_host_paths['HKLM'] = ''
    let s:python3_host_paths['HKLM'] = ''
  endif
endfunction

function! pywin#get_python_host_paths() abort
  return copy(s:python_host_paths)
endfunction

function! pywin#get_python3_host_paths() abort
  return copy(s:python3_host_paths)
endfunction


" Private --------------------------------------------------------------------
function! s:on_find(root, records) abort
  let r2 = filter(copy(a:records), 'v:val[0] =~# ''^2\.''')
  let r3 = filter(copy(a:records), 'v:val[0] =~# ''^3\.''')
  let s:python_host_paths[a:root] = empty(r2) ? '' : r2[-1][1]
  let s:python3_host_paths[a:root] = empty(r3) ? '' : r3[-1][1]

  if has_key(s:python_host_paths, 'HKCU') && has_key(s:python_host_paths, 'HKLM')
    call s:assign_python_host_path()
  endif
  if has_key(s:python3_host_paths, 'HKCU') && has_key(s:python3_host_paths, 'HKLM')
    call s:assign_python3_host_path()
  endif
endfunction

function! s:assign_python_host_path() abort
  if g:pywin#prefer_local_machine
    let g:python_host_path = empty(s:python_host_paths['HKLM'])
          \ ? empty(s:python_host_paths['HKCU'])
          \   ? get(g:, 'python_host_path', '')
          \   : s:python_host_paths['HKCU']
          \ : s:python_host_paths['HKLM']
  else
    let g:python_host_path = empty(s:python_host_paths['HKCU'])
          \ ? empty(s:python_host_paths['HKLM'])
          \   ? get(g:, 'python_host_path', '')
          \   : s:python_host_paths['HKLM']
          \ : s:python_host_paths['HKCU']
  endif
  if empty(g:python_host_path)
    unlet g:python_host_path
  else
    call pywin#util#add_path(g:python_host_path)
    call pywin#util#add_path(g:python_host_path . 'Scripts')
  endif
endfunction

function! s:assign_python3_host_path() abort
  if g:pywin#prefer_local_machine
    let g:python3_host_path = empty(s:python3_host_paths['HKLM'])
          \ ? empty(s:python3_host_paths['HKCU'])
          \   ? get(g:, 'python3_host_path', '')
          \   : s:python3_host_paths['HKCU']
          \ : s:python3_host_paths['HKLM']
  else
    let g:python3_host_path = empty(s:python3_host_paths['HKCU'])
          \ ? empty(s:python3_host_paths['HKLM'])
          \   ? get(g:, 'python3_host_path', '')
          \   : s:python3_host_paths['HKLM']
          \ : s:python3_host_paths['HKCU']
  endif
  if empty(g:python3_host_path)
    unlet g:python3_host_path
  else
    call pywin#util#add_path(g:python3_host_path)
    call pywin#util#add_path(g:python3_host_path . 'Scripts')
  endif
endfunction


" Configure ------------------------------------------------------------------
let g:pywin#check_current_user = get(g:, 'pywin#check_current_user', 1)
let g:pywin#check_local_machine = get(g:, 'pywin#check_local_machine', 1)
let g:pywin#prefer_local_machine = get(g:, 'pywin#prefer_local_machine', 0)
