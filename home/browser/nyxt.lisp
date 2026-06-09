(define-configuration buffer
    ((default-modes
         (pushnew 'nyxt/mode/emacs:emacs-mode %slot-value%))))

(define-configuration input-buffer
    ((default-modes
         (pushnew 'nyxt/mode/emacs:emacs-mode %slot-value%))))

(define-configuration web-buffer
    ((default-modes
         (append '(nyxt/mode/blocker:blocker-mode 
                   nyxt/mode/reduce-tracking:reduce-tracking-mode
                   nyxt/mode/force-https:force-https-mode)
                 %slot-value%))))
