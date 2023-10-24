(setq-default inhibit-startup-screen t
	      tab-width 8
	      indent-tabs-mode t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 1)
(column-number-mode 1)

(set-face-attribute 'default nil :height 150)

;; backup file
(setq backup-by-copying t
      backup-directory-alist `(("." . "~/.local/share/emacs/backup"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(when (require 'default-text-scale nil 'noerror)
  (default-text-scale-mode))

(when (require 'nix-mode nil 'noerror)
  (add-hook 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

(when (require 'rainbow-delimiters nil 'noerror)
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode))

(defun rc/duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))
(global-set-key (kbd "C-,") 'rc/duplicate-line)

(defun rc/display-fill-column ()
  (display-fll-column-indicator-mode t))
(add-hook 'c-mode-hook 'rc/display-fill-column)

(custom-set-variables
 '(custom-enabled-themes '(tango-dark))
 '(display-line-numbers 'relative))

(custom-set-faces
 )
