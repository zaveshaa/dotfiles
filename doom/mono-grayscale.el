;;; mono-grayscale.el --- Grayscale (black-and-white) overrides -*- lexical-binding: t; -*-
;;; Commentary:
;; Forces a white background with grey text of varying shades, regardless of the
;; active theme. Applied as persistent user face customizations.
;;; Code:

(setq default-frame-alist
      (append default-frame-alist
              '((foreground-color . "#262626")
                (background-color . "#FFFFFF")))
      initial-frame-alist
      (append initial-frame-alist
              '((foreground-color . "#262626")
                (background-color . "#FFFFFF"))))

(custom-set-faces
 '(default ((t (:background "#FFFFFF" :foreground "#262626"))))
 '(fixed-pitch ((t (:background "#FFFFFF" :foreground "#262626"))))
 '(cursor ((t (:background "#141414"))))
 '(mouse ((t (:background "#141414"))))
 '(mode-line ((t (:background "#E0E0E0" :foreground "#141414" :box (:line-width -1 :style released-button)))))
 '(mode-line-inactive ((t (:background "#F5F5F5" :foreground "#959595" :box (:line-width -1 :style released-button)))))
 '(header-line ((t (:background "#EFEFEF" :foreground "#4C4C4C"))))
 '(vertical-border ((t (:foreground "#BFBFBF"))))
 '(fringe ((t (:background "#FFFFFF" :foreground "#838383"))))
 '(highlight ((t (:background "#E9E9E9" :foreground "#262626"))))
 '(region ((t (:background "#D6D6D6" :foreground "#141414"))))
 '(secondary-selection ((t (:background "#E0E0E0" :foreground "#262626"))))
 '(hl-line ((t (:background "#F5F5F5"))))
 '(line-number ((t (:foreground "#BABABA"))))
 '(line-number-current-line ((t (:foreground "#5E5E5E" :weight bold))))
 '(minibuffer-prompt ((t (:foreground "#141414" :weight bold))))
 '(link ((t (:foreground "#4C4C4C" :underline t))))
 '(shadow ((t (:foreground "#959595"))))
 '(isearch ((t (:background "#D6D6D6" :foreground "#141414"))))
 '(lazy-highlight ((t (:background "#E0E0E0" :foreground "#262626"))))
 '(query-replace ((t (:background "#D6D6D6" :foreground "#141414"))))
 '(trailing-whitespace ((t (:background "#BABABA"))))
 '(escape-glyph ((t (:foreground "#838383"))))
 '(glyphless-char ((t (:foreground "#A8A8A8"))))
 '(error ((t (:foreground "#141414" :weight bold))))
 '(warning ((t (:foreground "#5E5E5E" :weight bold))))
 '(success ((t (:foreground "#3B3B3B" :weight bold))))

 '(font-lock-comment-face ((t (:foreground "#959595" :italic t))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#959595"))))
 '(font-lock-doc-face ((t (:foreground "#838383"))))
 '(font-lock-string-face ((t (:foreground "#3B3B3B"))))
 '(font-lock-keyword-face ((t (:foreground "#141414" :weight bold))))
 '(font-lock-function-name-face ((t (:foreground "#141414" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#3B3B3B"))))
 '(font-lock-type-face ((t (:foreground "#4C4C4C" :weight bold))))
 '(font-lock-constant-face ((t (:foreground "#3B3B3B" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "#5E5E5E"))))
 '(font-lock-number-face ((t (:foreground "#262626"))))
 '(font-lock-negation-char-face ((t (:foreground "#262626"))))
 '(font-lock-reference-face ((t (:foreground "#4C4C4C"))))
 '(font-lock-warning-face ((t (:foreground "#141414" :background "#EFEFEF" :weight bold))))

 '(show-paren-match ((t (:background "#E0E0E0" :foreground "#141414" :weight bold))))
 '(show-paren-mismatch ((t (:background "#D6D6D6" :foreground "#141414" :weight bold))))

 '(org-document-title ((t (:foreground "#141414" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#707070"))))
 '(org-document-info-keyword ((t (:foreground "#838383"))))
 '(org-meta-line ((t (:foreground "#838383"))))
 '(org-code ((t (:foreground "#4C4C4C"))))
 '(org-block ((t (:background "#F5F5F5" :foreground "#3B3B3B"))))
 '(org-block-begin-line ((t (:background "#F5F5F5" :foreground "#838383"))))
 '(org-block-end-line ((t (:background "#F5F5F5" :foreground "#838383"))))
 '(org-table ((t (:foreground "#3B3B3B"))))
 '(org-headline-done ((t (:foreground "#838383" :strike-through t))))
 '(org-todo ((t (:foreground "#141414" :weight bold))))
 '(org-done ((t (:foreground "#959595" :weight bold))))
 '(org-date ((t (:foreground "#5E5E5E"))))
 '(org-time-stamp ((t (:foreground "#5E5E5E"))))
 '(org-scheduled ((t (:foreground "#707070"))))
 '(org-scheduled-today ((t (:foreground "#4C4C4C" :weight bold))))
 '(org-deadline-announce ((t (:foreground "#707070"))))
 '(org-drawer ((t (:foreground "#959595"))))
 '(org-agenda-structure ((t (:foreground "#141414" :weight bold))))
 '(org-agenda-date ((t (:foreground "#141414" :weight bold :height 1.2))))
 '(org-agenda-date-today ((t (:foreground "#262626" :weight bold))))
 '(org-agenda-done ((t (:foreground "#959595" :strike-through t))))
 '(org-mode-line-clock ((t (:foreground "#3B3B3B")))))

(provide 'mono-grayscale)
;;; mono-grayscale.el ends here
