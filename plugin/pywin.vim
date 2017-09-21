if exists('g:pywin_loaded') || !has('nvim') || !(has('win32') || has('win64'))
  finish
endif
let g:pywin_loaded = 1


if get(g:, 'pywin_startup', 1)
  call pywin#assign()
endif
