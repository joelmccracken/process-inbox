;; -*- lexical-binding: t -*-

(defun process-inbox ()
  "start processing the inbox directory"
  (interactive)
  (dired "~/Inbox")
  (rename-buffer "*process-inbox*")
  (inbox-dired-mode)
  (evil-emacs-state 1))

(setq process-inbox--external-extensions
      '(".pdf"
        ".gif"
        ".mp4"
        ".doc"
        ))

(defun process-inbox/visit-file ()
  "visit a file as part of processing it"
  (interactive)
  (let* ((target-file (dired-get-file-for-visit))
         (extension   (file-name-extension target-file
                                           t)))
    (if (member extension
                process-inbox--external-extensions)
        (start-process "open-file" nil "open" target-file)

      (find-file-other-window target-file)
      (other-window -1))))

(defun process-inbox/refile-item (file-path destination-dir)
  (let ((target-dir-fixed (file-name-as-directory (expand-file-name destination-dir)))
        dest-file-name)
    (setq dest-file-name
          (read-string "Filename: " (file-name-nondirectory file-path)))
    (rename-file file-path (concat target-dir-fixed
                                   dest-file-name))))

(defun process-inbox/refile ()
  (interactive)
  (let* ((target-file (dired-get-file-for-visit))
         (extension   (file-name-extension target-file
                                           t))
         (filename    (file-name-nondirectory target-file))
         the-destination)

    (setq the-destination
          (helm
           :sources (helm-build-sync-source "destination"
                      :candidates '(("Funny images (videos, too)"
                                     . funny)
                                    ("Personal (pics of family, etc)"
                                     . personal)
                                    ("Private (tax stuff, receipts, etc)"
                                     . private)
                                    ("Papers (academic)"
                                     . papers)
                                    ("Books"
                                     . books)
                                    ("Misc (interesting stuff, etc)"
                                     . misc)
                                    ))
           :resume 'noresume
           :buffer "*helm refile destination*"
           ))
    (pcase the-destination
      (`funny (process-inbox/refile-item target-file
                                         "~/Files/funny"
                                         ))
      (`personal (process-inbox/refile-item target-file
                                            "~/Files/personal"
                                            ))
      (`private (process-inbox/refile-item target-file
                                           "~/Files/private"
                                           ))
      (`papers (process-inbox/refile-item target-file
                                          "~/Files/papers"
                                          ))
      (`books (process-inbox/refile-item target-file
                                         "~/Files/books"
                                         ))
      (`misc (process-inbox/refile-item target-file
                                        "~/Files/misc"
                                        ))
      )

    (revert-buffer)
    ))

(define-minor-mode inbox-dired-mode
  "inbox dired mode"
  nil
  " Inbox"
  '())

(define-key inbox-dired-mode-map (kbd "RET")  'process-inbox/visit-file)
(define-key inbox-dired-mode-map (kbd "r")    'process-inbox/refile)

(provide 'process-inbox)
