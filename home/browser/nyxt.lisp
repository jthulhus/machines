(in-package #:nyxt-user)

(defvar *my-search-engines*
  (list
   (make-instance 'search-engine
                  :name "Google"
                  :shortcut "goo"
                  #+nyxt-4 :control-url #+nyxt-3 :search-url
                  "https://duckduckgo.com/?q=~a")))

(define-configuration browser
    ((restore-session-on-startup-p t)
     (external-editor-program "emacsclient -r")
     #+nyxt-4
     (search-engine-suggestions-p t)
     #+nyxt-4
     (search-engines (append %slot-default% *my-search-engines*))))
