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
