;;----------------
;;GENERAL SETTINGS
;;----------------
(setq inhibit-startup-message t
      visible-bell t
      use-dialog-box nil)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq-default display-line-numbers-type 'absolute)
(global-display-line-numbers-mode 1)
(recentf-mode 1)
(setq-default recentf-max-menu-items 50)
(global-auto-revert-mode 1)
(save-place-mode 1)
(desktop-save-mode 1)
(setq-default display-fill-column-indicator-column 80)
(global-display-fill-column-indicator-mode 1)
(column-number-mode 1)

;;Mac keybindings
(custom-set-variables
 '(ns-command-modifier 'meta)
 '(ns-alternate-modifier 'meta)
 '(ns-right-alternate-modifier 'none))

;;-----------------------------
;;SET AND LOAD CUSTOM VARS FILE
;;-----------------------------
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
;; Put all backups in ~/.emacs.d/backups/
(setq backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
(setq backup-by-copying t)
;; Put autosave files in ~/.emacs.d/autosaves/
(make-directory "~/.emacs.d/autosaves/" t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/" t)))

;;------
;;THEMES
;;------
(load-theme 'deeper-blue t)
;(load-theme 'wombat t)

;;------------------
;;PACKAGE MANAGEMENT
;;------------------
(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
	("melpa" . "https://melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;------------------
;;INSTALLED PACKAGES
;;------------------

;(use-package benchmark-init
;  :ensure t
;  :config
;  (benchmark-init/activate)
;  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package project
  :defer t)

(use-package xref
  :defer t)

(use-package etags
  :defer t)

(setq byte-compile-warnings '(not lexical-binding))
(use-package exec-path-from-shell
  :ensure t
  :commands (exec-path-from-shell-initialize)
  :config
  (exec-path-from-shell-copy-env "PATH")
  (exec-path-from-shell-initialize)
  :init(setq exec-path-from-shell-arguments '("-l")))

;;YAML
(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))

;;JSON
(use-package json-mode
  :ensure t
  :mode ("\\.json\\'" . json-mode))

;;COMPANY
(use-package company
  :ensure t
  :hook
  (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1))

;;Ocaml
(use-package tuareg
  :ensure t
  :mode ("\\.ml\\'" . tuareg-mode)
  :init
  (add-to-list 'load-path "~/.opam/default/share/emacs/site-lisp")
  :hook
  ((tuareg-mode . (lambda ()
		    (require 'merlin)
		    (merlin-mode)
		    (company-mode))))
  :config
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'merlin-company-backend)))

;; PYTHON
(use-package eglot
  :ensure t
  :hook
  ((python-mode . eglot-ensure))
  :config
  ;; Register pylsp as the Python LSP server
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp"))))

;;C / C++
(use-package eglot
  :ensure t
  :mode ("\\.c\\'" . c-mode)
  :hook
  ((c-mode . eglot-ensure)
   (c++-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
   '(c-mode c++-mode . ("clangd"))))

;;Common Lisp
(use-package slime
  :ensure t
  :mode ("\\.lisp\\'" . lisp-mode)
  :commands (slime slime-connect)
  :init
  (setq inferior-lisp-program "sbcl"
	slime-contribs '(slime-fancy))
  :hook (lisp-mode . slime-mode)
  :config
  (add-hook 'lisp-mode-hook #'slime-mode))

(use-package slime-company
  :ensure t
  :after (slime company)
  :config
  (slime-setup '(slime-fancy slime-company)))
