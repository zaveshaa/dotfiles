# dotfiles

My configs for Linux: vim, neovim, Doom Emacs, kitty, Firefox and VS Code.

I keep them here so they are not lost when the system is reinstalled. Copy the
folders you need into `~/.config` (kitty, nvim) or `~/.vim`, and load the ones
your editor reads from its own config.

Firefox: copy `user.js`, `userChrome.css` and `userContent.css` into your
profile directory. `about:support` shows the path. Then restart Firefox.
`userChrome.css` needs `toolkit.legacyUserProfileCustomizations.stylesheets`
set to true; `user.js` already does that.
