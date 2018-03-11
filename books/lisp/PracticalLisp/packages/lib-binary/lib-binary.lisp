(in-package :nan.learnlisp.lib-binary)

(defun as-keyword (symbol)
  (intern (string symbol) :keyword))

(defun slot->defclass-slot (spec)
  (let ((name (first spec)))
    `(,name :initarg ,(as-keyword name) :accessor ,name)))

(defmacro define-binary-class (name slots)
  `(defclass ,name ()
     ,(mapcar #'slot->defclass-slot slots)))
