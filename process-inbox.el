;; -*- lexical-binding: t -*-

(defun process-inbox ()
  "start processing the inbox directory"
  (interactive)
  (dired "~/Inbox")
  (rename-buffer "*process-inbox*")
  (inbox-dired-mode))

(kill-buffer "Inbox")
(setq process-inbox--internal-extensions
      '("txt"
        "pdf"
        "jpg"
        "gif"
        ))

(defun process-inbox/visit-file ()
  "visit a file as part of processing it"
  (interactive)

    )


(define-derived-mode inbox-dired-mode dired-mode
  "inbox dired mode"
  "something fancy"
  )


(define-key inbox-dired-mode-map
  (kbd "RET")
  'process-inbox/visit-file
  )
