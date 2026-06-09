;; -*- lexical-binding: t; -*-

(require 'org)

(delete-file (expand-file-name "settings.el"
			       user-emacs-directory))

(org-babel-load-file
 (expand-file-name "settings.org"
                   user-emacs-directory))
