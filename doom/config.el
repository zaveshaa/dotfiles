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

;; sync
(defvar my/sync-last-fetch nil
  "Time of the last successful sync fetch, as returned by `current-time'.")

(defvar my/sync-status "never"
  "Human-readable sync status for the home buffer.")

(defvar my/sync--fetching nil
  "Non-nil while a journal sync is in progress.")

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

(defun my/sync--refresh-home ()
  "Redraw the home buffer if visible."
  (when (and (fboundp 'my/home-refresh)
             (get-buffer "*home*")
             (get-buffer-window "*home*" t))
    (with-current-buffer "*home*"
      (when (derived-mode-p 'my/home-mode)
        (my/home-refresh)))))

(defun my/sync--update-status ()
  "Refresh `my/sync-status' and redraw the home buffer if visible."
  (setq my/sync-status
        (if my/sync--fetching
            "fetching journal..."
          (my/sync--ago-string my/sync-last-fetch)))
  (my/sync--refresh-home))

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
         :command (list "git" "pull" "--rebase")
         :sentinel
         (lambda (proc _event)
           (when (memq (process-status proc) '(exit signal))
             (condition-case err
                 (let ((ok (and (eq (process-status proc) 'exit)
                                (= (process-exit-status proc) 0)))
                       (out (with-current-buffer (process-buffer proc)
                              (buffer-string))))
                   (if ok
                       (message "sync[%s]: %s" label (string-trim out))
                     (message "sync[%s] failed: %s" label (string-trim out)))
                   (when (buffer-live-p (process-buffer proc))
                     (kill-buffer (process-buffer proc)))
                   (funcall on-done ok))
               (error
                (when (buffer-live-p (process-buffer proc))
                  (kill-buffer (process-buffer proc)))
                (message "sync[%s] sentinel error: %S" label err)
                (ignore-errors (funcall on-done nil))))))))))

(defun my/sync--commit-journal-if-dirty (root)
  "Commit all journal changes in ROOT when dirty."
  (let ((default-directory (file-name-as-directory root)))
    (with-temp-buffer
      (process-file "git" nil t nil "add" "-A")
      (erase-buffer)
      (let ((status (process-file "git" nil t nil "status" "--porcelain")))
        (when (and (eq status 0)
                   (not (string-empty-p (string-trim (buffer-string)))))
          (erase-buffer)
          (process-file "git" nil t nil "commit" "-m"
                        (format "journal: sync %s"
                                (format-time-string "%Y-%m-%d %H:%M"))))))))

(defun my/sync-pull-journal ()
  "Pull journal repository asynchronously."
  (interactive)
  (unless my/sync--fetching
    (let ((root (my/sync--repo-root (expand-file-name "~/journal"))))
      (when root
        (my/sync--commit-journal-if-dirty root)))
    (setq my/sync--fetching t)
    (my/sync--update-status)
    (my/sync--pull-repo
     (expand-file-name "~/journal")
     "journal"
     (lambda (ok)
       (setq my/sync--fetching nil)
       (when ok
         (setq my/sync-last-fetch (current-time)))
       (my/sync--update-status)))
    (my/sync--start-status-timer)))

(defun my/sync-push-journal ()
  "Commit and push journal repository on Emacs exit."
  (let* ((dir (expand-file-name "~/journal"))
         (root (my/sync--repo-root dir)))
    (when root
      (let ((default-directory (file-name-as-directory root)))
        (message "sync[journal]: pushing...")
        (with-temp-buffer
          (process-file "git" nil t nil "add" "-A")
          (erase-buffer)
          (let ((status (process-file "git" nil t nil "status" "--porcelain")))
            (when (and (eq status 0)
                       (not (string-empty-p (string-trim (buffer-string)))))
              (erase-buffer)
              (process-file "git" nil t nil "commit" "-m"
                            (format "journal: sync %s"
                                    (format-time-string "%Y-%m-%d %H:%M")))))
          (erase-buffer)
          (let ((exit (process-file "git" nil t nil "push")))
            (if (eq exit 0)
                (message "sync[journal]: pushed")
              (message "sync[journal] push failed: %s"
                       (string-trim (buffer-string))))))))))

(add-hook 'emacs-startup-hook #'my/sync-pull-journal)
(add-hook 'emacs-startup-hook (lambda () (run-with-timer 2 nil #'my/sync-pull-journal)))
(add-hook 'after-init-hook #'my/sync-pull-journal)
(add-hook 'kill-emacs-hook #'my/sync-push-journal)
