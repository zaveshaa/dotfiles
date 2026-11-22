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

(defvar my/home--dirty nil)
(defvar my/heatmap-weeks 14)

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
  (let ((date (format "%04d-%02d-%02d" y m d)))
    (concat
     (format "#+TITLE: Journal - %s\n\n" date)
     "* Sleep\n"
     "- Went to bed: \n"
     "- Woke up: \n\n"
     "* Habits\n"
     "- [ ] Read\n"
     "- [ ] Draw\n"
     "- [ ] Stretching\n"
     "- [ ] Yoga\n"
     "- [ ] Reading (40 pages)\n"
     "- [ ] Typing\n"
     "- [ ] English (grammar + Anki 01deck)\n"
     "- [ ] Japanese\n\n"
     "* Notes\n")))

(defun my/open-daily-date (y m d)
  (interactive)
  (make-directory my/daily-dir t)
  (find-file (my/daily-file y m d))
  (when (= (point-min) (point-max))
    (insert (my/daily-template y m d))
    (goto-char (point-min))
    (when (search-forward "- [ ] " nil t)
      (beginning-of-line))
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

(defface my/heatmap-0
  '((t (:background "#EFEFEF" :foreground "#EFEFEF")))
  "Face for days with no completed habits.")

(defface my/heatmap-1
  '((t (:background "#D6D6D6" :foreground "#D6D6D6")))
  "Face for days with 1-33% of habits completed.")

(defface my/heatmap-2
  '((t (:background "#B0B0B0" :foreground "#B0B0B0")))
  "Face for days with 34-66% of habits completed.")

(defface my/heatmap-3
  '((t (:background "#757575" :foreground "#757575")))
  "Face for days with 67-99% of habits completed.")

(defface my/heatmap-4
  '((t (:background "#262626" :foreground "#262626")))
  "Face for days with every habit completed.")

(defface my/report-warning
  '((t (:foreground "#4C4C4C" :weight bold)))
  "Face for overdue or urgent TODO tags.")

(defun my/date-shift (y m d n)
  "Return (YEAR MONTH DAY) for the date N days from Y-M-D."
  (let ((dec (decode-time (time-add (encode-time 0 0 0 d m y t)
                                    (* n 86400.0))
                          t)))
    (list (nth 5 dec) (nth 4 dec) (nth 3 dec))))

(defun my/date-weekday (y m d)
  "Return 0 for Monday through 6 for Sunday for Y-M-D."
  (1- (string-to-number
       (format-time-string "%u" (encode-time 0 0 0 d m y t) t))))

(defun my/habits-progress--buffer ()
  "Parse the current buffer's Habits section into (DONE . TOTAL)."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^\\*+ +Habits *$" nil t)
      (let ((start (point))
            (next (re-search-forward "^\\*+ " nil t))
            (done 0)
            (total 0))
        (save-restriction
          (narrow-to-region start (if next (match-beginning 0) (point-max)))
          (goto-char (point-min))
          (while (re-search-forward "^[[:space:]]*[-+] +\\[\\([ Xx]\\)\\]" nil t)
            (setq total (1+ total))
            (when (member (match-string 1) '("X" "x"))
              (setq done (1+ done)))))
        (when (> total 0)
          (cons done total))))))

(defun my/habits-progress (file)
  "Return (DONE . TOTAL) for FILE's Habits section, or nil when absent."
  (let ((buf (get-file-buffer file)))
    (if (and buf (buffer-modified-p buf))
        (with-current-buffer buf (my/habits-progress--buffer))
      (when (file-exists-p file)
        (with-temp-buffer
          (insert-file-contents file)
          (my/habits-progress--buffer))))))

(defun my/heatmap-pct (progress)
  "Return the integer completion percentage of PROGRESS."
  (round (* 100.0 (car progress)) (cdr progress)))

(defun my/heatmap-cell (progress)
  "Return (CELL . FACE) describing PROGRESS."
  (let ((pct (if progress (my/heatmap-pct progress) 0)))
    (cons " "
          (cond
           ((>= pct 100) 'my/heatmap-4)
           ((>= pct 67)  'my/heatmap-3)
           ((>= pct 34)  'my/heatmap-2)
           ((> pct 0)    'my/heatmap-1)
           (t            'my/heatmap-0)))))

(defun my/heatmap-grid ()
  "Return the weekday-labelled heatmap grid as a propertized string."
  (let* ((now (decode-time))
         (ty (nth 5 now)) (tm (nth 4 now)) (td (nth 3 now))
         (today (float-time (encode-time 0 0 0 td tm ty t)))
         (monday (my/date-shift ty tm td (- (my/date-weekday ty tm td))))
         (start (my/date-shift (nth 0 monday) (nth 1 monday) (nth 2 monday)
                               (* -7 (1- my/heatmap-weeks))))
         (names '("Mo" "Tu" "We" "Th" "Fr" "Sa" "Su"))
         (rows nil))
    (dotimes (wd 7)
      (let ((row (propertize (format " %-2s " (nth wd names)) 'face 'shadow)))
        (dotimes (w my/heatmap-weeks)
          (let* ((date (my/date-shift (nth 0 start) (nth 1 start) (nth 2 start)
                                      (+ (* w 7) wd)))
                 (y (nth 0 date)) (m (nth 1 date)) (d (nth 2 date)))
            (if (> (float-time (encode-time 0 0 0 d m y t)) today)
                (setq row (concat row "  "))
              (let ((cell (my/heatmap-cell (my/habits-progress
                                            (my/daily-file y m d)))))
                (setq row (concat row (propertize (car cell) 'face (cdr cell)) " "))))))
        (push row rows)))
    (mapconcat #'identity (nreverse rows) "\n")))

(defun my/heatmap-streak ()
  "Return the current streak of fully completed days."
  (let* ((now (decode-time))
         (y (nth 5 now)) (m (nth 4 now)) (d (nth 3 now))
         (prog (my/habits-progress (my/daily-file y m d)))
         (cursor (if (and prog (= (car prog) (cdr prog)))
                     (list y m d)
                   (my/date-shift y m d -1)))
         (streak 0))
    (while (let ((p (my/habits-progress
                     (my/daily-file (nth 0 cursor) (nth 1 cursor)
                                    (nth 2 cursor)))))
             (and p (= (car p) (cdr p))))
      (setq streak (1+ streak))
      (setq cursor (my/date-shift (nth 0 cursor) (nth 1 cursor)
                                  (nth 2 cursor) -1)))
    streak))

(defun my/heatmap-summary ()
  "Return the today/streak summary line."
  (let* ((now (decode-time))
         (y (nth 5 now)) (m (nth 4 now)) (d (nth 3 now))
         (prog (my/habits-progress (my/daily-file y m d)))
         (today (if prog
                    (format "%d/%d (%d%%)" (car prog) (cdr prog)
                            (my/heatmap-pct prog))
                   "—"))
         (streak (my/heatmap-streak)))
    (format "  Today %s   Streak %d day%s" today streak
            (if (= streak 1) "" "s"))))

(defun my/heatmap-string ()
  "Return the propertized habits heatmap block."
  (concat "\n" (my/heatmap-grid) "\n"
          (my/heatmap-summary) "\n"))

(defun my/journal-content (file)
  "Return FILE's text, preferring a modified visiting buffer."
  (let ((buf (get-file-buffer file)))
    (if (and buf (buffer-modified-p buf))
        (with-current-buffer buf (buffer-string))
      (when (file-exists-p file)
        (with-temp-buffer
          (insert-file-contents file)
          (buffer-string))))))

(defun my/section-region (heading)
  "Return (START . END) of HEADING in the current buffer, or nil."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward
           (concat "^\\(\\*+\\) +" (regexp-quote heading) " *$") nil t)
      (let* ((level (length (match-string 1)))
             (start (point))
             (next (re-search-forward
                    (concat "^\\*\\{1," (number-to-string level) "\\} +") nil t)))
        (cons start (if next (match-beginning 0) (point-max)))))))

(defun my/sleep-values (content)
  "Return (BED . UP) parsed from CONTENT."
  (let ((bed "—") (up "—"))
    (with-temp-buffer
      (insert (or content ""))
      (let ((region (my/section-region "Sleep")))
        (when region
          (save-restriction
            (narrow-to-region (car region) (cdr region))
            (goto-char (point-min))
            (when (re-search-forward "Went to bed:[ \t]*\\(.*\\)" nil t)
              (setq bed (string-trim (match-string 1))))
            (goto-char (point-min))
            (when (re-search-forward "Woke up:[ \t]*\\(.*\\)" nil t)
              (setq up (string-trim (match-string 1))))))))
    (when (string-empty-p bed) (setq bed "—"))
    (when (string-empty-p up) (setq up "—"))
    (cons bed up)))

(defun my/time-to-minutes (value)
  "Convert HH:MM VALUE to minutes since midnight, or nil."
  (when (string-match "\\`\\([0-9]\\{1,2\\}\\):\\([0-9]\\{2\\}\\)\\'" value)
    (+ (* 60 (string-to-number (match-string 1 value)))
       (string-to-number (match-string 2 value)))))

(defun my/sleep-duration (bed up)
  "Return a formatted duration between BED and UP, or nil."
  (let ((b (my/time-to-minutes bed))
        (u (my/time-to-minutes up)))
    (when (and b u)
      (let ((mins (mod (- u b) (* 24 60))))
        (format "(%dh %dm)" (/ mins 60) (% mins 60))))))

(defun my/wrap-words (text width)
  "Split TEXT into lines of at most WIDTH columns."
  (let ((lines '()) (line "") (i 0) (n (length text)))
    (while (< i n)
      (if (= (aref text i) ?\s)
          (setq i (1+ i))
        (let* ((end (or (string-match " " text i) n))
               (word (substring text i end))
               (need (+ (string-width line)
                        (if (> (string-width line) 0) 1 0)
                        (string-width word))))
          (if (and (> (string-width line) 0) (> need width))
              (progn (push line lines) (setq line word))
            (setq line (concat line
                               (if (> (string-width line) 0) " " "")
                               word)))
          (setq i end))))
    (when (> (string-width line) 0) (push line lines))
    (nreverse lines)))

(defun my/report-field (label value width)
  "Return LABEL/VALUE lines wrapped to WIDTH."
  (let* ((prefix (concat "  " (format "%-9s " label)))
         (pad (make-string (string-width prefix) ?\s))
         (parts (my/wrap-words (or value "") (max 8 (- width (string-width prefix)))))
         (lines nil))
    (dolist (part parts)
      (push (concat (if lines pad prefix) part) lines))
    (mapconcat #'identity (nreverse lines) "\n")))

(defun my/highlight-bangs (text)
  "Return TEXT with urgent exclamation markers highlighted."
  (with-temp-buffer
    (insert text)
    (goto-char (point-min))
    (while (re-search-forward "!\\{2,\\}" nil t)
      (put-text-property (match-beginning 0) (match-end 0)
                         'face 'my/report-warning))
    (buffer-string)))

(defun my/habits-values (content)
  "Return (DONE TOTAL LEFT) parsed from CONTENT."
  (let ((done 0) (total 0) (left '()))
    (with-temp-buffer
      (insert (or content ""))
      (let ((region (my/section-region "Habits")))
        (when region
          (save-restriction
            (narrow-to-region (car region) (cdr region))
            (goto-char (point-min))
            (while (re-search-forward
                    "^[[:space:]]*[-+] +\\[\\([ Xx]\\)\\] *\\(.*\\)$" nil t)
              (setq total (1+ total))
              (if (member (match-string 1) '("X" "x"))
                  (setq done (1+ done))
                (let ((label (string-trim (match-string 2))))
                  (unless (string-empty-p label)
                    (push label left)))))))))
    (list done total (nreverse left))))

(defun my/todo-open-items (section date)
  "Return open TODO entries from SECTION of `my/todo-file'."
  (let ((items '()))
    (when (file-exists-p my/todo-file)
      (with-temp-buffer
        (insert-file-contents my/todo-file)
        (let ((region (my/section-region section)))
          (when region
            (save-restriction
              (narrow-to-region (car region) (cdr region))
              (goto-char (point-min))
              (while (re-search-forward "^\\*+ +TODO +\\(.+\\)$" nil t)
                (let* ((title (my/highlight-bangs (string-trim (match-string 1))))
                       (next (save-excursion (re-search-forward "^\\*+ " nil t)))
                       (bound (if next (match-beginning 0) (point-max)))
                       (deadline (save-excursion
                                   (when (re-search-forward
                                          "DEADLINE: <\\([^>]+>\\)" bound t)
                                     (match-string 1)))))
                  (when (and deadline (>= (length deadline) 10))
                    (let* ((full (substring deadline 0 10))
                           (short (substring deadline 5 10))
                           (tag (format " (due %s)" short)))
                      (setq title
                            (concat title (if (string< full date)
                                              (propertize tag 'face 'my/report-warning)
                                            tag)))))
                  (push title items))))))))
    (nreverse items)))

(defun my/report-items (items width)
  "Return ITEMS as indented, wrapped report lines."
  (if items
      (mapconcat
       (lambda (item)
         (let* ((prefix "    - ")
                (pad "      ")
                (parts (my/wrap-words item (- width (length prefix))))
                (lines nil))
           (dolist (part parts)
             (push (concat (if lines pad prefix) part) lines))
           (mapconcat #'identity (nreverse lines) "\n")))
       items "\n")
    "    —"))

(defun my/daily-report (width)
  "Return the daily report block for the home screen, wrapped to WIDTH."
  (let* ((now (decode-time))
         (y (nth 5 now)) (m (nth 4 now)) (d (nth 3 now))
         (date (format "%04d-%02d-%02d" y m d))
         (weekday (format-time-string "%A" (encode-time 0 0 0 d m y)))
         (content (my/journal-content (my/daily-file y m d)))
         (sleep (my/sleep-values content))
         (bed (car sleep)) (up (cdr sleep))
         (duration (my/sleep-duration bed up))
         (habits (my/habits-values content))
         (done (nth 0 habits)) (total (nth 1 habits)) (left (nth 2 habits))
         (pct (if (> total 0) (round (* 100.0 done) total) 0))
         (sleep-value (concat "bed " bed " · up " up
                              (if duration (concat "  " duration) "")))
         (habits-value (format "%d/%d (%d%%) · Streak %dd"
                               done total pct (my/heatmap-streak)))
         (left-text (if left (mapconcat #'identity left ", ") "—")))
    (concat
     (propertize (format "  Daily report — %s (%s)\n" date weekday) 'face 'bold)
     (propertize (concat "  " (make-string (max 0 (- width 2)) ?─)) 'face 'shadow) "\n"
     (my/report-field "Sleep" sleep-value width) "\n"
     (my/report-field "Habits" habits-value width) "\n"
     (my/report-field "Left" left-text width) "\n\n"
     (propertize "  Tasks\n" 'face 'shadow)
     (my/report-items (my/todo-open-items "Tasks" date) width) "\n\n"
     (propertize "  Homework\n" 'face 'shadow)
     (my/report-items (my/todo-open-items "Homework" date) width))))

(defun my/home--columns (left right gap)
  "Return LEFT and RIGHT rendered side by side, separated by GAP."
  (let* ((ll (split-string left "\n"))
         (rl (split-string right "\n"))
         (n (max (length ll) (length rl)))
         (lw (apply #'max 0 (mapcar #'string-width ll)))
         (lines nil))
    (dotimes (i n)
      (let* ((l (or (nth i ll) ""))
             (r (or (nth i rl) ""))
             (pad (make-string (max 0 (+ gap (- lw (string-width l)))) ?\s)))
        (push (concat l pad r) lines)))
    (mapconcat #'identity (nreverse lines) "\n")))

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

;; sync: replace with yours
(defun my/journal-sync-manual ()
  (interactive)
  (if (fboundp 'my/sync-pull-all)
      (my/sync-pull-all)
    (message "sync: not configured")))

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
    (define-key map (kbd "s")   #'my/journal-sync-manual)
    (define-key map (kbd "q")   #'save-buffers-kill-terminal)
    map))

(define-derived-mode my/home-mode special-mode "Home"
  (setq-local cursor-type nil)
  (setq-local mode-line-format nil)
  (setq-local buffer-read-only t))

(defun my/home--body ()
  "Return the full text of the home menu."
  (let* ((right (concat
                 (my/cal-header my/cal-month my/cal-year)
                 (my/cal-table my/cal-month my/cal-year)))
         (columns (replace-regexp-in-string
                   "\n[ \t]*\\'" ""
                   (my/home--columns (my/heatmap-string) right 4)))
         (width (apply #'max 0
                       (mapcar #'string-width (split-string columns "\n"))))
         (sync (if (boundp 'my/sync-status) my/sync-status "never")))
    (concat columns "\n\n  fetched " sync "\n\n" (my/daily-report width))))

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
  (setq my/home--dirty nil)
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

(defun my/home--mark-dirty (&rest _)
  (setq my/home--dirty t))

(defun my/home--watch-journal ()
  (when (and buffer-file-name
             (string-prefix-p my/daily-dir (expand-file-name buffer-file-name)))
    (add-hook 'after-change-functions #'my/home--mark-dirty nil t)))

(defun my/home--refresh-on-show (window)
  (when (and my/home--dirty
             (eq (window-buffer window) (get-buffer "*home*")))
    (my/home-refresh)))

(add-hook 'find-file-hook #'my/home--watch-journal)
(add-hook 'window-buffer-change-functions #'my/home--refresh-on-show)

(provide 'daily)
