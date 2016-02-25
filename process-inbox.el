

(defun process-inbox ()
  "start processing the inbox directory"
  (interactive)
  (let (
        (inbox-directory (expand-file-name "~/Inbox"))
        (pi-buffer (get-buffer-create "*process-inbox*"))
        (ls-process  (start-process "process-inbox-ls"
                                    nil
                                    "ls"
                                    inbox-directory))
        )
    (delete-other-windows)
    (set-process-filter ls-process
                        (lambda (process output)
                          (with-current-buffer (get-buffer-create "*process-inbox*")
                            (goto-char (point-max))
                            (insert output))))
    (set-process-sentinel ls-process
                          (lambda (process event)
                            (when (string= event "finished\n")
                              (process-inbox-mode)
                              )
                            ))
    ))


(setq process-inbox--internal-extensions
      '("txt"
        "pdf"
        "jpg"
        "gif"
        ))


(define-derived-mode process-inbox-mode special-mode
  "Process Inbox"

  "Major mode for inbox directory processing"
  )

(define-key proces-inbox-mode-map
  (kbd "RET")

  )

(defun process-inbox/visit-file ()


    )


(define-derived-mode inbox-dired-mode dired-mode
  "inbox dired mode"
  "something fancy"
  )


(define-key inbox-dired-mode-map
  (kbd)
  )


(define )
