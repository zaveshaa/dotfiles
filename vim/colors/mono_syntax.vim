function! s:mono(groups, attrs) abort
  for l:g in a:groups
    execute 'hi clear ' . l:g
    execute 'hi ' . l:g . ' ' . a:attrs
  endfor
endfunction

call s:mono(['Comment', 'SpecialComment'], 'guifg=#7a7a7a ctermfg=8')

call s:mono([
      \ 'Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword',
      \ 'Exception', 'PreCondit', 'Include', 'Define', 'Macro',
      \ ], 'gui=bold cterm=bold guifg=#ffffff ctermfg=15')

call s:mono([
      \ 'Type', 'StorageClass', 'Structure', 'Typedef', 'PreProc',
      \ ], 'gui=NONE cterm=NONE guifg=#d0d0d0 ctermfg=7')

call s:mono([
      \ 'Constant', 'Boolean',
      \ ], 'gui=NONE cterm=NONE guifg=#b0b0b0 ctermfg=7')
call s:mono([
      \ 'String', 'Character',
      \ ], 'gui=NONE cterm=NONE guifg=#9a9a9a ctermfg=7')
call s:mono([
      \ 'Number', 'Float',
      \ ], 'gui=NONE cterm=NONE guifg=#b0b0b0 ctermfg=7')

call s:mono(['Function', 'FunctionKey'], 'gui=bold cterm=bold guifg=#e6e6e6 ctermfg=7')
call s:mono(['Identifier', 'Underlined'], 'gui=NONE cterm=NONE guifg=#c0c0c0 ctermfg=7')

call s:mono(['Special', 'SpecialChar', 'Debug'], 'guifg=#8a8a8a ctermfg=8')

call s:mono(['Todo', 'Error'], 'gui=bold cterm=bold guifg=#ffffff ctermfg=15')

delfunction s:mono
