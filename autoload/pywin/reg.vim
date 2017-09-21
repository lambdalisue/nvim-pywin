function! pywin#reg#find_install_paths(root, callback) abort
  let query = printf('%s\Software\Python\PythonCore', a:root)
  let args = [
        \ 'reg', 'query', query,
        \ '/s', '/e', '/k', '/ve',
        \ '/f', 'InstallPath',
        \]
  return pywin#process#start(args, {
        \ 'on_exit': function('s:on_exit', [a:callback])
        \})
endfunction


" Private -------------------------------------------------------------------
function! s:on_exit(callback, job, msg, event) abort dict
  if a:msg != 0
    call a:callback([])
  else
    call a:callback(s:parse_result(self.stdout))
  endif
endfunction

function! s:parse_result(result) abort
  let text = join(a:result, "\n")
  let pattern = join([
        \ '\%(^\|\r\n\)',
        \ '\%(HKEY_CURRENT_USER\|HKEY_LOCAL_MACHINE\)',
        \ '\\Software\\Python\\PythonCore\\\(.\{-}\)\\InstallPath',
        \ '\r\n',
        \ '.\{-}REG_SZ\s\+\(.\{-}\)',
        \ '\%(\r\n\|$\)'
        \], '')
  let records = []
  let cursor = match(text, pattern)
  while cursor != -1
    call add(records, matchlist(text, pattern, cursor)[1:2])
    let cursor = match(text, pattern, cursor + 1)
  endwhile
  return records
endfunction
