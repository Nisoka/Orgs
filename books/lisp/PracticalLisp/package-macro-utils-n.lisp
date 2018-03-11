(in-package :cl-user)

(defpackage :nan.learnlisp.macro-utils
  (:use :common-lisp)
  (:export :with-gensym))


(in-package :nan.learnlisp.macro-utils)

(defmacro with-gensym ((&rest name) &body body)
  `(let ,(loop for n in name collect `(,n (gensym)))
     ,@body))
