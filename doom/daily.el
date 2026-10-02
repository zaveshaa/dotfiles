;;; daily.el -*- lexical-binding: t; -*-

(defvar my/daily-dir (expand-file-name "~/notes/journal/everyday/"))

(defun my/daily-file ()
  (expand-file-name (format-time-string "%Y-%m-%d.org") my/daily-dir))

(defun my/daily-template ()
  (concat
   (format "#+title: %s\n" (format-time-string "%Y-%m-%d"))
   (format "#+date: %s\n" (format-time-string "%Y-%m-%d %a"))
   "#+filetags: daily\n\n"
   "* TODO \n"
   "* TODO \n"
   "* Заметки\n"
   "- \n\n"
   "* Итоги дня\n"
   "- \n"))

(defun my/open-daily ()
  (interactive)
  (make-directory my/daily-dir t)
  (find-file (my/daily-file))
  (when (= (point-min) (point-max))
    (insert (my/daily-template))
    (goto-char (point-min))
    (search-forward "* TODO " nil t)
    (save-buffer)))

(defvar my/home-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'my/open-daily)
    (define-key map (kbd "a") #'org-agenda)
    (define-key map (kbd "d") (lambda () (interactive) (dired my/daily-dir)))
    (define-key map (kbd "f") #'find-file)
    (define-key map (kbd "q") #'save-buffers-kill-terminal)
    map))

(define-derived-mode my/home-mode special-mode "Home"
  (setq-local cursor-type nil)
  (setq-local mode-line-format nil)
  (setq-local buffer-read-only t))

(defun my/home ()
  (interactive)
  (with-current-buffer (get-buffer-create "*home*")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (insert (format "\n  Журнал — %s\n\n" (format-time-string "%Y-%m-%d %A")))
      (insert "  n  создать заметку на сегодня\n")
      (insert "  a  список задач (agenda)\n")
      (insert "  d  папка с заметками\n")
      (insert "  f  открыть файл\n")
      (insert "  q  выйти из Emacs\n"))
    (my/home-mode)
    (goto-char (point-min))
    (switch-to-buffer (current-buffer))))

(provide 'daily)
