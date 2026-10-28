set background=dark
let g:colors_name = 'mono'

let s:fg   = 'guifg=#e6e6e6 ctermfg=7'
let s:dim  = 'guifg=#7a7a7a ctermfg=8'
let s:strong = 'guifg=#ffffff ctermfg=15'
let s:bg   = 'guibg=#000000 ctermbg=0'
let s:lbg  = 'guibg=#141414 ctermbg=0'
let s:mbg  = 'guibg=#1a1a1a ctermbg=0'
let s:sel  = 'guibg=#2f2f2f ctermbg=8'
let s:inv  = 'guifg=#000000 guibg=#e6e6e6 ctermfg=0 ctermbg=7'

execute 'hi Normal        ' . s:fg . ' ' . s:bg
execute 'hi NormalNC      ' . s:fg . ' ' . s:bg
execute 'hi NormalFloat   ' . s:fg . ' ' . s:mbg
execute 'hi FloatBorder   ' . s:dim . ' ' . s:mbg
execute 'hi Cursor        ' . s:inv
execute 'hi TermCursor    ' . s:inv
execute 'hi CursorLine    ' . s:fg . ' ' . s:lbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi CursorColumn  ' . s:fg . ' ' . s:lbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi ColorColumn   ' . s:fg . ' ' . s:lbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi CursorLineNr  ' . s:fg . ' gui=bold cterm=bold'
execute 'hi LineNr        ' . s:dim
execute 'hi SignColumn    ' . s:dim . ' ' . s:bg
execute 'hi FoldColumn    ' . s:dim . ' ' . s:bg
execute 'hi NonText       ' . s:dim
execute 'hi SpecialKey    ' . s:dim
execute 'hi Whitespace    ' . s:dim
execute 'hi Conceal       ' . s:dim . ' ' . s:bg
execute 'hi EndOfBuffer   ' . s:fg . ' ' . s:bg

execute 'hi Visual        ' . s:fg . ' ' . s:sel . ' term=NONE gui=NONE cterm=NONE'
execute 'hi VisualNOS     ' . s:fg . ' ' . s:sel . ' term=NONE gui=NONE cterm=NONE'
execute 'hi Search        ' . s:inv . ' gui=bold cterm=bold'
execute 'hi IncSearch     ' . s:inv . ' gui=bold cterm=bold'
execute 'hi CurSearch     ' . s:inv . ' gui=bold cterm=bold'
execute 'hi Substitute    ' . s:fg . ' ' . s:mbg . ' gui=bold'

execute 'hi StatusLine    ' . s:fg . ' ' . s:lbg . ' gui=bold cterm=bold'
execute 'hi StatusLineNC  ' . s:dim . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi StatusLineTerm   ' . s:fg . ' ' . s:lbg . ' gui=bold cterm=bold'
execute 'hi StatusLineTermNC ' . s:dim . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi TabLine       ' . s:dim . ' ' . s:mbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi TabLineFill   ' . s:dim . ' ' . s:mbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi TabLineSel    ' . s:fg . ' ' . s:bg . ' gui=bold cterm=bold'
execute 'hi WinSeparator  ' . s:dim . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi VertSplit     ' . s:dim . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'

execute 'hi Pmenu         ' . s:fg . ' ' . s:lbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi PmenuSel      ' . s:inv . ' gui=bold cterm=bold'
execute 'hi PmenuSbar     ' . s:dim . ' ' . s:mbg
execute 'hi PmenuThumb    ' . s:fg . ' ' . s:sel
execute 'hi PmenuKind     ' . s:dim
execute 'hi PmenuExtra    ' . s:dim
execute 'hi PmenuShadow   ' . s:dim . ' ' . s:mbg
execute 'hi WildMenu      ' . s:fg . ' ' . s:mbg . ' gui=bold cterm=bold'
execute 'hi ModeMsg       ' . s:fg . ' ' . s:bg . ' gui=bold'
execute 'hi MsgArea       ' . s:fg . ' ' . s:bg
execute 'hi MsgSeparator  ' . s:fg . ' ' . s:bg

execute 'hi MatchParen    ' . s:strong . ' ' . s:sel . ' gui=bold cterm=bold'
execute 'hi MoreMsg       ' . s:fg . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi Question      ' . s:fg . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi WarningMsg    ' . s:strong . ' ' . s:bg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi ErrorMsg      ' . s:strong . ' ' . s:bg . ' gui=bold cterm=bold'

execute 'hi DiffAdd       ' . s:fg . ' guibg=#161616 ctermbg=0 term=NONE gui=NONE cterm=NONE'
execute 'hi DiffChange    ' . s:fg . ' guibg=#262626 ctermbg=8 term=NONE gui=NONE cterm=NONE'
execute 'hi DiffDelete    ' . s:fg . ' guibg=#303030 ctermbg=8 term=NONE gui=NONE cterm=NONE'
execute 'hi DiffText      ' . s:strong . ' ' . s:sel . ' gui=bold cterm=bold'
execute 'hi diffAdded     ' . s:strong
execute 'hi diffChanged   ' . s:strong
execute 'hi diffRemoved   ' . s:strong
execute 'hi diffOldFile   ' . s:dim
execute 'hi diffNewFile   ' . s:strong
execute 'hi diffFile      ' . s:strong
execute 'hi diffLine      ' . s:strong

execute 'hi SignColumnSB  ' . s:dim . ' ' . s:bg
execute 'hi Folded        ' . s:dim . ' ' . s:lbg . ' term=NONE gui=NONE cterm=NONE'
execute 'hi LspCodeLens   ' . s:dim
execute 'hi LspInfoBorder ' . s:dim . ' ' . s:bg
execute 'hi LspReferenceText ' . s:fg . ' ' . s:mbg
execute 'hi LspReferenceRead ' . s:fg . ' ' . s:mbg
execute 'hi LspInlayHint  ' . s:dim . ' gui=italic'
execute 'hi LspSignatureActiveParameter ' . s:fg . ' gui=bold'

execute 'hi Directory     ' . s:fg . ' ' . s:bg . ' gui=bold cterm=bold'
execute 'hi Title         ' . s:fg . ' ' . s:bg . ' gui=bold cterm=bold'
execute 'hi Added         ' . s:strong . ' ' . s:bg
execute 'hi Changed       ' . s:strong . ' ' . s:bg
execute 'hi Removed       ' . s:strong . ' ' . s:bg
execute 'hi SpellBad      term=NONE guisp=#8a8a8a guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline'
execute 'hi SpellCap      term=NONE guisp=#8a8a8a guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline'
execute 'hi SpellRare     term=NONE guisp=#8a8a8a guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline'
execute 'hi SpellLocal    term=NONE guisp=#8a8a8a guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline'
execute 'hi OkMsg         ' . s:fg . ' ' . s:bg
execute 'hi ComplMatchIns ' . s:fg . ' ' . s:bg

runtime! colors/mono_syntax.vim
