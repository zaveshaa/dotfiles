;;; daily.el -*- lexical-binding: t; -*-

(defvar my/daily-dir (expand-file-name "~/journal/everyday/"))
(defvar my/todo-file (expand-file-name "~/journal/todo.org"))

(defvar my/cal-months
  ["January" "February" "March" "April" "May" "June"
   "July" "August" "September" "October" "November" "December"])

(defvar-local my/cal-month nil)
(defvar-local my/cal-year nil)
(defvar-local my/cal-select nil)
(put 'my/cal-month 'permanent-local t)
(put 'my/cal-year 'permanent-local t)
(put 'my/cal-select 'permanent-local t)

(defun my/days-in-month (m y)
  (if (= m 12)
      31
    (string-to-number
     (format-time-string "%d" (encode-time 0 0 0 0 (1+ m) y)))))

(defun my/first-weekday (m y)
  "0 = Monday .. 6 = Sunday for the 1st of month M of year Y."
  (let ((w (string-to-number
            (format-time-string "%w" (encode-time 0 0 0 1 m y)))))
    (mod (+ w 6) 7)))

(defun my/daily-file (y m d)
  (expand-file-name (format "%04d-%02d-%02d.org" y m d) my/daily-dir))

(defun my/daily-template (y m d)
  (let ((date (format "%04d-%02d-%02d" y m d))
        (dow  (capitalize (format-time-string "%a" (encode-time 0 0 0 d m y)))))
    (concat
     (format "#+title: %s\n" date)
     (format "#+date: %s %s\n" date dow)
     "#+filetags: daily\n"
     "#+CATEGORY: daily\n\n"
     "* TODO Read\n"
     "- [ ] \n"
     "* TODO Yoga\n"
     "- [ ] \n"
     "* TODO Typing\n"
     "- [ ] \n\n"
     "* Notes\n"
     "- \n\n"
     "* Summary\n"
     "- \n")))

(defun my/open-daily-date (y m d)
  (interactive)
  (make-directory my/daily-dir t)
  (find-file (my/daily-file y m d))
  (when (= (point-min) (point-max))
    (insert (my/daily-template y m d))
    (goto-char (point-min))
    (search-forward "* TODO " nil t)
    (save-buffer)))

(defun my/open-daily ()
  (interactive)
  (my/open-daily-date (string-to-number (format-time-string "%Y"))
                      (string-to-number (format-time-string "%m"))
                      (string-to-number (format-time-string "%d"))))

;;; Calendar rendering

(defun my/cal-day-fmt (y m d)
  (let* ((is-today (string= (format "%04d-%02d-%02d" y m d)
                            (format-time-string "%Y-%m-%d")))
         (is-sel (= d my/cal-select)))
    (cond
     (is-sel                 (format "[%2d]" d))
     (is-today               (format "*%2d*" d))
     (t                      (format " %2d " d)))))

(defun my/cal-header (m y)
  (let* ((title (format "%s %d" (aref my/cal-months (1- m)) y))
         (pad (max 0 (/ (- 36 (length title)) 2))))
    (format "%s%s\n" (make-string pad ?\s) title)))

(defun my/cal-border (l m r)
  (let ((s l) (i 0))
    (while (< i 7)
      (setq s (concat s "────" (if (< i 6) m r))
            i (1+ i)))
    s))

(defun my/cal-weekdays-row ()
  (concat "│"
          (mapconcat (lambda (w) (format " %-2s " w))
                     '("Mo" "Tu" "We" "Th" "Fr" "Sa" "Su") "│")
          "│"))

(defun my/cal-row (cells)
  (concat "│" (mapconcat #'identity cells "│") "│\n"))

(defun my/all-blank-p (cells)
  (let ((ok t))
    (dolist (c cells ok)
      (unless (string= c "    ") (setq ok nil)))))

(defun my/cal-rows (m y)
  (let* ((off (my/first-weekday m y))
         (ndays (my/days-in-month m y))
         (grid (make-vector 42 "    "))
         (gridrows '()))
    (dotimes (d ndays)
      (aset grid (+ off d) (my/cal-day-fmt y m (1+ d))))
    (dotimes (r 6)
      (let ((cells '()))
        (dotimes (c 7)
          (push (aref grid (+ (* r 7) c)) cells))
        (push (nreverse cells) gridrows)))
    (while (and gridrows (my/all-blank-p (car gridrows)))
      (setq gridrows (cdr gridrows)))
    (mapconcat (lambda (cells) (my/cal-row cells)) (nreverse gridrows) "")))

(defun my/cal-table (m y)
  (concat (my/cal-border "┌" "┬" "┐") "\n"
          (my/cal-weekdays-row) "\n"
          (my/cal-border "├" "┼" "┤") "\n"
          (my/cal-rows m y)
          (my/cal-border "└" "┴" "┘") "\n"))

(defun my/cal-month-prev ()
  "Move one month back (state only, buffer-local to *home*)."
  (setq my/cal-month (1- my/cal-month))
  (when (< my/cal-month 1)
    (setq my/cal-month 12 my/cal-year (1- my/cal-year)))
  (setq my/cal-select (min my/cal-select (my/days-in-month my/cal-month my/cal-year))))

(defun my/cal-month-next ()
  "Move one month forward (state only, buffer-local to *home*)."
  (setq my/cal-month (1+ my/cal-month))
  (when (> my/cal-month 12)
    (setq my/cal-month 1 my/cal-year (1+ my/cal-year)))
  (setq my/cal-select (min my/cal-select (my/days-in-month my/cal-month my/cal-year))))

(defun my/cal-shift (n)
  "Move the selected day by N days, flipping months at the edges."
  (let ((d (+ my/cal-select n)))
    (while (< d 1)
      (my/cal-month-prev)
      (setq d (+ d (my/days-in-month my/cal-month my/cal-year))))
    (while (> d (my/days-in-month my/cal-month my/cal-year))
      (setq d (- d (my/days-in-month my/cal-month my/cal-year)))
      (my/cal-month-next))
    (setq my/cal-select d)))

(defun my/cal-day-prev ()
  "Move selected day one step left; before the 1st it flips to the previous month."
  (interactive)
  (with-current-buffer "*home*" (my/cal-shift -1))
  (my/home))

(defun my/cal-day-next ()
  "Move selected day one step right; past the last day it flips to the next month."
  (interactive)
  (with-current-buffer "*home*" (my/cal-shift 1))
  (my/home))

(defun my/cal-day-up ()
  "Move selected day one week up (7 days back)."
  (interactive)
  (with-current-buffer "*home*" (my/cal-shift -7))
  (my/home))

(defun my/cal-day-down ()
  "Move selected day one week down (7 days forward)."
  (interactive)
  (with-current-buffer "*home*" (my/cal-shift 7))
  (my/home))

(defun my/cal-prev ()
  (interactive)
  (with-current-buffer "*home*" (my/cal-month-prev))
  (my/home))

(defun my/cal-next ()
  (interactive)
  (with-current-buffer "*home*" (my/cal-month-next))
  (my/home))

(defun my/cal-open ()
  "Open the daily report for the selected calendar day."
  (interactive)
  (my/open-daily-date my/cal-year my/cal-month my/cal-select))

;;; todo.org sections (Homework / Projects)

(declare-function org-reveal "org")

(defun my/open-todo-section (section)
  "Open todo.org and jump to a top-level SECTION."
  (find-file my/todo-file)
  (goto-char (point-min))
  (if (re-search-forward (concat "^\\* " (regexp-quote section) "\\*? *$") nil t)
      (org-reveal)
    (message "Section %s not found" section)))

(defun my/agenda ()
  "Open the 10-day agenda."
  (interactive)
  (org-agenda nil "a"))

;;; Home buffer

(defvar my/home-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "h")   #'my/cal-prev)
    (define-key map (kbd "l")   #'my/cal-next)
    (define-key map (kbd "<left>")  #'my/cal-day-prev)
    (define-key map (kbd "<right>") #'my/cal-day-next)
    (define-key map (kbd "<up>")    #'my/cal-day-up)
    (define-key map (kbd "<down>")  #'my/cal-day-down)
    (define-key map (kbd "RET") #'my/cal-open)
    (define-key map (kbd "TAB") #'my/cal-open)
    (define-key map (kbd "SPC") #'my/cal-open)
    (define-key map (kbd "n")   #'my/open-daily)
    (define-key map (kbd "m")   #'my/home)
    (define-key map (kbd "w")   (lambda () (interactive) (my/open-todo-section "Homework")))
    (define-key map (kbd "p")   (lambda () (interactive) (my/open-todo-section "Projects")))
    (define-key map (kbd "t")   (lambda () (interactive) (find-file my/todo-file)))
    (define-key map (kbd "a")   #'my/agenda)
    (define-key map (kbd "d")   (lambda () (interactive) (dired my/daily-dir)))
    (define-key map (kbd "f")   #'find-file)
    (define-key map (kbd "q")   #'save-buffers-kill-terminal)
    map))

(define-derived-mode my/home-mode special-mode "Home"
  (setq-local cursor-type nil)
  (setq-local mode-line-format nil)
  (setq-local buffer-read-only t))

(defun my/home--body ()
  "Return the full text of the home menu."
  (let ((sync (if (boundp 'my/sync-status) my/sync-status "never")))
    (concat
     (format "  Journal — %s\n" (format-time-string "%Y-%m-%d %A"))
     (format "  fetched %s\n" sync)
     (my/cal-header my/cal-month my/cal-year)
     (my/cal-table my/cal-month my/cal-year)
     "  [ 5] selected day    * 5* today\n"
     "\n  ←/→ day   ↑/↓ week   h/l month   RET open day   n today   m menu\n"
     "  w homework   p projects   t todo   a agenda   d folder   f file   q quit\n")))

(defun my/home--center (text)
  "Insert TEXT horizontally and vertically centered in the window."
  (let* ((win (get-buffer-window (current-buffer) t))
         (lines (split-string text "\n"))
         (nlines (length lines))
         (width (apply #'max 0 (mapcar #'string-width lines)))
         (hpad (max 0 (/ (- (window-width win) width) 2)))
         (vpad (max 0 (/ (- (window-body-height win) nlines) 2)))
         (indent (make-string hpad ?\s)))
    (dotimes (_ vpad) (insert "\n"))
    (dolist (line lines)
      (insert indent line "\n"))))

(defun my/home-refresh ()
  "Re-render the *home* buffer, centered."
  (with-current-buffer "*home*"
    (unless my/cal-month
      (setq-local my/cal-month (string-to-number (format-time-string "%m")))
      (setq-local my/cal-year  (string-to-number (format-time-string "%Y")))
      (setq-local my/cal-select (string-to-number (format-time-string "%d"))))
    (setq my/cal-select (min my/cal-select (my/days-in-month my/cal-month my/cal-year)))
    (let ((inhibit-read-only t))
      (erase-buffer)
      (my/home--center (my/home--body)))
    (goto-char (point-min))))

(defun my/home--size-change (frame)
  (when (and (get-buffer "*home*")
             (get-buffer-window "*home*" frame))
    (with-current-buffer "*home*"
      (when (derived-mode-p 'my/home-mode)
        (my/home-refresh)))))

(add-hook 'window-size-change-functions #'my/home--size-change)

(defun my/home ()
  (interactive)
  (delete-other-windows)
  (switch-to-buffer (get-buffer-create "*home*"))
  (my/home-refresh)
  (my/home-mode))

(provide 'daily)
