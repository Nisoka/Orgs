;; useage of quicklisp
;; 1 download the quicklisp.lisp
;; 2 sbcl-repl
;;   CL-USER> (load "path/quicklisp.lilsp")
;;   ..............
;;   ==== quicklisp quickstart 2015-01-28 loaded ====
;;     To continue with installation, evaluate: (quicklisp-quickstart:install)
;;     For installation options, evaluate: (quicklisp-quickstart:help)
;;   T

;;   CL_USER> (quicklisp-quickstart:install)
;;   .............
;;   T   install over now.
;;   ;;; then the quicklisp will install into the sbcl.(but how it works??)
;;   ;;; then by default the quicklisp will install to the path /home/user/quicklisp/

;; 3 when restart the sbcl, you need load the quicklisp's setup.lisp to load the quicklisp' functions.
;;   CL_USER> (load "/home/user/quicklisp/setup.lisp")
