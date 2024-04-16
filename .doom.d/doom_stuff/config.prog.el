;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; You do not need to run 'doom sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Matematleta"
       user-mail-address "ptoppo@gmail.com")

;; Centaur tabs
(after! centaur-tabs
  (setq centaur-tabs-style "wave"))

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
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

(defun my/pretty-symbols ()
  (setq prettify-symbols-alist
          '(("#+begin_src python" . "🐍")
            ("#+begin_src elisp" . "λ")
            ("#+begin_src jupyter-python" . "🐍")
            ("#+end_src" . "―")
            ("#+results:" . "🔨")
            ("#+RESULTS:" . "🔨"))))

(global-prettify-symbols-mode +1)

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)

;; red is too aggressive, so let's make it orange
  '(doom-modeline-buffer-modified :foreground "orange"))

;; add padding and height to the modeline
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches follow buffer-info remote-host buffer-position word-count parrot selection-info)
    '(objed-state misc-info persp-name battery grip irc mu4e gnus github debug repl lsp minor-modes input-method indent-info buffer-encoding major-mode process vcs checker "  ")))

(setq doom-modeline-height 40)
;; add the battery status to our modeline.
(after! doom-modeline
  (let ((battery-str (battery)))
    (unless (or (equal "Battery status not available" battery-str)
                (string-match-p (regexp-quote "unknown") battery-str)
                (string-match-p (regexp-quote "N/A") battery-str))
      (display-battery-mode 1))))

(setq display-time-format "%I:%M")



;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. 
(setq doom-theme 'doom-gruvbox)

(setq
 doom-font (font-spec :family "Iosevka" :size 28)
 doom-variable-pitch-font (font-spec :family "Libre Baskerville")
 doom-serif-font (font-spec :family "Libre Baskerville"))

;; Thin grey line separating windows
(set-face-background 'vertical-border "grey")
(set-face-foreground 'vertical-border (face-background 'vertical-border))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Display mode with letter instead of icon
(setq doom-modeline-modal-icon nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; force doom to open at dashboard
(setq doom-fallback-buffer-name "*dashboard*")
(setq fancy-splash-image (concat doom-private-dir "splash.png"))
;;
;; set opacity of frames
(add-to-list 'default-frame-alist '(alpha-background . 80))

;; backup files
(setq auto-save-default t
      make-backup-files t)


;; Move cursor past last character with S-$
(setq evil-move-beyond-eol t)
;;
;; Show status bar always
;;(after! core-ui (menu-bar-mode 1))
(menu-bar-mode 1)

;; enable toolbar
(tool-bar-mode  1)

;; Display time
(display-time-mode 1)

;; Install pdf-view package
(use-package! pdf-view
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

(setq display-line-numbers-type t)
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
;;
(unless (display-graphic-p)
          (require 'evil-terminal-cursor-changer)
          
          (evil-terminal-cursor-changer-activate) ; or (etcc-on)
          )

(setq evil-default-cursor t) ;; Now evil takes the default cursors 
(setq evil-normal-state-cursor '(box "light blue")
      evil-insert-state-cursor '(bar "medium sea green")
      evil-visual-state-cursor '(hollow "orange"))


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
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))
;; moving lines up and down plugin
(drag-stuff-global-mode 1)
;; To activate the suggested key-bindings, <M-up>, <M-down>, <M-right>, <M-left>, use:
(drag-stuff-define-keys)

(setq doom-themes-treemacs-theme "doom-colors")

;;----------------------------------------------------------------------------------------------------
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


        (global-set-key (kbd "M-q") #'quit-window)
        (global-set-key (kbd "M-w") #'save-buffer)

;;----------------------------------------------------------------------------------------------------
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

;;----------------------------------------------------------------------------------------------------
(map! :leader
      :desc " save "      "w w" #'save-buffer)

(map! :leader
      :desc " save and quit "      "w q" #'save-buffers-kill-emacs)
;----------------------------------------------------------------------------------------------------;
(define-key evil-normal-state-map (kbd "RET") 'newline)
;;---------------------------------------------------------------------------------------------------
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
    (:prefix "w"
      :desc "Hydra resize" :n "SPC" #'doom-window-resize-hydra/body))
;;----------------------------------------------------------------------------------------------------
;;default to splitting to the right or to the bottom of the frame. Also, ask me what buffer to use in the newly created window.
;; do the splits
(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))
;;----------------------------------------------------------------------------------------------------;
;; I like prompt prompts
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0.0)
(setq company-tooltip-align-annotations t)
(setq company-selection-wrap-around t)
;---------------------------------------------------------------------------------------------------
;; delete the selection when pasting
(delete-selection-mode 1)
;----------------------------------------------------------------------------------------------------;
;; This changes the icons used for closing a tab and for showing when a buffer has unsaved changes.
(setq centaur-tabs-close-button ""
      centaur-tabs-modified-marker ""
      centaur-tabs-set-bar 'over)
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
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
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
