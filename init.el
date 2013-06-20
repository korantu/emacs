;; Should be load-library'd from a ~/.emacs.

;; no startup msg  
(setq inhibit-startup-message t)

;; Where are we.
(if load-file-name
    (setq init-place (file-name-directory load-file-name)))

(setq elisp-place (concat init-place "elisp"))

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

; Proper buffer naming: http://www.emacswiki.org/emacs/uniquify
(toggle-uniquify-buffer-names 1) 

;; Color settings. 
(ansi-color-for-comint-mode-on)
(set-background-color "light grey")

;; Key bindings.
(global-set-key (kbd "C-z") 'undo)
(global-set-key "\M-/" 'hippie-expand)
(global-set-key "\M-g" 'goto-line)
(global-set-key (kbd "M-SPC") 'compile)

(global-set-key (kbd "C-c o") 'ff-find-other-file)

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
	      '("chrome" "chromium-browser" "firefox")))

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

(add-to-list 'load-path elisp-place)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories 
	     (concat elisp-place "ac-dict"))
(ac-config-default)

;; gofmt before save
(add-hook 'before-save-hook #'gofmt-before-save)

;; gocode autocomplete
(require 'go-autocomplete)
(require 'auto-complete-config)

;; go highlighting
(require 'go-mode-load)

;; go flymake
;; From https://gist.github.com/lstoll/2411499

;; org-mode, a-shell: link (async)
(require 'org)
(defun async-open (x) (interactive "s") (async-shell-command x))
(org-add-link-type "a-shell" 'async-open)

(require 'flymake)
 
(defun flymake-go-init ()
(let* ((temp-file (flymake-init-create-temp-buffer-copy
'flymake-create-temp-inplace))
(local-file (file-relative-name
temp-file
(file-name-directory buffer-file-name))))
(list "go" (list "build" "-o" "/dev/null" temp-file))))
;(list "go" (list "build" "-o" "/dev/null" temp-file))))
 
(push '(".+\\.go$" flymake-go-init) flymake-allowed-file-name-masks)
 
(add-hook 'go-mode-hook 'flymake-mode)

;; Fullscreen ( from http://stackoverflow.com/questions/815239/how-to-maximize-emacs-on-windows-at-startup)
(defun toggle-fullscreen-linux ()
  "toggles whether the currently selected frame consumes the entire display
or is decorated with a window border"
  (interactive)
  (let ((f (selected-frame)))
    (modify-frame-parameters 
     f
     `((fullscreen . ,(if (eq nil (frame-parameter f 'fullscreen)) 
                          'fullboth
                        nil))))))

;; QT Help; inspired by http://www.emacswiki.org/emacs/QtMode
;;   and http://furius.ca/pubcode/pub/conf/lib/elisp/blais/qtdoc.el
;; ido-completing-read is nicer.

(defvar qt-help-location "/usr/share/doc/qt4-doc-html/html" "Location of Qt documentation *.html files")

(setq qt-class-names
      (let* 
	  ((a-class (lambda (x) (and
				 (string-match-p "^q" x)
				 (> (length x) 4))))
	   (make-nicer (lambda (x) (replace-regexp-in-string "\.html$" "" x))))
	(let*
	    ((all-pages (if (file-exists-p qt-help-location) 
			    (directory-files qt-help-location) 
			  (progn (message "Qt documentation not found. Please customize qt-help-location var.") '())))
	     (classes (delete-if (lambda (x) (not (funcall a-class x))) all-pages)))
	  (mapcar make-nicer classes))))

(defun qt-class-name-to-path (x) (concat qt-help-location "/" x ".html"))

(defun qt-class-help () (interactive)
  (browse-url 
   (qt-class-name-to-path
    (ido-completing-read "QT:" qt-class-names))))

(global-set-key (kbd "C-c q") 'qt-class-help)

;; From http://emacswiki.org/emacs/FullScreen
(defun toggle-fullscreen-w32 () (interactive) (shell-command (concat init-place "bin/emacs_fullscreen.exe")))

(defun toggle-fullscreen () (interactive) 
  (if (eq system-type 'windows-nt) 
      (toggle-fullscreen-w32) 
    (toggle-fullscreen-linux)))

(global-set-key [f12] 'toggle-fullscreen)

(toggle-fullscreen)

;; Servers
(server-start)
(setenv "EDITOR" "emacsclient")

(message "Dot-emacs loading complete.")
;; More inspiration (browse-url "http://www.mygooglest.com/fni/.emacs")
