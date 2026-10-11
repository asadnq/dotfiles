;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;
(add-to-list 'default-frame-alist '(fullscreen . maximized))


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
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-pine)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

;; Initialize today's journal and open it on startup
(defun my/org-open-daily-journal ()
  (let* ((journal-dir (expand-file-name "~/org/journal/"))
         (today (format-time-string "%Y-%m-%d"))
         (journal-file (expand-file-name
                        (concat today ".org")
                        journal-dir)))
    (unless (file-exists-p journal-file)
      (make-directory journal-dir t)
      (with-temp-file journal-file
        (insert
         (format "#+title: Journal - %s\n\n" today)
         "* Personal\n"
         "** Notes\n"
         "** Task\n"
         "* Work\n"
         "** Notes\n"
         "** Task\n")))
    (find-file journal-file)))

(add-hook 'emacs-startup-hook #'my/org-open-daily-journal)

(map! :leader
      :desc "Open today's journal"
      "j j" #'my/org-open-daily-journal)

;; Automatic clock-in and clock-out on state changes
(defun my/org-clock-on-todo-state-change ()
"Automatically manage the clock when a task changes state."
(let ((state org-state))
    (cond
    ;; Start or resume work.
    ((equal state "STRT")
    (org-clock-in))

    ;; Pause or finish the currently clocked task.
    ((member state '("WAIT" "HOLD" "DONE" "KILL"))
    (when (and (org-clock-is-active)
                (save-excursion
                    (org-back-to-heading t)
                    (equal (point)
                        (marker-position org-clock-marker))))
        (org-clock-out)))))

(add-hook 'org-after-todo-state-change-hook
        #'my/org-clock-on-todo-state-change))
