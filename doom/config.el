;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "zaveshaa")

(setq system-time-locale "C")

;; Native-compile one package at a time. The default (0 = half the cores)
;; starts 2 compiler processes here, which pegs both cores and pushes this
;; i3 M 370 to ~80°C during first-time builds. 1 keeps it much cooler.
(setq native-comp-async-jobs-number 1)

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

(map! :leader "n" #'my/open-daily)

(after! evil
  (evil-set-initial-state 'my/home-mode 'emacs))

;; sync
(defvar my/sync-last-fetch nil
  "Time of the last successful sync fetch, as returned by `current-time'.")

(defvar my/sync-status "never"
  "Human-readable sync status for the home buffer.")

(defun my/sync--ago-string (time)
  "Return a human-readable age for TIME."
  (if (not time)
      "never"
    (let* ((secs (max 0 (floor (float-time (time-subtract (current-time) time)))))
           (mins (/ secs 60))
           (hours (/ mins 60))
           (days (/ hours 24)))
      (cond
       ((< secs 60) (format "%d sec ago" secs))
       ((< mins 60) (format "%d min ago" mins))
       ((< hours 24) (format "%d hr ago" hours))
       (t (format "%d day%s ago" days (if (= days 1) "" "s")))))))

(defun my/sync--update-status ()
  "Refresh `my/sync-status' and redraw the home buffer if visible."
  (setq my/sync-status (my/sync--ago-string my/sync-last-fetch))
  (when (and (fboundp 'my/home-refresh)
             (get-buffer "*home*")
             (get-buffer-window "*home*" t))
    (with-current-buffer "*home*"
      (when (derived-mode-p 'my/home-mode)
        (my/home-refresh)))))

(defvar my/sync--status-timer nil)

(defun my/sync--start-status-timer ()
  "Periodically refresh the displayed fetch age."
  (unless (timerp my/sync--status-timer)
    (setq my/sync--status-timer
          (run-with-timer 30 30 #'my/sync--update-status))))

(defun my/sync--repo-root (dir)
  "Return git root for DIR, or nil."
  (when (and dir (file-directory-p dir))
    (let ((default-directory (file-name-as-directory (expand-file-name dir))))
      (let ((root (string-trim-right
                   (or (ignore-errors
                         (car (process-lines "git" "rev-parse" "--show-toplevel")))
                       ""))))
        (unless (string-empty-p root) root)))))

(defun my/sync--pull-repo (dir label on-done)
  "Async git pull in DIR. Call ON-DONE with non-nil on success."
  (let* ((root (my/sync--repo-root dir)))
    (if (not root)
        (progn
          (message "sync[%s]: not a git repo: %s" label dir)
          (funcall on-done nil))
      (let ((default-directory (file-name-as-directory root))
            (buf (generate-new-buffer (format " *sync-%s*" label))))
        (make-process
         :name (format "sync-pull-%s" label)
         :buffer buf
         :command (list "git" "pull" "--ff-only")
         :sentinel
         (lambda (proc _event)
           (when (memq (process-status proc) '(exit signal))
             (let ((ok (and (eq (process-status proc) 'exit)
                            (= (process-exit-status proc) 0)))
                   (out (with-current-buffer (process-buffer proc)
                          (buffer-string))))
               (if ok
                   (message "sync[%s]: %s" label (string-trim out))
                 (message "sync[%s] failed: %s" label (string-trim out)))
               (kill-buffer (process-buffer proc))
               (funcall on-done ok)))))))))

(defun my/sync-pull-all ()
  "Pull dotfiles and journal repositories asynchronously."
  (interactive)
  (let ((pending 2)
        (any-ok nil)
        (done (lambda (ok)
                (when ok (setq any-ok t))
                (setq pending (1- pending))
                (when (<= pending 0)
                  (when any-ok
                    (setq my/sync-last-fetch (current-time)))
                  (my/sync--update-status)))))
    (my/sync--pull-repo (expand-file-name "~/dotfiles") "dotfiles" done)
    (my/sync--pull-repo (expand-file-name "~/journal") "journal" done)
    (my/sync--start-status-timer)))

(defun my/sync-push-journal ()
  "Push journal repository on Emacs exit."
  (let* ((dir (expand-file-name "~/journal"))
         (root (my/sync--repo-root dir)))
    (when root
      (let ((default-directory (file-name-as-directory root)))
        (message "sync[journal]: pushing...")
        (with-temp-buffer
          (let ((exit (process-file "git" nil t nil "push")))
            (if (eq exit 0)
                (message "sync[journal]: pushed")
              (message "sync[journal] push failed: %s"
                       (string-trim (buffer-string))))))))))

(add-hook 'emacs-startup-hook #'my/sync-pull-all)
(add-hook 'kill-emacs-hook #'my/sync-push-journal)
