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
  ;; :defer 2
  :ensure t
  :config
  (ac-config-default)
  )


;; need virtualenv python package, install with: pip install virtualenv
;; need to run M-x jedi:install-server first time
;; (use-package jedi
;;   :ensure t
;;   :disabled t
;;   )


;; ocaml repl
(use-package utop
  :ensure t
  )

;; fixes terrible indenting of tuareg-mode
(use-package ocp-indent
  :ensure t
  )

;; ocaml completion and other sweet stuff
(use-package merlin
  :mode ("\\.ml\\'" . merlin-mode)
  :ensure t
  :init
  (setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
  (add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  :config
  (setq merlin-ac-setup t)
  (setq merlin-command 'opam)
  (setq merlin-error-after-save nil)
  )

;; ocaml mode
(use-package tuareg
  :mode ("\\.ml\\'" . tuareg-mode)
  :ensure t
  :config
  (setq electric-indent-mode nil)
  )

(use-package scala-mode2
  :mode ("\\.scala\\'" . scala-mode)
  :ensure t
  )

(use-package elm-mode
  :mode ("\\.elm\\'" . elm-mode)
  :ensure t
  )

;; LaTex
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


;;;; Indent on save config ;;;;;;;;;;;;;

;; formatting hooks on save
(add-hook 'before-save-hook #'indent-buffer-when-not-python)
(add-hook 'write-contents-functions #'delete-trailing-whitespace)

;; shortcuts to enable/disable indenting on save
(define-key global-map (kbd "M-s s") 'enable-indent-on-save)
(define-key global-map (kbd "M-s M-s") 'disable-indent-on-save)

;; indent buffer when not in python mode
(defun indent-buffer-when-not-python ()
  (when (not (derived-mode-p 'python-mode))
    (indent-buffer)))

;; indent buffer
(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun enable-indent-on-save ()
  (interactive)
  (add-hook 'before-save-hook 'indent-buffer-when-not-python)
  (message "indent-on-save enabled")
  )

(defun disable-indent-on-save ()
  (interactive)
  (remove-hook 'before-save-hook 'indent-buffer-when-not-python)
  (message "indent-on-save disabled")
  )






;; return indents automatically
(define-key global-map (kbd "RET") 'newline-and-indent)

;; show matching parens
(show-paren-mode t)
(setq show-paren-delay 0)

;; show column number
(setq column-number-mode t)

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

;; python indenting


;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 2)
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil)
                      (setq tab-width 4)
                      (setq python-indent 4)
                      )))

;; java indenting
(setq c-basic-offset 2)

;; javascript indenting
(setq js-indent-level 2)

;; python autocomplete - jedi
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)

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
