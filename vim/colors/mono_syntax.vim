function! s:mono(groups, attrs) abort
  for l:g in a:groups
    execute 'hi clear ' . l:g
    execute 'hi ' . l:g . ' ' . a:attrs
  endfor
endfunction

call s:mono(['Comment', 'SpecialComment'], 'guifg=#6e6e6e ctermfg=8')

call s:mono([
      \ 'Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword',
      \ 'Exception', 'PreCondit', 'Include', 'Define', 'Macro',
      \ ], 'gui=bold cterm=bold guifg=#000000 ctermfg=0')

call s:mono([
      \ 'Type', 'StorageClass', 'Structure', 'Typedef', 'PreProc',
      \ ], 'gui=NONE cterm=NONE guifg=#1f1f1f ctermfg=0')

call s:mono([
      \ 'Constant', 'Boolean',
      \ ], 'gui=NONE cterm=NONE guifg=#2e2e2e ctermfg=0')
call s:mono([
      \ 'String', 'Character',
      \ ], 'gui=NONE cterm=NONE guifg=#4a4a4a ctermfg=0')
call s:mono([
      \ 'Number', 'Float',
      \ ], 'gui=NONE cterm=NONE guifg=#2e2e2e ctermfg=0')

call s:mono(['Function', 'FunctionKey'], 'gui=bold cterm=bold guifg=#111111 ctermfg=0')
call s:mono(['Identifier', 'Underlined'], 'gui=NONE cterm=NONE guifg=#333333 ctermfg=0')

call s:mono(['Special', 'SpecialChar', 'Debug'], 'guifg=#6e6e6e ctermfg=8')

call s:mono(['Todo', 'Error'], 'gui=bold cterm=bold guifg=#000000 ctermfg=0')

delfunction s:mono
