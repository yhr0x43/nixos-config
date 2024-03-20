(setq-default inhibit-startup-screen t
	      tab-width 8
	      indent-tabs-mode t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 1)
(column-number-mode 1)

;; transparency
(set-frame-parameter nil 'alpha-background 70)
(add-to-list 'default-frame-alist '(alpha-background . 70))


(set-face-attribute 'default nil :height 150)

(setq inhibit-startup-screen t)

;; backup file
(setq backup-by-copying t
      backup-directory-alist `(("." . "~/.local/share/emacs/backup"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;; c-mode
(setq-default c-basic-offset 4
	      c-default-style '((java-mode . "java")
				(awk-mode . "awk")
				(other . "bsd")))

(with-eval-after-load 'default-text-scale
  (default-text-scale-mode nil))

(with-eval-after-load 'nix-mode
  (add-hook 'auto-mode-alist '("\\.nix\\'" . nix-mode)))
  
(with-eval-after-load 'rainbow-delimiters
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
  (display-fill-column-indicator-mode t))
(add-hook 'c-mode-hook 'rc/display-fill-column)

(require 'fasm-mode)

;; TeX view program
(with-eval-after-load 'TeX-mode
  (add-to-list 'TeX-view-program-selection '(output-pdf "Zathura")))

;; load this after everything else per recommendation by the author
;; https://github.com/purcell/envrc#usage
(with-eval-after-load 'envrc
  (envrc-global-mode))

(custom-set-variables
 '(custom-enabled-themes '(tango-dark))
 '(display-line-numbers 'relative))

(custom-set-faces
 )
