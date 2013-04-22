;; Got to LOVE minimalism.
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Interactively Do Things: 
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(require 'ido)
(ido-mode 1)

;; Niceties
(global-font-lock-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(setq make-backup-files nil) ;; Dangerous, but neat.
(message "Backups are disbled, take note.")

; Proper buffer naming: http://www.emacswiki.org/emacs/uniquify
(toggle-uniquify-buffer-names 1) 

;; Color settings. 
(ansi-color-for-comint-mode-on)
(set-background-color "light grey")

;; Key bindings.
(global-set-key (kbd "C-z") 'undo)
(global-set-key "\M-/" 'hippie-expand)
(global-set-key "\M-g" 'goto-line)

;; hs-mode: http://www.emacswiki.org/emacs/HideShow
(global-set-key (kbd "C-+") 'hs-toggle-hiding)
(global-set-key (kbd "C-\\") 'hs-hide-all)
    (add-hook 'c-mode-common-hook   'hs-minor-mode)
    (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
    (add-hook 'java-mode-hook       'hs-minor-mode)
    (add-hook 'js-mode-hook       'hs-minor-mode)
    (add-hook 'lisp-mode-hook       'hs-minor-mode)

;; Browser
(setq 
 browse-url-browser-function 'browse-url-generic)
;; Choose one that exists here; Low to high priority.
(mapc (lambda (browser)  
	(if browser (setq browse-url-generic-program browser)))
      (mapcar (lambda (f) (locate-file f exec-path))
	      '("firefox" "chrome" "chromium-browser")))

;;TODO
;; JavaScript check: http://www.emacswiki.org/emacs/FlyMake#toc9
(setq js-v8-shell "/home/kdl/tools/v8/d8")

(when (load "flymake" t)
  (defun flymake-closure-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list js-v8-shell (list local-file))))
    
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js\\'" flymake-closure-init)))

;; Load it for javascript.
(add-hook 'js-mode-hook 'flymake-mode)

;; Autocomplete
;; http://cx4a.org/software/auto-complete/manual.html#Installation
;; Downloaded from http://cx4a.org/software/auto-complete/index.html
;; installed by (load-file "~/log/golang/emacs-autocomplete/auto-complete-1.3.1/etc/install.el")

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

;; gocode autocomplete
(require 'go-autocomplete)
(require 'auto-complete-config)

;; go highlighting
(require 'go-mode-load)

;; go flymake
(require 'flymake)
(push '(".+\\.go$" flymake-simple-make-init) flymake-allowed-file-name-masks)
(add-hook 'go-mode-hook 'flymake-mode)

;; Github-specific part:
;; Github sync. 
(setq dot-emacs-at-github  "http://korantu.github.com/emacs/dot_emacs.el")
(defun kdl-sync () 
  "Pull .emacs from github http page."
  (interactive)
  ( let
      ((script (concat "wget -O ~/.emacs " dot-emacs-at-github)))
  (shell-command script))
  (load-library "~/.emacs")
  (message "Sync completed.")
)

;; This is how functions are done.
(defun kdl-test ()
  "Defun test"
  (interactive)
  (message "Hi!"))

(message "Dot-emacs loading complete.")
