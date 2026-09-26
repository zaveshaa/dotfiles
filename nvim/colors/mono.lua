-- mono.lua — светлая тема для Neovim с блеклыми (приглушёнными) цветами.
-- Белый фон, интерфейс почти серый, синтаксис — мягкие тона:
-- насыщенность низкая, светлота высокая. Видно, но не «кричит».
-- Стилей нет: ни жирного, ни подчёркивания, только цвет.

local M = {}

-- ---------------------------------------------------------------------------
-- палитра
-- ---------------------------------------------------------------------------
local p = {
  fg = "#1a1a1a", -- основной текст
  bg = "#ffffff", -- фон
  strong = "#3d3d3d", -- усиленный текст
  mid = "#5f5f5f", -- средний серый (переменные, поля)
  soft = "#767676", -- мягкий серый (знаки, пунктуация)
  dim = "#9a9a9a", -- приглушённый текст (комментарии)
  faint = "#b3b3b3", -- совсем приглушённый (нетекстовые символы)
  line = "#f0f0f0", -- фон строк (CursorLine, StatusLine)
  sel = "#dcdcdc", -- выделение
  sel2 = "#c9c9c9", -- выделение/акцент посильнее
  white = "#ffffff",
  black = "#000000",
}

-- серая шкала: к ней притягиваются серые цвета (см. M.snap)
local steps = {
  "#0f0f0f",
  "#1a1a1a",
  "#3d3d3d",
  "#5f5f5f",
  "#767676",
  "#8c8c8c",
  "#9a9a9a",
  "#adadad",
  "#b3b3b3",
  "#c9c9c9",
  "#d0d0d0",
  "#dcdcdc",
  "#e0e0e0",
  "#e5e5e5",
  "#eaeaea",
  "#ededed",
  "#f0f0f0",
  "#ffffff",
}

local function rgb(hex)
  local n = tonumber(hex:gsub("#", ""), 16)
  return bit.band(bit.rshift(n, 16), 0xff), bit.band(bit.rshift(n, 8), 0xff), bit.band(n, 0xff)
end

local function hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function gray(hexstr)
  local r, g, b = rgb(hexstr)
  local v = math.floor(0.299 * r + 0.587 * g + 0.114 * b + 0.5)
  return hex(v, v, v)
end

local function luma(hexstr)
  local r, g, b = rgb(hexstr)
  return 0.299 * r + 0.587 * g + 0.114 * b
end

--- привести цвет к блеклому: сохраняем оттенок, гасим насыщенность,
--- светлоту держим в мягком диапазоне. Идемпотентна: повторный вызов
--- ничего не меняет, поэтому M.clamp можно звать сколько угодно раз.
---@param hexstr string|nil
---@param light boolean|nil true — только светлые тона (для фона)
---@return string|nil
function M.snap(hexstr, light)
  if type(hexstr) ~= "string" or not hexstr:match("^#%x%x%x%x%x%x$") then
    return hexstr
  end

  local r, g, b = rgb(hexstr)
  r, g, b = r / 255, g / 255, b / 255
  local mx, mn = math.max(r, g, b), math.min(r, g, b)
  local sat = mx - mn
  local l = (mx + mn) / 2

  -- чисто серый — оставляем серым, притягивая к серой шкале по светлоте
  if sat < 0.03 then
    local target = luma(hexstr)
    local best, bestd
    for _, st in ipairs(steps) do
      local sl = luma(st)
      if not light or sl >= 0.8 * 255 then
        local d = math.abs(sl - target)
        if not bestd or d < bestd then
          best, bestd = st, d
        end
      end
    end
    return best
  end

  -- оттенок: сохраняем
  local h
  if mx == mn then
    h = 0
  else
    local d = mx - mn
    if mx == r then
      h = ((g - b) / d) % 6
    elseif mx == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  -- насыщенность и светлота: зажимаем в фиксированный «блеклый» диапазон
  -- S нормируем через L, иначе обратное преобразование «плывёт» по кругу
  local ll = light and math.max(0.92, math.min(1, l)) or math.max(0.44, math.min(0.70, l))
  local range = 1 - math.abs(2 * ll - 1)
  local hslSat = range > 0.001 and (sat / range) or 0
  local maxSat = light and 0.10 or 0.20
  local s = math.min(hslSat, maxSat)

  -- HSL -> RGB
  local function hue2rgb(p1, p2, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p1 + (p2 - p1) * 6 * t
    end
    if t < 1 / 2 then
      return p2
    end
    if t < 2 / 3 then
      return p1 + (p2 - p1) * (2 / 3 - t) * 6
    end
    return p1
  end

  local q
  if ll < 0.5 then
    q = ll * (1 + s)
  else
    q = ll + s - ll * s
  end
  local pp = 2 * ll - q
  return hex(
    math.floor(hue2rgb(pp, q, h + 1 / 3) * 255 + 0.5),
    math.floor(hue2rgb(pp, q, h) * 255 + 0.5),
    math.floor(hue2rgb(pp, q, h - 1 / 3) * 255 + 0.5)
  )
end

-- ---------------------------------------------------------------------------
-- хелперы
-- ---------------------------------------------------------------------------
local function hl(group, value)
  vim.api.nvim_set_hl(0, group, value)
end

--- очистить группы и задать заново
local function only(groups, value)
  for _, g in ipairs(groups) do
    hl(g, {})
  end
  if value then
    for _, g in ipairs(groups) do
      hl(g, vim.tbl_extend("force", value, { default = false }))
    end
  end
end

--- перекрасить существующие группы в заданный цвет
local function flat(groups, fg)
  for _, g in ipairs(groups) do
    if vim.fn.hlexists(g) == 1 then
      local cur = vim.api.nvim_get_hl(0, { name = g })
      local st = { fg = fg, bold = cur.bold or nil, italic = cur.italic or nil, underline = cur.underline or nil }
      if cur.sp then
        st.sp = type(cur.sp) == "table" and cur.sp[1] or cur.sp
      end
      st.cterm = cur.cterm
      hl(g, st)
    end
  end
end

-- ---------------------------------------------------------------------------
-- интерфейс
-- ---------------------------------------------------------------------------
local function base()
  vim.g.colors_name = "mono"
  vim.opt.background = "light"

  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalNC", { fg = p.fg, bg = p.bg })
  hl("NormalFloat", { fg = p.fg, bg = p.bg })
  hl("FloatBorder", { fg = p.dim, bg = p.bg })
  hl("FloatTitle", { fg = p.fg, bg = p.line, bold = true })
  hl("Cursor", { fg = p.bg, bg = p.black })
  hl("lCursor", { fg = p.bg, bg = p.black })
  hl("TermCursor", { fg = p.bg, bg = p.black })
  hl("TermCursorNC", { fg = p.bg, bg = p.dim })
  hl("CursorLine", { bg = p.line })
  hl("CursorColumn", { bg = p.line })
  hl("ColorColumn", { bg = p.line })
  hl("CursorLineNr", { fg = p.fg, bold = true })
  hl("CursorLineSign", { bg = p.line })
  hl("CursorLineFold", { bg = p.line })
  hl("LineNr", { fg = p.dim })
  hl("SignColumn", { fg = p.dim, bg = p.bg })
  hl("FoldColumn", { fg = p.dim, bg = p.bg })
  hl("Folded", { fg = p.dim, bg = p.line })
  hl("EndOfBuffer", { fg = p.bg, bg = p.bg })
  hl("Conceal", { fg = p.dim })
  hl("NonText", { fg = p.faint })
  hl("SpecialKey", { fg = p.dim })
  hl("Whitespace", { fg = p.faint })
  hl("WinSeparator", { fg = p.sel2, bg = p.bg })
  hl("VertSplit", { fg = p.sel2, bg = p.bg })
  hl("WinBar", { fg = p.fg, bg = p.line, bold = true })
  hl("WinBarNC", { fg = p.dim, bg = p.bg })
  hl("StatusLine", { fg = p.fg, bg = p.line, bold = true })
  hl("StatusLineNC", { fg = p.dim, bg = p.bg })
  hl("TabLine", { fg = p.dim, bg = p.bg })
  hl("TabLineFill", { bg = p.bg })
  hl("TabLineSel", { fg = p.fg, bg = p.line, bold = true })

  hl("Visual", { bg = p.sel })
  hl("VisualNOS", { bg = p.sel })
  hl("Search", { fg = p.fg, bg = p.bg, bold = true })
  hl("IncSearch", { fg = p.bg, bg = p.black, bold = true })
  hl("CurSearch", { fg = p.bg, bg = p.black, bold = true })
  hl("Substitute", { fg = p.fg, bg = p.sel, bold = true })

  hl("Pmenu", { fg = p.fg, bg = p.line })
  hl("PmenuSel", { fg = p.bg, bg = p.black, bold = true })
  hl("PmenuSbar", { bg = p.bg })
  hl("PmenuThumb", { bg = p.sel2 })
  hl("PmenuKind", { fg = p.dim })
  hl("PmenuExtra", { fg = p.dim })
  hl("PmenuMatch", { fg = p.fg, bold = true })
  hl("PmenuMatchSel", { fg = p.bg, bg = p.black, bold = true })
  hl("WildMenu", { fg = p.fg, bg = p.line, bold = true })
  hl("ModeMsg", { fg = p.fg, bold = true })
  hl("MsgArea", { fg = p.fg, bg = p.bg })
  hl("MsgSeparator", { bg = p.bg })
  hl("MoreMsg", { fg = p.fg })
  hl("QuestionMsg", { fg = p.fg })
  hl("WarningMsg", { fg = p.strong })
  hl("ErrorMsg", { fg = p.strong, bold = true })
  hl("QuickFixLine", { bg = p.line, bold = true })

  hl("DiffAdd", { bg = "#eeeeee" })
  hl("DiffChange", { bg = p.sel })
  hl("DiffDelete", { bg = p.sel2 })
  hl("DiffText", { fg = p.fg, bg = p.sel2, bold = true })
  hl("Added", { fg = p.strong })
  hl("Changed", { fg = p.strong })
  hl("Removed", { fg = p.strong })

  hl("MatchParen", { fg = p.strong, bold = true })
  hl("SpecialKey", { fg = p.dim })
  hl("Title", { fg = p.fg, bold = true })
  hl("Bold", { bold = true })
  hl("Italic", { italic = true })
  hl("Underlined", { underline = true })

  hl("debugPC", { bg = p.line })
  hl("debugBreakpoint", { fg = p.fg, bg = p.sel2 })
  hl("VisualNonText", { fg = p.sel2, bg = p.sel })

  hl("healthError", { bold = true })
  hl("healthWarning", { underline = true })
  hl("healthSuccess", { fg = p.dim })
  hl("healthHelp", { fg = p.dim })
end

-- ---------------------------------------------------------------------------
-- синтаксис
-- ---------------------------------------------------------------------------
-- блеклые тона: насыщенность низкая, светлота высокая, на белом фоне
-- читается, но не «кричит» — только цвет, без жирного и подчёркиваний
local dim = { fg = "#9aa4ab" } -- комментарии, разметка
local soft = { fg = "#8b939a" } -- пунктуация, скобки
local mid = { fg = "#788088" } -- переменные, поля
local var = { fg = "#67717c" } -- параметры, обычные имена
local key = { fg = "#6b76c4" } -- ключевые слова — бледно-сиреневый
local type_ = { fg = "#4e9c90" } -- типы, классы — бледно-бирюзовый
local str = { fg = "#c2843f" } -- строки — бледно-охра
local num = { fg = "#9a6ac0" } -- числа, константы — бледно-фиолетовый
local fn = { fg = "#4189c4" } -- функции — бледно-голубой
local deco = { fg = "#c67fa4" } -- декораторы, аннотации
local ctrl = { fg = "#6f79cc" } -- управляющие конструкции
local strong = { fg = p.strong } -- общий «посветлее основного»
local under = { fg = p.fg, underline = true } -- не используется

local function syntax()
  -- выкидываем всё, что нарисовала предыдущая тема
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    if name:sub(1, 1) == "@" then
      hl(name, {})
    end
  end
  only({
    "Comment",
    "Constant",
    "String",
    "Character",
    "Number",
    "Boolean",
    "Float",
    "Identifier",
    "Function",
    "Statement",
    "Conditional",
    "Repeat",
    "Label",
    "Operator",
    "Keyword",
    "Exception",
    "PreProc",
    "Include",
    "Define",
    "Macro",
    "PreCondit",
    "Type",
    "StorageClass",
    "Structure",
    "Typedef",
    "Special",
    "SpecialChar",
    "SpecialComment",
    "Debug",
    "Todo",
    "Error",
  })

  -- 1) комментарии и разметка
  only({
    "@comment",
    "@comment.documentation",
    "@comment.note",
    "@comment.todo",
    "@comment.error",
    "@comment.warning",
    "@markup.quote",
    "@markup.raw",
    "@markup.raw.block",
    "@markup.italic",
    "@markup.list",
    "@markup.list.checked",
    "@markup.list.unchecked",
    "@label.guid",
    "@embedded",
  }, dim)
  only({
    "@punctuation.delimiter",
    "@punctuation.special",
    "@punctuation.bracket",
    "@punctuation.definition",
  }, soft)
  only({
    "@variable",
    "@variable.builtin",
    "@variable.member",
    "@variable.parameter",
    "@variable.parameter.builtin",
    "@field",
    "@property",
    "@module",
    "@module.builtin",
    "@namespace",
    "@parameter",
    "@parameter.reference",
    "@none",
  }, mid)
  hl("@comment.todo", { fg = "#c9822f" })
  hl("@comment.error", { fg = "#c95f5f" })
  hl("@comment.warning", { fg = "#c9a03c" })

  -- 2a) ключевые слова и управляющие конструкции
  only({
    "@keyword",
    "@keyword.conditional",
    "@keyword.repeat",
    "@keyword.return",
    "@keyword.exception",
    "@keyword.function",
    "@keyword.import",
    "@keyword.directive",
    "@keyword.directive.define",
    "@keyword.coroutine",
    "@markup.strong",
  }, key)
  only({
    "@keyword.operator",
    "@keyword.modifier",
    "@operator",
    "@preproc",
    "@include",
    "@define",
    "@debug",
  }, ctrl)
  -- 2b) типы, классы, структуры
  only({
    "@type",
    "@type.builtin",
    "@type.definition",
    "@type.qualifier",
    "@constructor",
  }, type_)
  only({
    "@attribute",
    "@label.guid",
  }, deco)
  -- 2c) строки
  only({
    "@string",
    "@string.special",
    "@character",
  }, str)
  hl("@string.escape", { fg = "#c9822f" })
  -- 2d) числа, константы, логические значения
  only({
    "@constant",
    "@constant.builtin",
    "@constant.macro",
    "@number",
    "@number.float",
    "@boolean",
  }, num)

  -- 3) функции и ссылки
  only({
    "@function",
    "@function.builtin",
    "@function.call",
    "@function.macro",
    "@function.method",
    "@function.method.call",
    "@function.builtin.builtin",
    "@method",
    "@constructor.lua",
    "@markup.link.label",
    "@markup.link.url",
    "@string.special.url",
    "@tag",
    "@tag.attribute",
    "@tag.delimiter",
  }, fn)

  -- всё, что мы не перечислили, остаётся пустым и рисуется как обычный текст

  -- классический syntax (для встроенного vim syntax) — те же блеклые тона
  hl("Comment", dim)
  hl("SpecialComment", dim)
  hl("String", str)
  hl("Character", str)
  hl("Constant", num)
  hl("Number", num)
  hl("Float", num)
  hl("Boolean", num)
  hl("Function", fn)
  hl("Identifier", var)
  hl("Statement", key)
  hl("Conditional", key)
  hl("Repeat", key)
  hl("Label", key)
  hl("Exception", key)
  hl("Keyword", key)
  hl("Operator", ctrl)
  hl("PreProc", ctrl)
  hl("Include", ctrl)
  hl("Define", ctrl)
  hl("Macro", num)
  hl("PreCondit", key)
  hl("Type", type_)
  hl("StorageClass", type_)
  hl("Structure", type_)
  hl("Typedef", type_)
  hl("Special", deco)
  hl("SpecialChar", deco)
  hl("Debug", ctrl)
  hl("Todo", { fg = "#c9822f" })
  hl("Error", { fg = "#c95f5f" })
end

-- ---------------------------------------------------------------------------
-- LSP и диагностика
-- ---------------------------------------------------------------------------
local function lsp()
  only({
    "@lsp.type.class",
    "@lsp.type.comment",
    "@lsp.type.decorator",
    "@lsp.type.enum",
    "@lsp.type.enumMember",
    "@lsp.type.event",
    "@lsp.type.function",
    "@lsp.type.interface",
    "@lsp.type.keyword",
    "@lsp.type.macro",
    "@lsp.type.method",
    "@lsp.type.modifier",
    "@lsp.type.namespace",
    "@lsp.type.parameter",
    "@lsp.type.property",
    "@lsp.type.struct",
    "@lsp.type.type",
    "@lsp.type.typeParameter",
    "@lsp.type.variable",
    "@lsp.typemod.class.defaultLibrary",
    "@lsp.typemod.enum.defaultLibrary",
    "@lsp.typemod.enumMember.defaultLibrary",
    "@lsp.typemod.function.defaultLibrary",
    "@lsp.typemod.keyword.async",
    "@lsp.typemod.macro.defaultLibrary",
    "@lsp.typemod.method.defaultLibrary",
    "@lsp.typemod.operator.injected",
    "@lsp.typemod.string.injected",
    "@lsp.typemod.type.defaultLibrary",
    "@lsp.typemod.variable.defaultLibrary",
    "@lsp.typemod.variable.injected",
    "@lsp.typemod.variable.readonly",
  }, dim)
  only({
    "@lsp.type.keyword",
    "@lsp.type.modifier",
    "@lsp.typemod.keyword.async",
  }, key)
  only({
    "@lsp.type.class",
    "@lsp.type.enum",
    "@lsp.type.enumMember",
    "@lsp.type.interface",
    "@lsp.type.struct",
    "@lsp.type.type",
    "@lsp.type.typeParameter",
    "@lsp.type.namespace",
    "@lsp.type.macro",
    "@lsp.typemod.class.defaultLibrary",
    "@lsp.typemod.enum.defaultLibrary",
    "@lsp.typemod.enumMember.defaultLibrary",
    "@lsp.typemod.type.defaultLibrary",
  }, type_)
  only({
    "@lsp.type.function",
    "@lsp.type.method",
    "@lsp.type.event",
    "@lsp.typemod.function.defaultLibrary",
    "@lsp.typemod.method.defaultLibrary",
  }, fn)
  only({
    "@lsp.type.parameter",
    "@lsp.type.property",
    "@lsp.type.variable",
    "@lsp.typemod.variable.defaultLibrary",
    "@lsp.typemod.variable.injected",
    "@lsp.typemod.operator.injected",
    "@lsp.typemod.string.injected",
  }, var)
  only({ "@lsp.type.decorator" }, deco)
  only({
    "@lsp.typemod.function.defaultLibrary",
    "@lsp.typemod.variable.defaultLibrary",
    "@lsp.typemod.variable.readonly",
    "@lsp.mod.deprecated",
    "@lsp.mod.readonly",
  }, { fg = p.dim, strikethrough = false })
  hl("@lsp.mod.deprecated", { fg = p.dim, strikethrough = true })

  -- диагностика
  hl("DiagnosticError", { fg = "#c95f5f" })
  hl("DiagnosticWarn", { fg = "#c9a03c" })
  hl("DiagnosticInfo", { fg = "#5f96c4" })
  hl("DiagnosticHint", { fg = "#6aab6f" })
  hl("DiagnosticOk", { fg = "#6aab6f" })
  for _, g in ipairs({
    "DiagnosticUnnecessary",
    "DiagnosticDeprecated",
    "DiagnosticVirtualTextError",
    "DiagnosticVirtualTextWarn",
    "DiagnosticVirtualTextInfo",
    "DiagnosticVirtualTextHint",
    "DiagnosticVirtualLinesError",
    "DiagnosticVirtualLinesWarn",
    "DiagnosticVirtualLinesInfo",
    "DiagnosticVirtualLinesHint",
    "DiagnosticFloatingError",
    "DiagnosticFloatingWarn",
    "DiagnosticFloatingInfo",
    "DiagnosticFloatingHint",
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
    "DiagnosticSignOk",
    "DiagnosticUnderlineError",
    "DiagnosticUnderlineWarn",
    "DiagnosticUnderlineInfo",
    "DiagnosticUnderlineHint",
    "DiagnosticUnderlineOk",
  }) do
    hl(g, { fg = p.dim, sp = p.dim })
  end
  only({
    "DiagnosticVirtualTextError",
    "DiagnosticVirtualLinesError",
    "DiagnosticFloatingError",
    "DiagnosticSignError",
    "DiagnosticUnderlineError",
  }, { fg = "#c95f5f", sp = "#c95f5f" })
  only({
    "DiagnosticVirtualTextWarn",
    "DiagnosticVirtualLinesWarn",
    "DiagnosticFloatingWarn",
    "DiagnosticSignWarn",
    "DiagnosticUnderlineWarn",
  }, { fg = "#c9a03c", sp = "#c9a03c" })
  for _, g in ipairs({
    "DiagnosticVirtualTextInfo",
    "DiagnosticVirtualLinesInfo",
    "DiagnosticFloatingInfo",
    "DiagnosticSignInfo",
    "DiagnosticUnderlineInfo",
  }) do
    hl(g, { fg = "#5f96c4", sp = "#5f96c4" })
  end
  for _, g in ipairs({
    "DiagnosticVirtualTextHint",
    "DiagnosticVirtualLinesHint",
    "DiagnosticFloatingHint",
    "DiagnosticSignHint",
    "DiagnosticUnderlineHint",
    "DiagnosticVirtualTextOk",
    "DiagnosticVirtualLinesOk",
    "DiagnosticFloatingOk",
    "DiagnosticSignOk",
    "DiagnosticUnderlineOk",
  }) do
    hl(g, { fg = "#6aab6f", sp = "#6aab6f" })
  end
  hl("LspCodeLens", { fg = p.dim })
  hl("LspInlayHint", { fg = p.dim, italic = true })
  hl("LspInfoList", { fg = p.fg })
  hl("LspReferenceText", { bg = p.line })
  hl("LspReferenceRead", { bg = p.line })
  hl("LspSignatureActiveParameter", { fg = "#4e9c90" })
  hl("LspCodeLensSeparator", { fg = p.dim })
  hl("LspInfoBorder", { fg = p.fg, bg = p.bg })
end

-- ---------------------------------------------------------------------------
-- плагины
-- ---------------------------------------------------------------------------
local function plugins()
  flat({
    "NormalSB",
    "SignColumnSB",
    "Folded",
    "CursorLineFold",
    "CursorLineSign",
    "LineNrAbove",
    "LineNrBelow",
    "LineNrAboveCursorLine",
    "LineNrBelowCursorLine",
  }, p.dim)

  -- gitsigns
  only({
    "GitSignsAdd",
    "GitSignsChange",
    "GitSignsDelete",
    "GitSignsUntracked",
  }, { fg = p.strong, bold = true })
  only(
    { "GitSignsAddNr", "GitSignsChangeNr", "GitSignsDeleteNr", "GitSignsUntrackedNr" },
    { fg = p.strong, bold = true }
  )
  flat({ "GitSignsAddLn", "GitSignsChangeLn", "GitSignsDeleteLn", "GitSignsCurrentLineBlame" }, p.dim)

  -- mini.icons красит иконки в цвета — приводим к серому
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    if name:match("^MiniIcons") then
      hl(name, { fg = p.dim })
    end
  end

  -- neo-tree: сначала всё в обычный цвет, потом точечные группы
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    if name:match("^NeoTree") then
      local cur = vim.api.nvim_get_hl(0, { name = name })
      hl(name, {
        fg = p.fg,
        bg = p.bg,
        bold = cur.bold or nil,
        italic = cur.italic or nil,
        underline = cur.underline or nil,
      })
    end
  end
  only({
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeWinSeparator",
    "NeoTreeVertLine",
    "NeoTreeWinNormal",
  }, { fg = p.fg, bg = p.bg })
  only(
    { "NeoTreeEndOfBuffer", "NeoTreeHiddenByName", "NeoTreeFloatBorder", "NeoTreeFloatTitle" },
    { fg = p.bg, bg = p.bg }
  )
  only(
    { "NeoTreeDimText", "NeoTreeDotfile", "NeoTreeHiddenByName", "NeoTreeFileStats", "NeoTreeFilterTerm" },
    { fg = p.dim }
  )
  only({ "NeoTreeDirectoryName", "NeoTreeRootName", "NeoTreeFileIcon", "NeoTreeSymbolicLinkTarget" }, { fg = p.fg })
  only({ "NeoTreeFileName", "NeoTreeIndentMarker", "NeoTreeExpander", "NeoTreeCursorLine" }, { fg = p.fg })
  only({ "NeoTreeFileStatsHeader", "NeoTreeModified" }, { fg = p.strong })
  only({
    "NeoTreeGitAdded",
    "NeoTreeGitConflict",
    "NeoTreeGitDeleted",
    "NeoTreeGitIgnored",
    "NeoTreeGitModified",
    "NeoTreeGitStaged",
    "NeoTreeGitUnstaged",
    "NeoTreeGitUntracked",
  }, { fg = p.strong })

  -- snacks.nvim (dashboard, picker, which-key, notifier)
  only({
    "SnacksNormal",
    "SnacksBackdrop",
    "SnacksWinbar",
    "SnacksWinbarNC",
    "SnacksTabline",
    "SnacksTablineSel",
    "SnacksDashboardNormal",
    "SnacksDashboardTitle",
    "SnacksDashboardHeader",
    "SnacksDashboardFooter",
    "SnacksPickerNormal",
    "SnacksPickerBorder",
    "SnacksPickerListBorder",
    "SnacksPickerMatch",
    "SnacksNotifierNormal",
    "SnacksWhichKeyNormal",
    "SnacksWhichKeyBorder",
    "SnacksConfigTitle",
    "SnacksConfigBorder",
    "SnacksGitSigns",
  }, { fg = p.fg, bg = p.bg })
  only({
    "SnacksDashboardKey",
    "SnacksDashboardIcon",
    "SnacksPickerPrompt",
    "SnacksNotifierTitle",
    "SnacksWhichKeyKey",
    "SnacksWhichKeyIcon",
    "SnacksIndent",
    "SnacksPickerSelected",
    "SnacksDashboardKeyIcon",
  }, { fg = p.fg, bold = true })
  only({
    "SnacksDashboardDesc",
    "SnacksDashboardFooter",
    "SnacksDimmed",
    "SnacksInfoVirtualText",
    "SnacksNotifierBody",
    "SnacksWhichKeyDesc",
    "SnacksGitSignsAdd",
    "SnacksGitSignsChange",
    "SnacksGitSignsDelete",
    "SnacksGitSignsUntracked",
  }, { fg = p.dim })

  -- which-key / noice / trouble / telescope / lualine / bufferline / cmp
  for _, prefix in ipairs({
    "Telescope",
    "Noice",
    "Trouble",
    "Lualine",
    "BufferLine",
    "CmpItem",
    "Notify",
    "Mason",
    "TreesitterContext",
    "IndentBlankline",
  }) do
    for name in pairs(vim.api.nvim_get_hl(0, {})) do
      if name:match("^" .. prefix) then
        local cur = vim.api.nvim_get_hl(0, { name = name })
        local st = { fg = p.fg }
        st.bold = cur.bold or nil
        st.italic = cur.italic or nil
        st.underline = cur.underline or nil
        if cur.sp then
          st.sp = type(cur.sp) == "table" and cur.sp[1] or cur.sp
        end
        st.cterm = cur.cterm
        st.link = nil
        hl(name, st)
      end
    end
  end
end

-- ---------------------------------------------------------------------------
-- терминал внутри nvim — те же цвета, что и в kitty
-- ---------------------------------------------------------------------------
local function terminal()
  local ramp = {
    "#000000",
    "#1c1c1c",
    "#333333",
    "#4a4a4a",
    "#616161",
    "#7a7a7a",
    "#949494",
    "#adadad",
    "#242424",
    "#3d3d3d",
    "#585858",
    "#737373",
    "#8f8f8f",
    "#aaaaaa",
    "#c4c4c4",
    "#e0e0e0",
  }
  for i, c in ipairs(ramp) do
    vim.g["terminal_color_" .. (i - 1)] = c
  end
end

-- ---------------------------------------------------------------------------
-- притянуть чужие цвета к палитре
-- ---------------------------------------------------------------------------
function M.clamp()
  local all = vim.api.nvim_get_hl(0, {})
  for name, v in pairs(all) do
    local fg, bg, sp = v.fg, v.bg, v.sp
    if fg or bg then
      local st = { default = false, blend = v.blend }
      local nf, nbg, nsp = fg, bg, sp
      if fg then
        nfg = M.snap(("#%06x"):format(fg))
        st.fg = nfg
      end
      if bg then
        nbg = M.snap(("#%06x"):format(bg), true)
        st.bg = nbg
      end
      if sp then
        nsp = M.snap(("#%06x"):format(type(sp) == "table" and sp[1] or sp))
        st.sp = nsp
      end
      if nfg ~= fg or nbg ~= bg or nsp ~= sp then
        if v.bold then
          st.bold = true
        end
        if v.italic then
          st.italic = true
        end
        if v.underline then
          st.underline = true
        end
        if v.strikethrough then
          st.strikethrough = true
        end
        if v.reverse then
          st.reverse = true
        end
        st.cterm = v.cterm
        hl(name, st)
      end
    end
  end
end

M.setup = function()
  base()
  syntax()
  lsp()
  terminal()

  local group = vim.api.nvim_create_augroup("mono", { clear = true })
  local pending = false
  local function refresh()
    if pending then
      return
    end
    pending = true
    vim.schedule(function()
      pending = false
      pcall(plugins)
      pcall(M.clamp)
    end)
  end

  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = refresh })
  for _, ev in ipairs({ "FileType", "BufWinEnter", "WinNew", "DiagnosticChanged", "User" }) do
    vim.api.nvim_create_autocmd(ev, { group = group, callback = refresh })
  end
  refresh()
end

-- применяем сразу: :colorscheme в этой версии nvim просто исполняет файл
M.load = M.setup
M.setup()

return M
