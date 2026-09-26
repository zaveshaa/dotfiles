# Хоткеи — шпаргалка

Единый leader — **пробел** в vim и nvim. kitty отдельно (cmd+…).
Тема светлая: белый фон, блеклые (низконасыщенные) цвета синтаксиса, шрифт `BigBlueTermPlus Nerd Font Mono` 14.

Собрано из `~/.config/kitty/kitty.conf`, `~/.vimrc`, `~/.config/nvim` (LazyVim 15.15.0),
348 сочетаний в nvim. Открыть: `less ~/.config/HOTKEYS.md` или `nvim ~/.config/HOTKEYS.md`

## Быстрое начало

| Действие | vim | nvim | kitty |
|---|---|---|---|
| сохранить | `Ctrl-s` / `Space w` | `Ctrl-s` | — |
| выйти | `Space q` | `q` | — |
| выйти из всех | `Space qq` | `Space qq` | `cmd+q` |
| открыть файл по имени | `Space ff` | `Space ff` | — |
| поиск по тексту | `Space fg` / `Space sg` | `Space fg` / `Space sg` | — |
| файлы проекта | `Space e` / `Space fe` | `Space e` / `Space fe` | — |
| предыдущий буфер | `Space b` / `Space bp` | `Space bb` / `Space bp` | — |
| список буферов | `Space bl` | `Space fb` / `Space ,` | — |
| закрыть буфер | `Space bd` | `Space bd` | — |
| ошибки / диагностика | `Space cd` / `Space cq` | `Space cd` / `Space xX` | — |
| строка / символ | `Ctrl-]` | `gd` / `gD` | — |
| проверка орфографии | `Space us` | `Space us` | — |
| шпаргалка | `Space h` или `Space ?` | `Space h` (этот файл) / `Space ?` | `cmd+p` (палитра kitty) |
| новая вкладка / окно | — | `Space <Tab> t` | `cmd+t` / `cmd+enter` |
| вкладка №N | — | — | `cmd+1` … `cmd+9` |
| скролл | `Ctrl-b` / `Ctrl-f` | — | `shift+page_up/down`, `cmd+page_up/down` |

## kitty

| Клавиши | Действие |
|---|---|
| `cmd+1` … `cmd+9` | вкладка N (номер виден в таббаре) |
| `cmd+0` | последняя вкладка |
| `cmd+shift+9` | предыдущая открытая вкладка |
| `cmd+shift+1` | выбрать вкладку из списка |
| `cmd+t` / `ctrl+shift+t` | новая вкладка |
| `cmd+w` | закрыть вкладку |
| `cmd+enter` | новое окно |
| `cmd+shift+w` | закрыть окно |
| `cmd+q` | выйти из kitty |
| `cmd+p` | палитра действий: поиск по всем хоткеям kitty |
| `ctrl+shift+f3` | та же палитра (дефолт kitty) |
| `shift+page_up` / `shift+page_down` | скролл страницей |
| `cmd+page_up` / `cmd+page_down` | скролл страницей |
| `cmd+up` / `cmd+down` | скролл строкой |
| `cmd+home` / `cmd+end` | в начало / в конец скроллбэка |
| `ctrl+shift+f5` | перезагрузить конфиг kitty |

Чего в kitty **нет**:

- `fn+<клавиша>` — kitty не понимает модификатор `fn` (`unknown modifier, ignoring`)
- `ctrl+f` / `ctrl+b` — не назначены намеренно: в vim это page down/up, в shell — движение курсора
- `cmd+1..9` при двух вкладках — `cmd+3..9` ничего не делают, номера абсолютные

## vim (leader = `Space`, `timeoutlen=400`)

| Клавиши | Действие |
|---|---|
| `ff` | открыть файл по имени (`:find`) |
| `fg` | grep по слову под курсором |
| `sg` | vimgrep по слову под курсором |
| `fe` / `e` | explorer |
| `E` | explorer в текущей папке |
| `Ctrl-s` / `w` | сохранить |
| `q` | выйти |
| `qa` / `qq` | выйти из всех |
| `b` / `bp` | предыдущий буфер |
| `bl` | список буферов |
| `bd` | закрыть буфер |
| `m` | make |
| `cc` | gcc compile + run |
| `r` | перезапустить последний бинарник |
| `n` / `p` | следующая / предыдущая ошибка |
| `cd` | список ошибок (`:copen`) |
| `cq` | закрыть список ошибок |
| `us` | проверка орфографии |
| `Space Space` | убрать подсветку поиска |
| `t` | назад по тегам |
| `Ctrl-]` | к определению |
| `h` / `?` | эта справка внутри vim |
| `Ctrl+h/j/k/l` | окна: влево / вниз / вверх / вправо |
| `Ctrl+S+h/j/k/l` | окна: на весь экран |

### Базовый vim

| Клавиши | Действие |
|---|---|
| `i` / `a` / `o` | вставка / вставка после / новая строка |
| `v` / `V` | визуальный режим / по строкам |
| `dd` / `yy` / `p` | удалить / скопировать / вставить строку |
| `ciw` / `ci"` | изменить слово / текст в кавычках |
| `u` / `Ctrl-r` | отмена / повтор |
| `gg` / `G` | в начало / в конец файла |
| `/` / `n` / `N` | поиск / следующее / предыдущее |
| `:%s/старое/новое/g` | заменить по всему файлу |
| `zz` / `zt` / `zb` | по центру / сверху / снизу |
| `.` | повторить последнее изменение |
| `Ctrl-w q` | закрыть окно |
| `:w` / `:q` / `:wq` | сохранить / выйти / сохранить и выйти |

## Neovim (LazyVim 15.15.0, leader = `Space`)

Важно: в LazyVim 15.x сохранение — это `Ctrl-s`, а `Space w` — группа для окон.
Поиск по файлам — `Space ff` / `Space fg`, список буферов — `Space fb` или `Space ,`.

### `<Space>` — leader

| Клавиши | Действие | Режим |
|---|---|---|
| `<Space> ` | Find Files (Root Dir) | обычный |
| `<Space>,` | Buffers | обычный |
| `<Space>-` | Split Window Below | обычный |
| `<Space>.` | Toggle Scratch Buffer | обычный |
| `<Space>/` | Grep (Root Dir) | обычный |
| `<Space>:` | Command History | обычный |
| `<Space><Tab><Tab>` | New Tab | обычный |
| `<Space><Tab>[` | Previous Tab | обычный |
| `<Space><Tab>]` | Next Tab | обычный |
| `<Space><Tab>d` | Close Tab | обычный |
| `<Space><Tab>f` | First Tab | обычный |
| `<Space><Tab>l` | Last Tab | обычный |
| `<Space><Tab>o` | Close Other Tabs | обычный |
| `<Space>?` | Buffer Keymaps (which-key) | обычный |
| `<Space>E` | Explorer Snacks (cwd) | обычный |
| `<Space>K` | Keywordprg | обычный |
| `<Space>L` | LazyVim Changelog | обычный |
| `<Space>S` | Select Scratch Buffer | обычный |
| `<Space>`` | Switch to Other Buffer | обычный |
| `<Space>bD` | Delete Buffer and Window | обычный |
| `<Space>bP` | Delete Non-Pinned Buffers | обычный |
| `<Space>bb` | Switch to Other Buffer | обычный |
| `<Space>bd` | Delete Buffer | обычный |
| `<Space>bj` | Pick Buffer | обычный |
| `<Space>bl` | Delete Buffers to the Left | обычный |
| `<Space>bo` | Delete Other Buffers | обычный |
| `<Space>bp` | Toggle Pin | обычный |
| `<Space>br` | Delete Buffers to the Right | обычный |
| `<Space>cF` | Format Injected Langs | визуальный |
| `<Space>cF` | Format Injected Langs | обычный |
| `<Space>cS` | LSP references/definitions/... (Trouble) | обычный |
| `<Space>cd` | Line Diagnostics | обычный |
| `<Space>cf` | Format | визуальный |
| `<Space>cf` | Format | обычный |
| `<Space>cm` | Mason | обычный |
| `<Space>cs` | Symbols (Trouble) | обычный |
| `<Space>dph` | Toggle Profiler Highlights | обычный |
| `<Space>dpp` | Toggle Profiler | обычный |
| `<Space>dps` | Profiler Scratch Buffer | обычный |
| `<Space>e` | Explorer Snacks (root dir) | обычный |
| `<Space>fB` | Buffers (all) | обычный |
| `<Space>fE` | Explorer Snacks (cwd) | обычный |
| `<Space>fF` | Find Files (cwd) | обычный |
| `<Space>fR` | Recent (cwd) | обычный |
| `<Space>fT` | Terminal (cwd) | обычный |
| `<Space>fb` | Buffers | обычный |
| `<Space>fc` | Find Config File | обычный |
| `<Space>fe` | Explorer Snacks (root dir) | обычный |
| `<Space>ff` | Find Files (Root Dir) | обычный |
| `<Space>fg` | Find Files (git-files) | обычный |
| `<Space>fn` | New File | обычный |
| `<Space>fp` | Projects | обычный |
| `<Space>fr` | Recent | обычный |
| `<Space>ft` | Terminal (Root Dir) | обычный |
| `<Space>gB` | Git Browse (open) | визуальный |
| `<Space>gB` | Git Browse (open) | обычный |
| `<Space>gD` | Git Diff (origin) | обычный |
| `<Space>gI` | GitHub Issues (all) | обычный |
| `<Space>gL` | Git Log (cwd) | обычный |
| `<Space>gP` | GitHub Pull Requests (all) | обычный |
| `<Space>gS` | Git Stash | обычный |
| `<Space>gY` | Git Browse (copy) | визуальный |
| `<Space>gY` | Git Browse (copy) | обычный |
| `<Space>gb` | Git Blame Line | обычный |
| `<Space>gd` | Git Diff (hunks) | обычный |
| `<Space>gf` | Git Current File History | обычный |
| `<Space>gi` | GitHub Issues (open) | обычный |
| `<Space>gl` | Git Log | обычный |
| `<Space>gp` | GitHub Pull Requests (open) | обычный |
| `<Space>gs` | Git Status | обычный |
| `<Space>h` | Шпаргалка по хоткеям (HOTKEYS.md) | обычный |
| `<Space>hh` | Which-key: подсказки | обычный |
| `<Space>l` | Lazy | обычный |
| `<Space>n` | Notification History | обычный |
| `<Space>oa` | org agenda | обычный |
| `<Space>oc` | org capture | обычный |
| `<Space>qS` | Select Session | обычный |
| `<Space>qd` | Don't Save Current Session | обычный |
| `<Space>ql` | Restore Last Session | обычный |
| `<Space>qq` | Quit All | обычный |
| `<Space>qs` | Restore Session | обычный |
| `<Space>s"` | Registers | обычный |
| `<Space>s/` | Search History | обычный |
| `<Space>sB` | Grep Open Buffers | обычный |
| `<Space>sC` | Commands | обычный |
| `<Space>sD` | Buffer Diagnostics | обычный |
| `<Space>sG` | Grep (cwd) | обычный |
| `<Space>sH` | Highlights | обычный |
| `<Space>sM` | Man Pages | обычный |
| `<Space>sR` | Resume | обычный |
| `<Space>sT` | Todo/Fix/Fixme | обычный |
| `<Space>sW` | Visual selection or word (cwd) | визуальный |
| `<Space>sW` | Visual selection or word (cwd) | обычный |
| `<Space>sa` | Autocmds | обычный |
| `<Space>sb` | Buffer Lines | обычный |
| `<Space>sc` | Command History | обычный |
| `<Space>sd` | Diagnostics | обычный |
| `<Space>sg` | Grep (Root Dir) | обычный |
| `<Space>sh` | Help Pages | обычный |
| `<Space>si` | Icons | обычный |
| `<Space>sj` | Jumps | обычный |
| `<Space>sk` | Keymaps | обычный |
| `<Space>sl` | Location List | обычный |
| `<Space>sm` | Marks | обычный |
| `<Space>sn` | +noice | обычный |
| `<Space>sna` | Noice All | обычный |
| `<Space>snd` | Dismiss All | обычный |
| `<Space>snh` | Noice History | обычный |
| `<Space>snl` | Noice Last Message | обычный |
| `<Space>snt` | Noice Picker (Telescope/FzfLua) | обычный |
| `<Space>sp` | Search for Plugin Spec | обычный |
| `<Space>sq` | Quickfix List | обычный |
| `<Space>sr` | Search and Replace | визуальный |
| `<Space>sr` | Search and Replace | обычный |
| `<Space>st` | Todo | обычный |
| `<Space>su` | Undotree | обычный |
| `<Space>sw` | Visual selection or word (Root Dir) | визуальный |
| `<Space>sw` | Visual selection or word (Root Dir) | обычный |
| `<Space>uA` | Toggle Tabline | обычный |
| `<Space>uC` | Colorschemes | обычный |
| `<Space>uD` | Toggle Dimming | обычный |
| `<Space>uF` | Toggle Auto Format (Buffer) | обычный |
| `<Space>uI` | Inspect Tree | обычный |
| `<Space>uL` | Toggle Relative Number | обычный |
| `<Space>uS` | Toggle Smooth Scroll | обычный |
| `<Space>uT` | Toggle Treesitter Highlight | обычный |
| `<Space>uZ` | Toggle Zoom Mode | обычный |
| `<Space>ua` | Toggle Animations | обычный |
| `<Space>ub` | Toggle Dark Background | обычный |
| `<Space>uc` | Toggle Conceal Level | обычный |
| `<Space>ud` | Toggle Diagnostics | обычный |
| `<Space>uf` | Toggle Auto Format (Global) | обычный |
| `<Space>ug` | Toggle Indent Guides | обычный |
| `<Space>uh` | Toggle Inlay Hints | обычный |
| `<Space>ui` | Inspect Pos | обычный |
| `<Space>ul` | Toggle Line Numbers | обычный |
| `<Space>un` | Dismiss All Notifications | обычный |
| `<Space>up` | Toggle Mini Pairs | обычный |
| `<Space>ur` | Redraw / Clear hlsearch / Diff Update | обычный |
| `<Space>us` | Toggle Spelling | обычный |
| `<Space>uw` | Toggle Wrap | обычный |
| `<Space>uz` | Toggle Zen Mode | обычный |
| `<Space>wd` | Delete Window | обычный |
| `<Space>wm` | Toggle Zoom Mode | обычный |
| `<Space>xL` | Location List (Trouble) | обычный |
| `<Space>xQ` | Quickfix List (Trouble) | обычный |
| `<Space>xT` | Todo/Fix/Fixme (Trouble) | обычный |
| `<Space>xX` | Buffer Diagnostics (Trouble) | обычный |
| `<Space>xl` | Location List | обычный |
| `<Space>xq` | Quickfix List | обычный |
| `<Space>xt` | Todo (Trouble) | обычный |
| `<Space>xx` | Diagnostics (Trouble) | обычный |
| `<Space>\|` | Split Window Right | обычный |

### `<C-…>`, `<M-…>`, `[` `]`

| Клавиши | Действие | Режим |
|---|---|---|
| `<BS>` | MiniPairs <BS> | вставка |
| `<C-/>` | Terminal (Root Dir) | terminal |
| `<C-/>` | Terminal (Root Dir) | обычный |
| `<C-B>` | Scroll Backward | вставка |
| `<C-B>` | Scroll Backward | выделение |
| `<C-B>` | Scroll Backward | обычный |
| `<C-Down>` | Decrease Window Height | обычный |
| `<C-F>` | Scroll Forward | вставка |
| `<C-F>` | Scroll Forward | выделение |
| `<C-F>` | Scroll Forward | обычный |
| `<C-H>` | Go to Left Window | обычный |
| `<C-J>` | Go to Lower Window | обычный |
| `<C-K>` | Go to Upper Window | обычный |
| `<C-L>` | Go to Right Window | обычный |
| `<C-Left>` | Decrease Window Width | обычный |
| `<C-Right>` | Increase Window Width | обычный |
| `<C-S>` | Save File | визуальный |
| `<C-S>` | Save File | вставка |
| `<C-S>` | Save File | выделение |
| `<C-S>` | Save File | обычный |
| `<C-Space>` | Treesitter Incremental Selection | визуальный |
| `<C-Space>` | Treesitter Incremental Selection | обычный |
| `<C-Space>` | Treesitter Incremental Selection | оператор |
| `<C-U>` | :help i_CTRL-U-default | вставка |
| `<C-Up>` | Increase Window Height | обычный |
| `<C-W>` | :help i_CTRL-W-default | вставка |
| `<C-W> ` | Window Hydra Mode (which-key) | обычный |
| `<C-W><C-D>` | Show diagnostics under the cursor | обычный |
| `<C-W>d` | Show diagnostics under the cursor | обычный |
| `<C-_>` | which_key_ignore | terminal |
| `<C-_>` | which_key_ignore | обычный |
| `<CR>` | MiniPairs <CR> | вставка |
| `<Down>` | Down | визуальный |
| `<Down>` | Down | обычный |
| `<Esc>` | Escape and Clear hlsearch | вставка |
| `<Esc>` | Escape and Clear hlsearch | выделение |
| `<Esc>` | Escape and Clear hlsearch | обычный |
| `<M-j>` | Move Down | визуальный |
| `<M-j>` | Move Down | вставка |
| `<M-j>` | Move Down | выделение |
| `<M-j>` | Move Down | обычный |
| `<M-k>` | Move Up | визуальный |
| `<M-k>` | Move Up | вставка |
| `<M-k>` | Move Up | выделение |
| `<M-k>` | Move Up | обычный |
| `<S-Tab>` | vim.snippet.jump if active, otherwise <S-Tab> | вставка |
| `<S-Tab>` | vim.snippet.jump if active, otherwise <S-Tab> | выделение |
| `<Tab>` | vim.snippet.jump if active, otherwise <Tab> | вставка |
| `<Tab>` | vim.snippet.jump if active, otherwise <Tab> | выделение |
| `<Up>` | Up | визуальный |
| `<Up>` | Up | обычный |
| `<lt>` | _без описания_ | визуальный |
| `[` | Open action for "[]" pair | вставка |
| `[ ` | Add empty line above cursor | обычный |
| `[%` | _без описания_ | визуальный |
| `[%` | _без описания_ | обычный |
| `[%` | _без описания_ | оператор |
| `[<C-L>` | :lpfile | обычный |
| `[<C-Q>` | :cpfile | обычный |
| `[<C-T>` | :ptprevious | обычный |
| `[A` | :rewind | обычный |
| `[B` | Move buffer prev | обычный |
| `[D` | Jump to the first diagnostic in the current buffer | обычный |
| `[L` | :lrewind | обычный |
| `[Q` | :crewind | обычный |
| `[T` | :trewind | обычный |
| `[a` | :previous | обычный |
| `[b` | Prev Buffer | обычный |
| `[d` | Prev Diagnostic | обычный |
| `[e` | Prev Error | обычный |
| `[l` | :lprevious | обычный |
| `[n` | Select previous node | визуальный |
| `[q` | Previous Trouble/Quickfix Item | обычный |
| `[t` | Previous Todo Comment | обычный |
| `[w` | Prev Warning | обычный |
| `]` | Close action for "[]" pair | вставка |
| `] ` | Add empty line below cursor | обычный |
| `]%` | _без описания_ | визуальный |
| `]%` | _без описания_ | обычный |
| `]%` | _без описания_ | оператор |
| `]<C-L>` | :lnfile | обычный |
| `]<C-Q>` | :cnfile | обычный |
| `]<C-T>` | :ptnext | обычный |
| `]A` | :last | обычный |
| `]B` | Move buffer next | обычный |
| `]D` | Jump to the last diagnostic in the current buffer | обычный |
| `]L` | :llast | обычный |
| `]Q` | :clast | обычный |
| `]T` | :tlast | обычный |
| `]a` | :next | обычный |
| `]b` | Next Buffer | обычный |
| `]d` | Next Diagnostic | обычный |
| `]e` | Next Error | обычный |
| `]l` | :lnext | обычный |
| `]n` | Select next node | визуальный |
| `]q` | Next Trouble/Quickfix Item | обычный |
| `]t` | Next Todo Comment | обычный |
| `]w` | Next Warning | обычный |

### буквы и `g…`

| Клавиши | Действие | Режим |
|---|---|---|
| `"` | Closeopen action for '""' pair | вставка |
| `#` | :help v_#-default | визуальный |
| `%` | _без описания_ | визуальный |
| `%` | _без описания_ | обычный |
| `%` | _без описания_ | оператор |
| `&` | :help &-default | обычный |
| `'` | Closeopen action for "''" pair | вставка |
| `(` | Open action for "()" pair | вставка |
| `)` | Close action for "()" pair | вставка |
| `*` | :help v_star-default | визуальный |
| `,` | _без описания_ | визуальный |
| `,` | _без описания_ | вставка |
| `,` | _без описания_ | обычный |
| `,` | _без описания_ | оператор |
| `.` | _без описания_ | вставка |
| `;` | _без описания_ | визуальный |
| `;` | _без описания_ | вставка |
| `;` | _без описания_ | обычный |
| `;` | _без описания_ | оператор |
| `>` | _без описания_ | визуальный |
| `@` | :help v_@-default | визуальный |
| `F` | _без описания_ | визуальный |
| `F` | _без описания_ | обычный |
| `F` | _без описания_ | оператор |
| `H` | Prev Buffer | обычный |
| `L` | Next Buffer | обычный |
| `N` | Prev Search Result | визуальный |
| `N` | Prev Search Result | обычный |
| `N` | Prev Search Result | оператор |
| `Q` | :help v_Q-default | визуальный |
| `R` | Treesitter Search | визуальный |
| `R` | Treesitter Search | оператор |
| `S` | Flash Treesitter | визуальный |
| `S` | Flash Treesitter | обычный |
| `S` | Flash Treesitter | оператор |
| `T` | _без описания_ | визуальный |
| `T` | _без описания_ | обычный |
| `T` | _без описания_ | оператор |
| `Y` | :help Y-default | обычный |
| ``` | Closeopen action for "``" pair | вставка |
| `a` | Around textobject | визуальный |
| `a` | Around textobject | оператор |
| `a%` | _без описания_ | визуальный |
| `al` | Around last textobject | визуальный |
| `al` | Around last textobject | оператор |
| `an` | Around next textobject | визуальный |
| `an` | Around next textobject | оператор |
| `f` | _без описания_ | визуальный |
| `f` | _без описания_ | обычный |
| `f` | _без описания_ | оператор |
| `g%` | _без описания_ | визуальный |
| `g%` | _без описания_ | обычный |
| `g%` | _без описания_ | оператор |
| `gO` | vim.lsp.buf.document_symbol() | обычный |
| `g[` | Move to left "around" | визуальный |
| `g[` | Move to left "around" | обычный |
| `g[` | Move to left "around" | оператор |
| `g]` | Move to right "around" | визуальный |
| `g]` | Move to right "around" | обычный |
| `g]` | Move to right "around" | оператор |
| `gc` | Toggle comment | визуальный |
| `gc` | Toggle comment | обычный |
| `gc` | Comment textobject | оператор |
| `gcO` | Add Comment Above | обычный |
| `gcc` | Toggle comment line | обычный |
| `gco` | Add Comment Below | обычный |
| `gra` | vim.lsp.buf.code_action() | визуальный |
| `gra` | vim.lsp.buf.code_action() | обычный |
| `gri` | vim.lsp.buf.implementation() | обычный |
| `grn` | vim.lsp.buf.rename() | обычный |
| `grr` | vim.lsp.buf.references() | обычный |
| `grt` | vim.lsp.buf.type_definition() | обычный |
| `grx` | vim.lsp.codelens.run() | обычный |
| `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | визуальный |
| `gx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | обычный |
| `i` | Inside textobject | визуальный |
| `i` | Inside textobject | оператор |
| `il` | Inside last textobject | визуальный |
| `il` | Inside last textobject | оператор |
| `in` | Inside next textobject | визуальный |
| `in` | Inside next textobject | оператор |
| `j` | Down | визуальный |
| `j` | Down | обычный |
| `k` | Up | визуальный |
| `k` | Up | обычный |
| `n` | Next Search Result | визуальный |
| `n` | Next Search Result | обычный |
| `n` | Next Search Result | оператор |
| `r` | Remote Flash | оператор |
| `s` | Flash | визуальный |
| `s` | Flash | обычный |
| `s` | Flash | оператор |
| `t` | _без описания_ | визуальный |
| `t` | _без описания_ | обычный |
| `t` | _без описания_ | оператор |
| `{` | Open action for "{}" pair | вставка |
| `}` | Close action for "{}" pair | вставка |

## Где что менять

- vim: `~/.vimrc` — строки `nnoremap` и `let mapleader=" "`
- nvim: `~/.config/nvim/lua/config/keymaps.lua` (добавил `Space h` и `Space hh`)
- kitty: `~/.config/kitty/kitty.conf`, секция `map`

## Проверить, что хоткей жив

- vim — нажать `Space h`
- nvim — нажать пробел и подождать (which-key покажет подсказку)
- kitty — нажать `cmd+p`, вбить `tab`

## Перегенерировать эту шпаргалку

```sh
HOTKEYS_OUT=/tmp/nvim_section.md nvim --headless -c 'luafile /tmp/gen_hotkeys.lua' -c 'qa!'
```

(скрипт лежит в /tmp — при перезагрузке Mac он пропадёт, тогда удали эти строки)
