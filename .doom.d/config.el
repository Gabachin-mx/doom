;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(beacon-mode 1)
(xclip-mode 0)
(focus-mode 0)
(menu-bar-mode -1)
(scroll-bar-mode 0)
(tool-bar-mode 0)

(delete-selection-mode 1)    ;; You can select text and delete it by typing.
;;
(require 'smartparens-config)
;; Always start smartparens mode in js-mode.
(add-hook 'js-mode-hook #'smartparens-mode)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq large-file-warning-threshold nil)
;; set which-key toption
(which-key-setup-side-window-bottom)
(which-key-setup-minibuffer)
(setq which-key-popup-type 'side-window)

(line-number-mode 1)
(column-number-mode 1)
(setq max-mini-window-height 1)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq history-length 25 )
(savehist-mode 1)

(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)

;; disable test is read only
(defun my-command-error-function (data context caller)
  "Ignore the buffer-read-only signal; pass the rest to the default handler."
  (when (not (eq (car data) 'text-read-only))
    (command-error-default-function data context caller)))

(add-to-list 'display-buffer-alist
             '("^\\*.*\\*$" . (display-buffer-below-selected))
             '("." nil (reusable-frames . t)))

(setq command-error-function #'my-command-error-function)

;; Emacs system customizations go on a separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; autosave in tmp directory
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq backup-directory-alist
    `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
    `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
    emacs-tmp-dir)

;; no lockfiles
(setq create-lockfiles nil)

;; Enable auto pairs
(electric-pair-mode 1)

;; Enable visual-line-mode for word wrap
(global-visual-line-mode t)

;;Standard indentation & no tabs
(setq standard-indent 2)
(setq-default indent-tabs-mode nil)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;
(setq doom-font (font-spec :family "Fira Code" :size 22 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Hack" :srze 22))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;;
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-one)
(custom-set-faces
'(default ((t (:background "#1a1a1a" :foreground "#a9b1d6")))))

;; :q kills current buffer
(map!
 [remap evil-quit] #'kill-current-buffer)

(map! :leader
      :desc "Load new theme" "h t" #'counsel-load-theme)

(setq doom-one-brighter-comments t
      doom-one-comment-bg nil)

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)

;; red is too aggressive, so let's make it orange
  '(doom-modeline-buffer-modified :foreground "orange"))

 ;; opacity
;; (set-frame-parameter nil 'alpha-background 70)
;; (add-to-list 'default-frame-alist '(alpha-background . r0))
(add-to-list 'default-frame-alist '(alpha . 70))

 (defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(75 . 50) '(100 . 100)))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)


(setq doom-modeline-height 40)
;; add the battery status to our modeline.
(after! doom-modeline
  (let ((battery-str (battery)))
    (unless (or (equal "Battery status not available" battery-str)
                (string-match-p (regexp-quote "unknown") battery-str)
                (string-match-p (regexp-quote "N/A") battery-str))
      (display-battery-mode 1))))
(display-time-mode 1) ; show time and date
(setq display-time-format "%Y-%m-%d %H:%M") ; time and date format

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'neotree-toggle
      :desc "Open directory in neotree"  "d n" #'neotree-dir)

(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

;; split winodws vertically by default
(setq
   split-width-threshold 0
   split-height-threshold nil)

;; open new buffers in same window
(add-to-list 'display-buffer-alist
	      '(display-buffer-reuse-window display-buffer-same-window))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-mode 'relative)

;; Display mode with letter instead of icon
(setq doom-modeline-modal-icon nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; force doom to open at dashboard
(setq doom-fallback-buffer-name "*dashboard*")
 (setq fancy-splash-image "~/.doom.d/themes/true.png")
 (setq +doom-dashboard-pwd-policy "~")


(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))) ;; necessary for emacsclient
;;
(setq dashboard-startup-banner "~/.doom.d/themes/true.png")

;; backup files
(setq auto-save-default t
      make-backup-files t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; Move cursor past last character with S-$
(setq evil-move-beyond-eol t)
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;;
;;
(defun display-buffer-same-window (buffer alist)
  (unless (or (cdr (assq 'inhibit-same-window alist))
              (window-minibuffer-p)
              (window-dedicated-p))
    (window--display-buffer buffer (selected-window) 'reuse alist)))
;;
;;
(use-package dired
;;  ..other setup stuff here..
  :config
  (use-package all-the-icons-dired
    :if (display-graphic-p)
    :hook (dired-mode . all-the-icons-dired-mode)
    :config (setq all-the-icons-dired-monochrome nil))
  (use-package treemacs-icons-dired
    :if (display-graphic-p)
    :config (treemacs-icons-dired-mode))
  )
;;
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
;;
(use-package dired-subtree :ensure t
  :after dired
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))

(use-package pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35")))

(use-package! dired-hide-dotfiles
  :after dired
  :hook (dired-mode . dired-hide-dotfiles-mode)

  :config
  (map! :map dired-mode-map
        :desc "Hide dot files"   :n "zo" (lambda () (interactive) (dired-hide-dotfiles-mode 0))
        :desc "Show dot files"   :n "zm" (lambda () (interactive) (dired-hide-dotfiles-mode 1))
        :desc "Toggle dot files" :n "za" #'dired-hide-dotfiles-mode
        :desc "Toggle dot files" :n "z." #'dired-hide-dotfiles-mode))

(use-package! peep-dired
  :after dired
  :config
  (add-hook 'peep-dired-hook 'evil-normalize-keymaps)
  (map! :map dired-mode-map
        :desc "Preview a file" :n "p" #'peep-dired

        :map peep-dired-mode-map
        :desc "Preview next file"        :n "kk" #'peep-dired-prev-file
        :desc "Preview prev file"        :n "jj" #'peep-dired-next-file
        :desc "Scroll preview pane up"   :n "C-k" #'peep-dired-scroll-page-up
        :desc "Scroll preview pane down" :n "C-j" #'peep-dired-scroll-page-down)

  (setq
   peep-dired-cleanup-eagerly nil
   peep-dired-cleanup-on-disable t))


;; - `after!' for running code after a package has loaded
;;
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new kers
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(defun my-split-vertical ()
    (interactive)
    (split-window-vertically)
    (other-window 1))

(defun my-split-horizontal ()
    (interactive)
    (split-window-horizontally)
    (other-window 1))

(global-set-key (kbd "C-x C-v") 'my-split-vertical)
(global-set-key (kbd "C-x C-h") 'my-split-horizontal)

(setq display-line-numbers-type 'relative)
(map! :leader
      :desc "Comment or uncomment lines"      "TAB TAB" #'comment-line
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines))

;;Exit insert mode by pressing k and then j quickly
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
(key-chord-define evil-visual-state-map "kj" 'evil-normal-state)
(key-chord-mode 1)

;; ;; change cursor color and shape, depending on the mode

(setq evil-normal-state-cursor '(box "dodger blue")
      evil-insert-state-cursor '(bar "medium sea green")
      evil-visual-state-cursor '(hollow "orange"))

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(map! :leader
      (:prefix ("c h" . "Help info from Clippy")
       :desc "Clippy describes function under point" "f" #'clippy-describe-function
       :desc "Clippy describes variable under point" "v" #'clippy-describe-variable))

(use-package evil-terminal-cursor-changer
:ensure t
:init
(setq evil-motion-state-cursor 'box)  ; █
;; (setq evil-visual-state-cursor 'box)  ; █
;; (setq evil-normal-state-cursor 'box)  ; █
;; (setq evil-insert-state-cursor 'bar)  ; ⎸
(setq evil-emacs-state-cursor  'hbar) ; _
:config
(evil-terminal-cursor-changer-activate))

; make ESC quit everything
(defun minibuffer-keyboard-quit ()
(interactive)
(if (and delete-selection-mode transient-mark-mode mark-active)
    (setq deactivate-mark  t)
(when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
(abort-recursive-edit)))

(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; autoconplete
(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-global-modes '(not org-mode)))

(define-key company-mode-map (kbd "TAB") 'company-complete)

(use-package emojify
  :ensure t
  :init
    (add-hook 'after-init-hook #'global-emojify-mode)
    (setq emojify-display-style 'unicode))

(use-package yaml-mode :ensure t)

;; Type script
(use-package tide
  :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(setq tide-tsserver-executable "node_modules/.bin/tsserver")

(add-hook 'web-mode-hook #'setup-tide-mode)



(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file"           "d v" #'dired-view-file)))


(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I setrall .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

;; movig lines up and down plugin
(drag-stuff-global-mode 1)
;; To activate the suggested key-bindings, <M-up>, <M-down>, <M-right>, <M-left>, use:
(drag-stuff-define-keys)

(setq doom-themes-treemacs-theme "doom-colors")

;; movig lines up and down plugin
(drag-stuff-global-mode 1)
;; To activate the suggested key-bindings, <M-up>, <M-down>, <M-right>, <M-left>, use:
(drag-stuff-define-keys)

    (defun kill-dired-buffers ()
	 (interactive)
	 (mapc (lambda (buffer)
           (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
             (kill-buffer buffer)))
         (buffer-list)))

    (defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

    (map! :leader
   :desc "kill-dired-buffers"      "k" #'kill-dired-buffers
   :desc "kill-non-dired-buffers"      "K" #'kill-other-buffers)


        (global-set-key (kbd "M-Q") #'quit-window)
        (global-set-key (kbd "M-W") #'save-buffer)


;; make :q and :wq work the way I like them (thanks ChatGPT)
(defun my-kill-buffer-or-window ()
  "Kill the buffer, or close the window if there's only one.
   Prompts to save the buffer if it's unsaved."
  (interactive)
  (if (one-window-p)
      (progn
        (when (and (buffer-modified-p)
                   (eq (read-char-choice
                        "Buffer modified. Save buffer? (y/n/C)"
                        '(?y ?n ?C))
                       ?y))
          (save-buffer))
        (kill-buffer))
    (delete-window)))


(evil-ex-define-cmd "q[uit]" 'my-kill-buffer-or-window)

(defun my-evil-save-and-close ()
  (interactive)
  (save-buffer)
  (my-kill-buffer-or-window)
  )

(evil-ex-define-cmd "wq" 'evil-save-and-close)

(map! :leader
      :desc " save "      "w w" #'save-buffer)

(map! :leader
      :desc " save and quit "      "w q" #'save-buffers-kill-emacs)

(define-key evil-normal-state-map (kbd "RET") 'newline)

(map! :leader
      :desc "Zap to char"    "z" #'zap-to-char
      :desc "Zap up to char" "Z" #'zap-up-to-char)
;; Resize windows (requires hydra package)
;;
(defhydra doom-window-resize-hydra (:hint nil)
  "
             _k_ increase height
_h_ decrease width    _l_ increase width
             _j_ decrease height
"
  ("h" evil-window-decrease-width)
  ("j" evil-window-increase-height)
  ("k" evil-window-decrease-height)
  ("l" evil-window-increase-width)

  ("q" nil))

(map!
    (:prefix ";"
      :desc "Hydra resize" :n "SPC" #'doom-window-resize-hydra/body))
;;--------------------------------------------------------------------------

(use-package! openwith
  :after-call pre-command-hook
  :config
  (openwith-mode t)
  (add-to-list 'openwith-associations '("\\.pdf\\'" "qpdfview" (file)))
  (add-to-list 'openwith-associations '("\\.djvu\\'" "qpdfview" (file)))
  (add-to-list 'openwith-associations '("\\.mkv\\'" "mpv" (file)))
  (add-to-list 'openwith-associations '("\\.mp4\\'" "mpv" (file)))
  (add-to-list 'openwith-associations '("\\.mp3\\'" "mpv" (file)))
  (add-to-list 'openwith-associations '("\\.xls\\'" "libreoffice --calc" (file)))
  (add-to-list 'openwith-associations '("\\.xls\\'" "libreoffice --calc" (file)))
  (add-to-list 'openwith-associations '("\\.doc\\'" "libreoffice --writer" (file)))
  (add-to-list 'openwith-associations '("\\.docx\\'" "libreoffice --writer" (file))))

(use-package nix-mode
  :mode "\\.nix\\'")

;; Auto save buffers on focus lost
(add-function :after after-focus-change-function (lambda () (save-some-buffers t)))
;; Exit insert mode on focus loss
(add-function :after after-focus-change-function (lambda () (evil-normal-state)))

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; ;; make unmatched parens stand out more with a strikethrough.
;; (set-face-attribute 'rainbow-delimiters-unmatched-face nil
;;                     :foreground 'unspecified
;;                     :inherit 'show-paren-mismatch
;;                     :strike-through t)

;; (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'c-mode-common-hook 'rainbow-delimiters-mode)

;; ;; Insert closing parens automagically
(use-package elec-pair
  :demand
  :config
  (electric-pair-mode 1))

;; open file as root
(defun do.minimal.misc/sudo-open ()
  "Like `find-file', but with root rights using TRAMP"
  (interactive)
  (let ((file (read-file-name "Open as root: ")))
    (unless (file-writable-p file)
      (find-file (concat "/sudo:root@localhost:" file)))))
;; bind to a key
(global-set-key (kbd "C-x F") #'do.minimal.misc/sudo-open)

    (use-package! xclip
        :config
        (setq xclip-program "wl-copy")
        (setq xclip-select-enable-clipboard t)
        (setq xclip-mode t)
        (setq xclip-method (quote wl-copy)))

(add-hook 'window-setup-hook #'xclip-mode)


(add-to-list 'load-path "~/.doom.d/lisp")

; (use-package welcome-dashboard
;   :ensure nil ;; when using local file and not straight nor use-package
;   :config
;   (setq welcome-dashboard-latitude 56.7365
;         welcome-dashboard-longitude 16.2981 ;; latitude and longitude must be set to show weather information
;         welcome-dashboard-use-nerd-icons t ;; Use nerd icons instead of all-the-icons
;         welcome-dashboard-path-max-length 75
;         welcome-dashboard-use-fahrenheit nil ;; show in celcius or fahrenheit.
;         welcome-dashboard-min-left-padding 10
;         welcome-dashboard-image-file "~/.doom.d/themes/true.png"
;         welcome-dashboard-image-width 200
;         welcome-dashboard-image-height 169
;         welcome-dashboard-title "Hey Paulie")
  ; (welcome-dashboard-create-welcome-hook))

;; ;; use-package with package.el:
;; (use-package dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook))

;; (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

;; set the title
;; (setq dashboard-banner-logo-title "hey paulie")
;; ;; Set the banner
;; (setq dashboard-startup-banner "~/.doom.d/themes/true.png")
;; ;; Value can be
;; ;; - nil to display no banner
;; ;; - 'official which displays the official emacs logo
;; ;; - 'logo which displays an alternative emacs logo
;; ;; - 1, 2 or 3 which displays one of the text banners
;; ;; - "path/to/your/image.gif", "path/to/your/image.png", "path/to/your/text.txt" or "path/to/your/image.xbm" which displays whatever gif/image/text/xbm you would prefer
;; ;; - a cons of '("path/to/your/image.png" . "path/to/your/text.txt")

;; ;; Content is not centered by default. To center, set
;; (setq dashboard-center-content t)
;; ;; vertically center content
;; (setq dashboard-vertically-center-content t)

;; ;; To disable shortcut "jump" indicators for each section, set
;; (setq dashboard-show-shortcuts nil)

;; (setq dashboard-items '((recents   . 5)
;;                         (bookmarks . 5)
;;                         (projects  . 5)
;;                         (agenda    . 5)
;;                         (registers . 5)))

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Use `consult-completion-in-region' if Vertico is enabled.
;; Otherwise use the default `completion--in-region' function.
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))


;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package ivy
  :ensure t
  :demand
  :diminish ivy-mode
  :bind (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window)
   ("C-x b" . ivy-switch-buffer))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  (ivy-use-selectable-prompt t)
  (ivy-fixed-height-minibuffer t)
  ;; :hook
  ;; (ivy-mode . ivy-posframe-mode) ;; see the posframe block below
  :config
  (ivy-mode)
  (setq enable-recursive-minibuffers t))

(use-package ivy-posframe
  :ensure t
  :after ivy
  :diminish ivy-posframe-mode
  :custom-face
  (ivy-posframe ((t (list :background (face-attribute 'default :background)))))
  (ivy-posframe-border ((t (:background "gold"))))
  (ivy-posframe-cursor ((t (:background "gold"))))
  :config
  ;; custom define height of post frame per function
  (setq ivy-posframe-height-alist '((find-file . 13)
            (t         . 13)))
  ;; display at `ivy-posframe-style'
  (setq ivy-posframe-display-functions-alist
  '((complete-symbol   . ivy-posframe-display-at-point)
    (counsel-M-x       . ivy-posframe-display-at-point)
    (helm--dir-file-name       . ivy-posframe-display-at-point)
    (counsel-find-file . ivy-posframe-display-at-window-bottom-left)
    (ivy-switch-buffer . ivy-posframe-display-at-window-bottom-left)
    (t                 . ivy-posframe-display-at-window-bottom-left)))
  ;; other customizations
  (setq ivy-posframe-hide-minibuffer t)
  ;; (setq ivy-posframe-min-width 120)
  ;; (setq ivy-posframe-width 120)
  (setq ivy-posframe-border-width 1)
  (ivy-posframe-mode 1))

(use-package counsel
  :after ivy
  :ensure t
  :demand
  :diminish counsel-mode
  :config
  (counsel-mode 1)
  ;; change default regexes
  (setq ivy-initial-inputs-alist
  '((counsel-minor . "^+")
    (counsel-package . "^+")
    (counsel-org-capture . "")
    (counsel-M-x . "")
    (counsel-describe-function . "")
    (counsel-describe-variable . "")
    (org-refile . "^")
    (org-agenda-refile . "^")
    (org-capture-refile . "^")
    (Man-completion-table . "^")
    (woman . "^"))))

;; (use-package ivy-rich
;;   :after ivy
;;   :ensure t
;;   :demand
;;   :custom
;;   (ivy-virtual-abbreviate 'full
;;         ivy-rich-switch-buffer-align-virtual-buffer t
;;         ivy-rich-path-style 'abbrev)
;;   :config
;;   (setq ivy-rich-parse-remote-buffer nil)
;;   (setq ivy-rich-parse-remote-file-path nil)
;;   (ivy-set-display-transformer 'ivy-switch-buffer
;;        'ivy-rich-switch-buffer-transformer)
;;   (ivy-rich-mode 1))
;;
(require 'ivy-rich)
(ivy-rich-mode 1)

(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

(ivy-rich-modify-column
 'ivy-switch-buffer
 'ivy-rich-switch-buffer-major-mode
 '(:width 20 :face error))

(ivy-rich-modify-columns
 'ivy-switch-buffer
 '((ivy-rich-switch-buffer-size (:align right))
   (ivy-rich-switch-buffer-major-mode (:width 20 :face error))))

(setq ivy-rich-path-style 'full)

(defun ivy-rich-switch-buffer-icon (candidate)
  (with-current-buffer
      (get-buffer candidate)
    (let ((icon (all-the-icons-icon-for-mode major-mode)))
      (if (symbolp icon)
          (all-the-icons-icon-for-mode 'fundamental-mode)
        icon))))

(setq ivy-rich-display-transformers-list
      '(ivy-switch-buffer
        (:columns
         ((ivy-rich-switch-buffer-icon (:width 2))
          (ivy-rich-candidate (:width 30))
          (ivy-rich-switch-buffer-size (:width 7))
          (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
          (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
          (ivy-rich-switch-buffer-project (:width 15 :face success))
          (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
         :predicate
         (lambda (cand) (get-buffer cand)))))

;; open file as root
(defun do.minimal.misc/sudo-open ()
  "Like `find-file', but with root rights using TRAMP"
  (interactive)
  (let ((file (read-file-name "Open as root: ")))
    (unless (file-writable-p file)
      (find-file (concat "/sudo:root@localhost:" file)))))
;; bind to a key
(global-set-key (kbd "C-x F") #'do.minimal.misc/sudo-open)

;; fill to end of line with a single character
(defvar do.minimal.misc/fill-to-end-with-char-col fill-column
  "The value that `fill-to-end' fills the column until.")

(defun fill-to-end-with-char (char)
  "Fill the current line with CHAR from point until the column
  including `do.minimal.misc/fill-to-end-with-char-col'.

When called with a prefix argument, show a prompt asking for the
character to fill with. The default character to fill is '-'."
  (interactive
   (if current-prefix-arg
       (list (let ((input))
               (while (not (= (length input) 1))
                 (setq input (read-string "Fill with character: ")))
               input))
     (list "-")))
  (save-excursion
    (let* ((cur-point (point))
           (cur-point-on-line (- cur-point (point-at-bol)))
           (str-len (- do.minimal.misc/fill-to-end-with-char-col cur-point-on-line))
           (str (make-string str-len (string-to-char char))))
      (goto-char cur-point)
      (insert str))))

 (global-set-key (kbd "C-x E") 'fill-to-end-with-char)

(require 'simpleclip)
(simpleclip-mode 1)

;; C-<insert> simpleclip-copy
;; S-<delete> simpleclip-cut
;; S-<insert> simpleclip-paste
;;
;;Shift+insert to paste into doom may also work

(add-to-list 'default-frame-alist '(alpha-background . 100)) ; For all new frames henceforth

(straight-use-package
  '(app-launcher :type git :host github :repo "SebastienWae/app-launcher"))

 (global-set-key (kbd "C-c d") 'app-launcher-run-app)
