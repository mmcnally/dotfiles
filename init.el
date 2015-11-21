;;;;;;;;;;;;;;;;;;;;;
;;; Initial Setup ;;;
;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; set theme
(load-theme 'tango-dark t)

;;;;;;;;;;;;;;;;;;;;;
;;; Package Setup ;;;
;;;;;;;;;;;;;;;;;;;;;

(use-package smartparens
  :defer 2
  :disabled t
  :ensure t
  :config
  (smartparens-global-mode t)
  )

(use-package auto-complete
  :defer 2
  :ensure t
  :config
  (ac-config-default)
  )


(use-package jedi
  :ensure t
  )


(use-package scala-mode2
  :mode ("\\.scala\\'" . scala-mode)
  :ensure t
  )

(use-package elm-mode
  :mode ("\\.elm\\'" . elm-mode)
  :ensure t
  )

(use-package auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :init
  (setq TeX-command-list
	'(
	  ("LaTeX" "%`%l%(mode)%' %t" TeX-run-TeX nil (latex-mode doctex-mode)
	   :help "Run LaTeX")
	  ("View" "open -a Preview.app %s.pdf" TeX-run-command t t
	   :help "Run Text viewer")
	  )
	)
  :ensure t
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Other Configuration ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; indent buffer when not in python mode
(defun indent-buffer-when-not-python ()
  (when (not (derived-mode-p 'python-mode))
    (indent-buffer)))

;; indent buffer on save
(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

;; formatting hooks on save
(add-hook 'before-save-hook #'indent-buffer-when-not-python)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; return indents automatically
(define-key global-map (kbd "RET") 'newline-and-indent)

;; show matching parens
(show-paren-mode t)
(setq show-paren-delay 0)

;; move backups to temp dir
;; can still recover file with M-x recover-file
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; increases annoying auto backup timer
(setq auto-save-timeout 999)

;; removes scratch message
(setq initial-scratch-message "")

;; removes startup screen
(setq inhibit-startup-screen t)

;; return at end of file creates new line
(setq next-line-add-newlines t)

;; binds option key to meta
(setq mac-option-modifier 'meta)

;; typing replaces highlighted region
(delete-selection-mode t)

;; uses y or n instead of yes or no
(fset 'yes-or-no-p 'y-or-n-p)

;; java indenting
(setq c-basic-offset 2)

;; javascript indenting
(setq js-indent-level 2)

;; python autocomplete - jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; uncomment or comment line/region
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
	(setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

;; bind uncomment or comment line/region globally to C-j
(global-set-key (kbd "C-j") 'comment-or-uncomment-region-or-line)

;; workaround to bind uncomment or comment function to C-j in latex-mode
(add-hook 'latex-mode-hook '(lambda () (local-set-key (kbd "C-j") 'comment-or-uncomment-region-or-line)))
(add-hook 'LaTeX-mode-hook '(lambda () (local-set-key (kbd "C-j") 'comment-or-uncomment-region-or-line)))

;; set transparency
(set-frame-parameter (selected-frame) 'alpha '(75 75))
(add-to-list 'default-frame-alist '(alpha 75 75))
(set-face-attribute 'default nil :background "black" :foreground "white")
