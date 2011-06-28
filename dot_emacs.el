;; Got to LOVE minimalism.
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

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
(global-set-key "\M-`" 'hippie-expand)
;; Browser
(setq 
 browse-url-browser-function 'browse-url-generic 
 browse-url-generic-program "chromium-browser") 

;;TODO
;; JavaScript check: http://www.emacswiki.org/emacs/FlyMake#toc9

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
