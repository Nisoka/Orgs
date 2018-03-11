(in-package :cl-user)

(defpackage :nan.learnlisp.lib-binary
  (:use :common-lisp :nan.learnlisp.macro-utils)
  (:export :define-binary-class
           :define-tagged-binary-class
           :define-binary-type
           :read-value
           :write-value
           :*in-progress-objects*
           :parent-of-type
           :current-binary-object
           :+null+))





