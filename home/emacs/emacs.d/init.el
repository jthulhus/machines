(require 'package)
(add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(use-package pkg-info)

(use-package package-lint)

(setq default-frame-alist '((undecorated . t))
      menu-bar-mode nil
      scroll-bar-mode nil
      tool-bar-mode nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t)

(load-theme 'zenburn t)

(defvar wc-modes '(fundamental-mode org-mode)
  "Which major-mode enable wc in the powerline.")

(use-package spaceline
  :config
  (use-package spaceline-config
    :ensure nil
    :config
    (spaceline-toggle-buffer-encoding-off)
    (spaceline-toggle-buffer-encoding-abbrev-off)
    (setq powerline-default-separator 'rounded)
    (spaceline-define-segment line-column
      "The current line and column numbers."
      "%l|%2c")
    (spaceline-define-segment word-count
      "The number of words in the buffer or region if active."
      (if (use-region-p)
          (format "wc[R]:%s" (count-words-region (region-beginning) (region-end)))
        (format "wc:%s" (count-words-region (point-min) (point-max))))
      :when (and active (member major-mode wc-modes))
      :priority 90)
    (spaceline-spacemacs-theme 'word-count)))

(use-package dashboard
  :init
  (setq dashboard-items '((recents . 5)
                          (projects . 5))
        dashboard-show-shortcuts nil
        dashboard-center-content nil
        dashboard-banner-logo-title "Welcome to Beansmacs!"
        dashboard-set-init-info t
        initial-buffer-choice (lambda () (switch-to-buffer "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

(use-package page-break-lines)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package xkcd
  :custom
  (xkcd-cache-dir "~/.cache/xkcd/" "The directory where the comics are stored.")
  (xkcd-cache-latest "~/.cache/xkcd/latest" "The file where the latest cached comics' number is stored."))

(defun my-find-file (&optional arg)
  (interactive "P")
  (if (not arg)
      (find-file (read-file-name "Find File: "))
    (crux-sudo-edit)))

(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir t)))))

(defun dashboard-focus ()
  (interactive)
  (switch-to-buffer "*dashboard*"))

(defvar always-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c d") #'dashboard-focus)
    (define-key map (kbd "C-M-h") #'windmove-left)
    (define-key map (kbd "C-M-l") #'windmove-right)
    (define-key map (kbd "C-M-j") #'windmove-down)
    (define-key map (kbd "C-M-k") #'windmove-up)
    map)
  "Mode map for the Always Key minor mode.")

(define-minor-mode always-keys-minor-mode
  "A minor mode to ensure basic moving-around key bindings are enforced."
  :init-value t)

(use-package emacs
  :init
  (setq enable-recursive-minibuffers t
        gc-cons-threshold 104857600	  ; 100mb
        read-process-output-max 1048576	  ; 1mb
        backup-by-copying t
        backup-directory-alist '(("." . "~/backups/emacs/"))
        delete-old-versions t
        kept-new-versions 3
        kept-old-versions 2
        version-control t
        custom-file (concat user-emacs-directory "custom.el"))
  (when (file-exists-p custom-file)
    (load custom-file))
  (setq-default indent-tabs-mode nil)
  :custom
  (repeat-mode t)
  (safe-local-variable-values
   '((eval set-fill-column 117)
     (lsp-rust-analyzer-cargo-target "x86_64-unknown-none")
     (lsp-rust-all-targets nil)))
  (fill-column 97)
  (warning-suppress-types '((direnv)))
  :config
  (put 'lsp-rust-analyzer-cargo-target 'safe-local-variable #'stringp)
  (put 'lsp-rust-all-targets 'safe-local-variable #'stringp)
  :bind (("C-x C-f" . my-find-file)
         ("C-c r s h" . shrink-window-horizontally)
         ("C-c r s v" . shrink-window)
         ("C-c r e h" . enlarge-window-horizontally)
         ("C-c r e v" . enlarge-window)
         ("C-c k" . kill-current-buffer)
         ("S-<return>" . electric-newline-and-maybe-indent)
         ("C-z" . kill-whole-line)
         ("C-x C-z" . nil)))

(define-key key-translation-map (kbd "C-j") (kbd "DEL"))
(define-key key-translation-map (kbd "M-j") (kbd "M-DEL"))

(defun smart-beginning-of-line (&optional universal-arg)
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive "P")
  (if universal-arg
      (beginning-of-line universal-arg)
    (let ((oldpos (point)))
      (back-to-indentation)
      (if (= oldpos (point))
          (beginning-of-line)))))

(define-key (current-global-map) [remap move-beginning-of-line] #'smart-beginning-of-line)

(setq-default require-final-newline t)

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive (list (read-file-name "New name: " default-directory (buffer-name) nil (buffer-name))))
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun my/comment-or-uncomment ()
  "Comment or uncomment, based on the region."
  (interactive)
  (if (use-region-p)
	(comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))
(global-set-key (kbd "C-x C-o") #'my/comment-or-uncomment)

(defun incr-at-point (&optional arg)
  (interactive "P")
  (let ((n (prefix-numeric-value-arg arg))
        (old-point (point)))
    (unwind-protect
        (progn
          (skip-chars-backward "-0-9")
          (or (looking-at "-[0-9]+")
              (error "No number at point"))
          (replace-match (number-to-string (+ (string-to-number (match-string 0)) n))))
      (goto-char old-point))))

(define-key (current-global-map) (kbd "C-c i") #'incr-at-point)

(use-package flycheck
  :hook (rustic-mode tuareg-mode elisp-mode)
  :custom
  (flycheck-keymap-prefix (kbd "C-c f"))
  :config
  (dolist (flycheck-command '(flycheck-next-error flycheck-previous-error))
    (put flycheck-command 'repeat-map 'flycheck-command-map)))

(use-package flycheck-grammalecte
  :after (flycheck)
  :init (flycheck-grammalecte-setup))

(use-package treesit
  :ensure nil
  :init
  (setq major-mode-remap-alist `((bash-mode . bash-ts-mode)
                                 (c++-mode . c++-ts-mode)
                                 (c-mode . c-ts-mode)
                                 (go-mode . go-ts-mode)
                                 (html-mode . html-ts-mode)
                                 (json-mode . json-ts-mode)
                                 (lua-mode . lua-ts-mode)
                                 (python-mode . python-ts-mode)
                                 ;; (rust-mode . rust-ts-mode)
                                 (toml-mode . toml-ts-mode)
                                 (yaml-mode . yaml-ts-mode)
                                 (css-mode . css-ts-mode)
                                 . ,major-mode-remap-alist)))

(use-package beans)

(use-package rustic
  :after rust-mode
  :hook (rustic-mode . font-lock-mode))

(use-package flycheck-rust
  :commands flycheck-rust-setup
  :hook (flycheck-mode . flycheck-rust-setup))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("\\.py\\'" . python-mode)
  :when (executable-find "ipython")
  :custom
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "--simple-prompt -i")
  (python-shell-prompt-regexp "In \\[[0-9]+\\]: ")
  (python-shell-prompt-output-regexp "Out\\[[0-9]+\\]")
  (python-shell-completion-setup-code "from IPython.core.completerlib import module_completion")
  (python-shell-completion-module-string-code "';'.join(module_completion('''%s'''))\n")
  (python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"))

(use-package lsp-pyright
  :hook
  (python-mode . (lambda ()
                   (require 'lsp-pyright)
                   (lsp)))
  :defer t)

(use-package ocp-indent
  :init
  (setq byte-compile-warnings '(not cl-functions)))

(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")

(use-package tuareg
  :mode
  ("\\.ml\\'" . tuareg-mode)
  ("\\.mli\\'" . tuareg-mode)
  ("\\.mly\\'" . tuareg-menhir-mode)
  :config
  (diminish 'tuareg-mode "🐫"))

(use-package utop
  :hook (tuareg-mode . utop-minor-mode)
  :config
  (setq utop-edit-command nil
        utop-command "dune utop . -- -emacs"))

(use-package dune)

(use-package racket-mode
  :hook racket-xp-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.rkt\\'" . racket-mode)))

(use-package scheme-complete)

(autoload 'bash-completion-dynamic-complete
  "bash completion"
  "BASH completion hook")

(use-package bash-completion
  :init
  (add-hook 'shell-dynamic-complete-functions 'bash-completion-dynamic-complete))

(use-package load-bash-alias
  :config
  (setq load-bash-alias-bashrc-file "~/.bashrc"))

(use-package auctex
  :mode ("\\.tex\\'" . latex-mode)
  :hook ((LaTeX-mode . (lambda () (run-hooks 'prog-mode-hook)))
         (LaTeX-mode . flyspell-mode))
  :ensure auctex
  :custom
  (TeX-engine 'luatex)
  (LaTeX-begin-regexp "begin\\b\\|\\[\\|\\If\\b\\|\\ForRange\\b\\|\\For\\b\\|\\Procedure\\b\
\\|\\While\\b\\|\\Loop\\b")
  (LaTeX-end-regexp "end\\b\\|\\]\\|\\EndIf\\|\\EndFor\\b\\|\\EndProcedure\\b\\|\\EndWhile\\b\
\\EndLoop\\b")
  (TeX-source-correlate-mode t)
  (TeX-view-program-selection '(((output-dvi has-no-display-manager) "dvi2tty")
                                (output-dvi style-pstricks)
                                (output-dvi "xdvi")
                                (output-pdf "Zathura")
                                (output-html "xdg-open"))))
(use-package company-auctex
  :hook (LaTeX-mode . company-mode)
  :init
  (company-auctex-init))

(use-package typst-ts-mode
  :after (lsp-mode)
  :ensure nil
  :hook (typst-ts-mode . (lambda () (run-hooks 'prog-mode-hook)))
  :init
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("tinymist"))
                    :major-modes '(typst-ts-mode)
                    :server-id 'typst)))

(use-package typst-preview
  :ensure nil)

(use-package pandoc-mode
  :commands pandoc-load-default-settings
  :hook markdown-mode
  (pandoc-mode . pandoc-load-default-settings))

(use-package nix-mode
  :after (lsp-mode flycheck)
  :hook (nix-mode . (lambda ()
                      (add-hook 'before-save-hook #'lsp-format-buffer nil 'make-it-local)))
  :init
  (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                    :major-modes '(nix-mode)
                    :server-id 'nix))
  :config
  (diminish 'flycheck-mode)
  (define-key nix-mode-map (kbd "C-c n") #'helm-nixos-options))

(use-package direnv
  :commands direnv-update-environment
  :hook (prog-mode . direnv-update-environment)
  :config
  (direnv-mode)
  :custom
  (direnv-always-show-summary nil))

(use-package j-mode
  :mode "\\.ijs\\'"
  :hook (j-mode . (lambda ()
                    (run-hooks 'prog-mode-hook)
                    (rainbow-delimiters-mode-disable)))
  :config
  (setq j-console-cmd "jconsole")
  (put 'j-other-face 'face-alias 'font-lock-keyword-face)
  (put 'j-verb-face 'face-alias 'font-lock-keyword-face)
  (put 'j-adverb-face 'face-alias 'font-lock-preprocessor-face)
  (put 'j-conjunction-face 'face-alias 'j-adverb-face))

(use-package yuck-mode)

;; (use-package prolog)
(use-package ediprolog)

(use-package proof-general
  :hook (proof-mode . font-lock-mode))
(use-package company-coq
  :hook (coq-mode . company-coq-mode))

(use-package lean4-mode
  :ensure nil
  :bind (:map lean4-mode-map
              ("<backtab>" . #'lean4-eri-indent-reverse)
              ("<tab>" . #'lean4-eri-indent))
  :hook
  (lean4-mode . (lambda ()
                  (setq-local lsp-semantic-tokens-enable nil)
                  (electric-indent-local-mode 1))))

(load-file (let ((coding-system-for-read 'utf-8))
             (shell-command-to-string "agda-mode locate")))

(use-package prog-mode
  :ensure nil
  :hook
  (prog-mode . (lambda () (setq-local display-line-numbers 'relative)))
  ;; (prog-mode . #'display-fill-column-indicator-mode)
  )

(add-to-list 'load-path "~/.emacs.d/llvm-mode")
(require 'llvm-mode)
(require 'tablegen-mode)

(use-package verilog-mode
  :after lsp-mode
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("svls"))
                    :major-modes '(verilog-mode)
                    :priority -1))
  (add-to-list 'lsp-language-id-configuration '(verilog-mode . "verilog"))
  (setq verilog-tool 'verilog-linter
        verilog-linter "svlint"))

(use-package kbd-mode
  :ensure nil)

(use-package lua-mode)

(use-package koka-mode
  :ensure nil)

(use-package smartparens
  :init
  (require 'smartparens-config)
  :config
  (defun my/indent-after-newline (&rest whatever)
    (interactive)
    (newline)
    (indent-according-to-mode)
    (forward-line -1)
    (indent-according-to-mode))
  (dolist (chr '("{" "[" "("))
    (sp-local-pair 'prog-mode chr nil :post-handlers '((my/indent-after-newline "RET"))))
  :hook
  ((emacs-lisp-mode racket-mode) . smartparens-strict-mode)
  (prog-mode . smartparens-mode))

(use-package web-mode)

(use-package esup)

(use-package yaml-mode
  :mode "\\.yaml\\'")

(use-package toml-mode
  :mode "\\.toml\\'")

(use-package json-mode
  :mode "\\.json\\'")

(use-package diminish)

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (diminish 'company-mode)
  (bind-key [remap completion-at-point] #'company-complete company-mode-map)
  (setq company-show-numbers nil
        company-tooltip-align-annotations t
        company-idle-delay 0
        company-minimum-prefix-length 3))

(use-package projectile
  :hook (prog-mode . projectile-mode)
  :config
  (diminish 'projectile-mode))

(setq font-lock-global-modes '(not speedbar-mode))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(use-package ace-window
  :config
  (setq aw-keys '(?q ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind ("M-o" . ace-window))

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(use-package jump-char
  :bind (("M-h" . jump-char-forward)
	   ("M-m" . jump-char-backward))
  :config
  (setq jump-char-forward-key nil
	  jump-char-backward-key nil))

(use-package hledger-mode
  :mode ("\\.journal\\'" "\\.hledger\\'")
  :config
  (add-to-list 'company-backends 'hlodger-backend))

(use-package flycheck-hledger
  :after (flycheck hledger))

(use-package embrace
  :bind (("C-," . embrace-commander))
  :hook
  (org-mode . embrace-org-mode-hook)
  (LaTeX-mode . embrace-LaTeX-mode-hook))

(use-package expand-region
  :bind (("M-'" . er/expand-region)))

(use-package which-key
  :config
  (diminish 'which-key-mode)
  (which-key-mode t))

(defun my/text-scale-adjust-latex-previews ()
  "Adjust the size of the latex preview fragments when changing the
buffer's text scale."
  (pcase major-mode
    ('latex-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'category)
               'preview-overlay)
           (my/text-scale--resize-fragment ov))))
    ('org-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'org-overlay-type)
               'org-latex-overlay)
           (my/text-scale--resize-fragment ov))))))

(defun my/text-scale--resize-fragment (ov)
  (overlay-put
   ov 'display
   (cons 'image
         (plist-put
          (cdr (overlay-get ov 'display))
          :scale (+ 1.0 (* 0.25 (- text-scale-mode-amount 2)))))))

(use-package org
  :hook
  (text-scale-mode . my/text-scale-adjust-latex-previews)
  (org-mode . (lambda () (setq-local backup-by-copying t)))
  :custom
  (org-agenda-start-on-weekday 1)
  (org-agenda-files '("~/org/reading.org"))
  (org-file-apps '((auto-mode . emacs)
                   (directory . emacs)
                   ("\\.pdf\\'" . "zathura %s")))
  :config
  (setq org-modules '(ol-bbdb ol-bibtex ol-docview ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m)
        org-preview-latex-default-process 'dvisvgm)
  :custom-face
  (org-level-1 ((t (:inherit outline-1 :height 1.25))))
  (org-level-2 ((t (:inherit outline-1 :height 1.2))))
  (org-level-3 ((t (:inherit outline-1 :height 1.15))))
  (org-level-4 ((t (:inherit outline-1 :height 1.1))))
  (org-level-5 ((t (:inherit outline-1 :height 1.05)))))

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :init (setq org-auto-tangle-default t))

(use-package pdf-tools)

(defun my/ebib-create-org-file-link (key db)
  "Create an org link to the file in entry KEY in DB.
The file is taken from the \"file\" field in the entry designated by KEY
in the current database.  If that field contains more than one file
name, the user is asked to select one.  If the \"file\" field is empty,
return the empty string.
This function differs from `ebib-create-org-file-link' because it adds a
description to the link."
  (let ((files (ebib-get-field-value "file" key db 'noerror 'unbraced 'xref)))
    (if files
        (let* ((absolute-path (ebib--expand-file-name
                               (funcall ebib-file-name-mod-function (ebib--select-file files nil key) nil)
                               ebib-file-search-dirs))
               (relative-path (file-relative-name absolute-path default-directory))
               (abbreviated-path (abbreviate-file-name absolute-path))
               (final-path
                (cl-case ebib-link-file-path-type
                  (relative relative-path)
                  (adaptive (if (string-match (concat "^" (regexp-quote default-directory))
                                              absolute-path)
                                relative-path
                              abbreviated-path))
                  (otherwise absolute-path)))
               (title (ebib-create-org-title key db)))
          (format "[[file:%s][%s]]" final-path title))
      "")))

(defun my/ebib-create-org-abstract (key db)
  "Return an abstract for an Org mode for KEY in DB.
The abstract is formed from the title of the entry."
  (ebib-get-field-value "abstract" key db 'noerror 'unbraced 'xref 'expand-strings 'org))

(defun my/ebib-name-transform-function (key &optional db)
  (let* ((dbs (or db ebib--cur-db))
         (file (ebib-get-field-value "file" key dbs nil 'unbraced 'xref)))
    (string-trim-right file "\\.pdf")))

(defun my/ebib-create-note-file (key db)
  (concat (my/ebib-name-transform-function key db) "." ebib-notes-file-extension))

(use-package ebib
  :bind ("C-c b" . ebib)
  :custom
  (bibtex-autokey-year-title-separator "/")
  (ebib-bibtex-dialect 'biblatex)
  (ebib-file-associations '(("pdf" . "zathura") ("ps" . "gv")))
  (ebib-file-search-dirs '("~/org/papers"))
  (ebib-reading-list-template-specifiers
    '((?K . ebib-reading-list-create-org-identifier)
      (?T . ebib-create-org-title)
      (?M . ebib-reading-list-todo-marker)
      (?L . ebib-create-org-link)
      (?F . my/ebib-create-org-file-link)
      (?D . ebib-create-org-doi-link)
      (?U . ebib-create-org-url-link)
      (?A . my/ebib-create-org-abstract)))
  (ebib-reading-list-file "~/org/reading.org"))

(use-package biblio)

(use-package ebib-biblio
  :ensure nil
  :after (ebib biblio)
  :bind (:map ebib-index-mode-map ("B" . ebib-biblio-import-doi)
         :map biblio-selection-mode-map ("e" . ebib-biblio-selection-import)))

(use-package org-edna)

(defun org-edna-finder/tolp (olp)
  "Finder for heading by its outline path.

Edna Syntax: tolp(\"OLP\")

Finds the heading given by OLP in the current file.  OLP is an outline
path.  Example:

* TODO Test
:PROPERTIES:
:BLOCKER:  tolp(\"path/to/heading\")
:END:

Test will block if the heading \"path/to/heading\" in the current file
is not DONE."
  (let ((marker (org-find-olp (list olp) t)))
    (when (markerp marker)
      (list marker))))

(use-package org-modern
  :after (org)
  :hook (org-mode . org-modern-mode))

(use-package ox-hugo)

(use-package lsp-mode
  :after (direnv)
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-log-io nil)
  :config
  (diminish 'lsp-lens-mode)
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  (setq lsp-file-watch-ignored '("[/\\\\]build$"
                                 "[/\\\\].lake$"
                                 "[/\\\\]\\.direnv$"
                                 "[/\\\\]target$"
                                 "[/\\\\]\\.git")
        lsp-enable-suggest-server-download nil)
  :hook ((python-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (typst-ts-mode . lsp-deferred)
         (tuareg-opam-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (haskell-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (verilog-mode . lsp-deferred)
         (tuareg-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package yasnippet
  :bind (("M-n" . yas-next-field)
         ("M-p" . yas-prev-field)
         ("<C-return>" . yas-exit-snippet))
  :hook
  ((prog-mode org-mode) . yas-minor-mode)
  :config
  (diminish 'yas-minor-mode)
  (setq yas-verbosity 1
        yas-wrap-around-region t
        yas-snippet-dirs '(yasnippet-snippets-dir))
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "M-<tab>") #'yas-expand))

(use-package yasnippet-snippets)

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(setq password-cache-expiry nil)

(use-package auth-source
  :ensure nil
  :custom
  (auth-source-save-behavior nil))

(setq save-place-mode t)

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package crux
  :bind (("C-c e" . crux-eval-and-replace)))

(use-package magit
  :bind (("C-x g" . magit-status)
	   ("C-x M-g" . magit-dispatch)
	   ("C-C M-g" . magit-file-dispatch)))

(use-package eldoc
  :config
  (diminish 'eldoc-mode))

(use-package eshell
  :ensure nil
  :bind (("<f1>" . eshell)))

(use-package unison-mode)

(use-package pass
  :bind (("C-c p" . pass)))
(use-package pinentry)

(use-package deadgrep
  :bind ("<f5>" . deadgrep))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))
