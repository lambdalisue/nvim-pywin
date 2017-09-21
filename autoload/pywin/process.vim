function! pywin#process#start(args, ...) abort
  let process = extend(a:0 ? a:1 : {}, {
        \ 'stdout': [''],
        \ 'stderr': [''],
        \ 'on_stdout': function('s:on_stdout'),
        \ 'on_stderr': function('s:on_stderr'),
        \})
  let process.job = jobstart(a:args, process)
  return process
endfunction

" function! pywin#process#stop(process) abort
"   return jobstop(a:process.job)
" endfunction
"
" function! pywin#process#send(process, data) abort
"   return jobsend(a:process.job, a:data)
" endfunction
"
" function! pywin#process#wait(process, ...) abort
"   if a:0
"     return jobwait([a:process.job], a:1)
"   else
"     return jobwait([a:process.job])
"   endif
" endfunction


" Private --------------------------------------------------------------------
function! s:on_stdout(job, msg, event) abort dict
  let leading = get(self.stdout, -1, '')
  silent! call remove(self.stdout, -1)
  call extend(self.stdout, [leading . get(a:msg, 0, '')] + a:msg[1:])
endfunction

function! s:on_stderr(job, msg, event) abort dict
  let leading = get(self.stderr, -1, '')
  silent! call remove(self.stderr, -1)
  call extend(self.stderr, [leading . get(a:msg, 0, '')] + a:msg[1:])
endfunction
