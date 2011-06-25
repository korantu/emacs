;; Got to LOVE minimalism.
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Color settings. 
(ansi-color-for-comint-mode-on)
(set-background-color "light grey")

;; Key bindings.
(global-set-key (kbd "C-z") 'undo)

;; Browser
(setq 
 browse-url-browser-function 'browse-url-generic 
 browse-url-generic-program "chromium-browser") 

;; Github-specific part:

;; Github sync. 
(setq dot-emacs-at-github  "http://korantu.github.com/emacs/dot_emacs.el")
(defun kdl-sync () 
  "Pull .emacs from github http page."
  (interactive)
  ( let
      ((script (concat "wget -O ~/.emacs " dot-emacs-at-github)))
  (shell-command script)))

;; This is how functions are done.
(defun kdl-test ()
  "Defun test"
  (interactive)
  (message "hi"))


