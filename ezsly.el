;;; ezsly.el --- Easy asdf project dev with sly.  -*- lexical-binding:t -*-

;; Author: Ambery Rabbit <amberyrabbit@airmail.cc>
;; Version: 1
;; Package-Requires: ((sly))
;; Keywords: sly, asdf, clisp

;;; Commentary:

;; Currently, this package simply provides some utilities to automate
;; a couple annoying aspects of developing with sly; primarily, needing to
;; reload the package each time you change a file.

;;; Code:

(defun load-ezsly ()
  "Load the ezsly package into sly on startup."
  (sly-eval-async
      `(cl:progn (ql:quickload "ezsly")
		(cl:format t " <ꙮ> You are using ezsly.~%")
		(cl:use-package 'ezsly))))

(add-hook 'sly-connected-hook #'load-ezsly)

(defun asdf-project-autoreload ()
  "Autoreload package on file change."
  (when *editing-asdf*
    (sly-eval-async
     `(ezsly:rp))))

(add-hook 'after-save-hook #'asdf-project-autoreload)

;;; The following functions manage .asd files.

(defvar *editing-asdf* nil)

(defun re-seq (regexp string)
  "Get a list of all regexp matches in a string"
  (save-match-data
    (let ((pos 0)
          matches)
      (while (string-match regexp string pos)
        (push (match-string 2 string) matches)
        (setq pos (match-end 0)))
      matches)))

(defun regex-match-in-buffer (buffer regex)
  "Perform a regex match on the contents of a buffer associated with a given filename"
  (with-current-buffer buffer
    (goto-char (point-min))
    (car (re-seq regex (buffer-string)))))

(defun load-asdf-file (proc string)
  "Quickload an ASDF file when it's loaded into the Sly REPL."
  (when (string= "asd" (file-name-extension string))
    (let ((package-name (regex-match-in-buffer (get-file-buffer string) "\\(defsystem \"\\)\\(.*\\)\\(\"\\)")))
      (sly-eval-async `(cl:progn
			(ezsly:dp ,package-name)
			(cl:format t " <ꙮ> Loaded package ~A.~%" ,package-name)))
      (setf *editing-asdf* t))))

(advice-add 'sly-load-file :around #'load-asdf-file)

(provide 'ezsly)

;;; ezsly.el ends here