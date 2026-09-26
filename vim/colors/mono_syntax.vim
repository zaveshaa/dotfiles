" mono_syntax.vim — только подсветка синтаксиса для темы mono.
" Подключается дважды: из colors/mono.vim и из after/syntax/syncolor.vim,
" иначе стандартные цвета vim (Brown, SeaGreen, ...) их перебивают — см. :h syncolor.
" Никаких :set background / :colorscheme здесь быть не должно.
"
" Блеклая палитра (низконасыщенные тона), белый фон:
"   #6b76c4 ключевые слова (бледно-сиреневый)
"   #4e9c90 типы (бледно-бирюзовый)
"   #9a6ac0 числа (#9a6ac0), #c2843f строки, #4189c4 функции
"   #67717c переменные
"   #9aa4ab комментарии
"
" Группы сначала очищаем: :hi с одними атрибутами не сбрасывает заданный цвет.

function! s:mono(groups, attrs) abort
  for l:g in a:groups
    execute 'hi clear ' . l:g
    execute 'hi ' . l:g . ' ' . a:attrs
  endfor
endfunction

" 1) комментарии — самый светлый тон
call s:mono(['Comment', 'SpecialComment'], 'guifg=#9aa4ab ctermfg=8')

" 2) ключевые слова и управляющие конструкции — бледно-сиреневые
call s:mono([
      \ 'Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword',
      \ 'Exception', 'PreCondit', 'Include', 'Define', 'Macro',
      \ ], 'gui=NONE cterm=NONE guifg=#6b76c4 ctermfg=5')

" 3) типы и классы — бледно-бирюзовые
call s:mono([
      \ 'Type', 'StorageClass', 'Structure', 'Typedef', 'PreProc',
      \ ], 'gui=NONE cterm=NONE guifg=#4e9c90 ctermfg=6')

" 4) строки — охра, числа и константы — бледно-фиолетовые
call s:mono([
      \ 'Constant', 'Boolean',
      \ ], 'gui=NONE cterm=NONE guifg=#9a6ac0 ctermfg=13')
call s:mono([
      \ 'String', 'Character',
      \ ], 'gui=NONE cterm=NONE guifg=#c2843f ctermfg=3')
call s:mono([
      \ 'Number', 'Float',
      \ ], 'gui=NONE cterm=NONE guifg=#9a6ac0 ctermfg=13')

" 5) функции — бледно-голубые, идентификаторы — серо-синие
call s:mono(['Function', 'FunctionKey'], 'gui=NONE cterm=NONE guifg=#4189c4 ctermfg=4')
call s:mono(['Identifier', 'Underlined'], 'gui=NONE cterm=NONE guifg=#67717c ctermfg=12')

" 6) скобки, спецсимволы, отладка — серо-сиреневые
call s:mono(['Special', 'SpecialChar', 'Debug'], 'guifg=#80879d ctermfg=7')

" 7) Todo и Error — тёплый оранжевый, самое заметное
call s:mono(['Todo', 'Error'], 'gui=NONE cterm=NONE guifg=#c9822f ctermfg=3')

delfunction s:mono
