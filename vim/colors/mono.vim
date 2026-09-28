set background=light

let s:fg   = 'guifg=#1a1a1a'
let s:dim  = 'guifg=#8c8c8c ctermfg=12'
let s:strong = 'guifg=#3d3d3d'
let s:bg   = 'guibg=#ffffff'
let s:lbg  = 'guibg=#f0f0f0 ctermbg=15'
let s:mbg  = 'guibg=#ededed ctermbg=15'
let s:sel  = 'guibg=#dcdcdc ctermbg=14'
let s:inv  = 'guifg=#ffffff guibg=#000000 ctermfg=15 ctermbg=0'

execute 'hi Normal        ' . s:fg . ' ' . s:bg . ' ctermfg=1 ctermbg=15'
execute 'hi NormalNC      ' . s:fg . ' ' . s:bg
execute 'hi NormalFloat   ' . s:fg . ' ' . s:mbg
execute 'hi FloatBorder   ' . s:fg . ' ' . s:mbg
execute 'hi Cursor        ' . s:inv
execute 'hi TermCursor    ' . s:inv
execute 'hi CursorLine    ' . s:fg . ' ' . s:lbg
execute 'hi CursorColumn  ' . s:fg . ' ' . s:lbg
execute 'hi ColorColumn   ' . s:fg . ' ' . s:lbg
execute 'hi CursorLineNr  ' . s:fg . ' gui=bold cterm=bold'
execute 'hi LineNr        ' . s:dim
execute 'hi SignColumn    ' . s:dim . ' ' . s:bg
execute 'hi FoldColumn    ' . s:dim . ' ' . s:bg
execute 'hi NonText       ' . s:dim
execute 'hi SpecialKey    ' . s:dim
execute 'hi Whitespace    ' . s:dim
execute 'hi Conceal       ' . s:dim
execute 'hi EndOfBuffer   ' . s:fg . ' ' . s:bg

execute 'hi Visual        ' . s:fg . ' ' . s:sel
execute 'hi VisualNOS     ' . s:fg . ' ' . s:sel
execute 'hi Search        ' . s:fg . ' ' . s:mbg . ' gui=bold'
execute 'hi IncSearch     ' . s:inv . ' gui=bold cterm=bold'
execute 'hi CurSearch     ' . s:inv . ' gui=bold cterm=bold'
execute 'hi Substitute    ' . s:fg . ' ' . s:mbg . ' gui=bold'

execute 'hi StatusLine    ' . s:fg . ' ' . s:lbg . ' gui=bold cterm=bold'
execute 'hi StatusLineNC  ' . s:dim . ' ' . s:bg
execute 'hi TabLine       ' . s:dim . ' ' . s:mbg
execute 'hi TabLineFill   ' . s:dim . ' ' . s:mbg
execute 'hi TabLineSel    ' . s:fg . ' ' . s:bg . ' gui=bold cterm=bold'
execute 'hi WinSeparator  ' . s:dim . ' ' . s:bg
execute 'hi VertSplit     ' . s:dim . ' ' . s:bg

execute 'hi Pmenu         ' . s:fg . ' ' . s:lbg
execute 'hi PmenuSel      ' . s:inv . ' gui=bold cterm=bold'
execute 'hi PmenuSbar     ' . s:dim . ' ' . s:mbg
execute 'hi PmenuThumb    ' . s:fg . ' ' . s:sel
execute 'hi PmenuKind     ' . s:dim
execute 'hi PmenuExtra    ' . s:dim
execute 'hi WildMenu      ' . s:fg . ' ' . s:mbg . ' gui=bold'
execute 'hi ModeMsg       ' . s:fg . ' ' . s:bg . ' gui=bold'
execute 'hi MsgArea       ' . s:fg . ' ' . s:bg
execute 'hi MsgSeparator  ' . s:fg . ' ' . s:bg

execute 'hi MatchParen    gui=bold cterm=bold'
execute 'hi MoreMsg       ' . s:fg
execute 'hi QuestionMsg   ' . s:fg
execute 'hi WarningMsg    ' . s:strong
execute 'hi ErrorMsg      ' . s:strong . ' gui=bold cterm=bold'

execute 'hi DiffAdd       ' . s:fg . ' guibg=#eaeaea ctermbg=15'
execute 'hi DiffChange    ' . s:fg . ' guibg=#dcdcdc ctermbg=14'
execute 'hi DiffDelete    ' . s:fg . ' guibg=#d0d0d0 ctermbg=14'
execute 'hi diffAdded     ' . s:strong
execute 'hi diffChanged   ' . s:strong
execute 'hi diffRemoved   ' . s:strong
execute 'hi diffOldFile   ' . s:dim
execute 'hi diffNewFile   ' . s:strong
execute 'hi diffFile      ' . s:strong
execute 'hi diffLine      ' . s:strong

execute 'hi SignColumnSB  ' . s:dim . ' ' . s:bg
execute 'hi Folded        ' . s:dim . ' ' . s:lbg
execute 'hi LspCodeLens   ' . s:dim
execute 'hi LspInfoBorder ' . s:dim . ' ' . s:bg
execute 'hi LspReferenceText ' . s:fg . ' ' . s:mbg
execute 'hi LspReferenceRead ' . s:fg . ' ' . s:mbg
execute 'hi LspInlayHint  ' . s:dim . ' gui=italic'
execute 'hi LspSignatureActiveParameter ' . s:fg . ' gui=bold'

runtime! colors/mono_syntax.vim
