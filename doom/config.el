;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "zaveshaa")

(setq system-time-locale "C")

(setq native-comp-async-jobs-number 1)

(setq doom-theme 'doom-one-light
      frame-background-mode 'light
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
(load! "mono-grayscale")

(setq org-directory my/daily-dir
      org-default-notes-file (expand-file-name "inbox.org" my/daily-dir)
      org-agenda-files (list my/todo-file my/daily-dir)
      org-log-done 'time
      org-startup-folded nil
      org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "DONE(d!)"))
      org-agenda-prefix-format "• %:c %?t %s"
      org-agenda-time-grid '((daily today require-timed)
                             (800 1000 1200 1400 1600 1800 2000)
                             " ------------------------------------"
                             "")
      org-agenda-current-time-string " now ----------"
      org-agenda-custom-commands
      '(("a" "10 days-agenda" agenda ""
         ((org-agenda-span 10)
          (org-agenda-start-on-weekday nil)
          (org-agenda-start-day "-3d")))))

(setq initial-buffer-choice (lambda () (my/home) (get-buffer "*home*")))

(map! :leader
      "n" #'my/open-daily
      "m" #'my/home)

(after! evil
  (evil-set-initial-state 'my/home-mode 'emacs))
