;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "zaveshaa")

(setq doom-theme 'doom-gruvbox
      display-line-numbers-type nil
      inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore)

(setq doom-modeline-icon nil
      doom-modeline-major-mode-icon nil
      doom-modeline-buffer-encoding nil
      doom-modeline-indent-info nil
      doom-modeline-minor-modes nil
      doom-modeline-check-simple-format t
      doom-modeline-height 22)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load! "daily")

(setq org-directory my/daily-dir
      org-default-notes-file (expand-file-name "inbox.org" my/daily-dir)
      org-agenda-files (list my/daily-dir)
      org-log-done 'time
      org-startup-folded nil
      org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "DONE(d!)")))

(setq initial-buffer-choice (lambda () (my/home) (get-buffer "*home*")))

(map! :leader "n" #'my/open-daily)

(after! evil
  (evil-set-initial-state 'my/home-mode 'emacs))
