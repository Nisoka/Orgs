
(in-package :cl-user)

(defpackage :nan.learnlisp.binary-data
  (:use :common-lisp)
  (:export :define-binary-class
           :define-tagged-binary-class
           :define-binary-type
           :read-value
           :write-value
           :*in-progress-objects*
           :parent-of-type
           :current-binary-object
           :+null+))
