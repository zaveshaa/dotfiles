function! s:mono(groups, attrs) abort
  for l:g in a:groups
    execute 'hi clear ' . l:g
    execute 'hi ' . l:g . ' ' . a:attrs
  endfor
endfunction

call s:mono(['Comment', 'SpecialComment'], 'guifg=#9aa4ab ctermfg=8')

call s:mono([
      \ 'Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword',
      \ 'Exception', 'PreCondit', 'Include', 'Define', 'Macro',
      \ ], 'gui=NONE cterm=NONE guifg=#6b76c4 ctermfg=5')

call s:mono([
      \ 'Type', 'StorageClass', 'Structure', 'Typedef', 'PreProc',
      \ ], 'gui=NONE cterm=NONE guifg=#4e9c90 ctermfg=6')

call s:mono([
      \ 'Constant', 'Boolean',
      \ ], 'gui=NONE cterm=NONE guifg=#9a6ac0 ctermfg=13')
call s:mono([
      \ 'String', 'Character',
      \ ], 'gui=NONE cterm=NONE guifg=#c2843f ctermfg=3')
call s:mono([
      \ 'Number', 'Float',
      \ ], 'gui=NONE cterm=NONE guifg=#9a6ac0 ctermfg=13')

call s:mono(['Function', 'FunctionKey'], 'gui=NONE cterm=NONE guifg=#4189c4 ctermfg=4')
call s:mono(['Identifier', 'Underlined'], 'gui=NONE cterm=NONE guifg=#67717c ctermfg=12')

call s:mono(['Special', 'SpecialChar', 'Debug'], 'guifg=#80879d ctermfg=7')

call s:mono(['Todo', 'Error'], 'gui=NONE cterm=NONE guifg=#c9822f ctermfg=3')

delfunction s:mono
