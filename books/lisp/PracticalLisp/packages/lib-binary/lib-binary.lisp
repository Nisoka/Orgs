(in-package :nan.learnlisp.lib-binary)

(defun as-keyword (symbol)
  (intern (string symbol) :keyword))

;; slot -> defclass-slot
(defun slot->defclass-slot (spec)
  (let ((name (first spec)))
    ;; (list name :initarg :name :accessor name)
    `(,name :initarg ,(as-keyword name) :accessor ,name)))


(defun normalize-slot-spec (spec)
  (list (first spec) (mklist (second spec))))

(defun mklist (x)
  (if (listp x)
      x
      (list x)))



;; (defmacro define-binary-class (name slots)
;;   `(defclass ,name ()
;;      ,(mapcar #'slot->defclass-slot slots)))



(defgeneric read-value (type stream &key)
  (:documentation "Read a value of given type from the stream."))

(defgeneric write-value (type stream &key)
  (:documentation "Write a value of given type to the steam"))



(defun slot->read-value (spec stream)
  (destructuring-bind (name (type &rest args)) (normalize-slot-spec spec)
    `(setf ,name (read-value ',type ,stream ,@args))))

(defun slot->write-value (spec stream)
  (destructuring-bind (name (type &rest args)) (normalize-slot-spec spec)
    `(write-value ',type ,stream ,name ,@args)))




;; (defmethod read-value ((type (eql 'iso-8859-1-string)) in &key length)
;;   T)

;; (defmethod read-value ((type (eql 'u1)) in &key)
;;   T)



(defmacro define-binary-class (name slots)
  (with-gensyms (typevar objectvar streamvar)
    `(progn
       (defclass ,name ()
         ,(mapcar #'slot->defclass-slot slots))

       (defmethod read-value ((,typevar (eql ',name)) ,streamvar &key)
         (let ((,objectvar (make-instance ',name)))
           (with-slots ,(mapcar #'first slots) ,objectvar
             ,@(mapcar #'(lambda (x) (slot->read-value x streamvar)) slots)
             ,objectvar)))
       
       (defmethod write-value ((,typevar (eql ',name)) ,streamvar ,objectvar &key)
         (with-slots ,(mapcar #'first slots) ,objectvar
           ,@(mapcar #'(lambda (x) (slot->write-value x streamvar)) slots))))))


;; =================================================



(defgeneric read-object (object stream)
  (:method-combination progn :most-specific-last)
  (:documentation "read-object"))

(defgeneric write-object (object stream)
  (:method-combination progn :most-specific-last)
  (:documentation "write-object"))

(defmethod read-value ((type symbol) stream &key)
  (let ((object (make-instance type)))
    (read-object object stream)
    object))


(defmethod write-value ((type symbol) stream value &key)
  (assert (typep value type))
  (write-object value stream))







(defmacro define-binary-class (name (&rest superclass) slots)
  (with-gensyms (typevar objectvar streamvar)
    `(progn
       (defclass ,name ,superclass
         ,(mapcar #'slot->defclass-slot slots))

       (defmethod read-object progn ((,objectvar ,name) ,streamvar)
                  (with-slots ,(mapcar #'first slots) ,objectvar
                    ,@(mapcar #'(lambda (x) (slot->read-value x streamvar)) slots)
                    ,objectvar)))
       
       (defmethod write-object progn ((,objectvar ,name) ,streamvar)
                  (with-slots ,(mapcar #'first slots) ,objectvar
           ,@(mapcar #'(lambda (x) (slot->write-value x streamvar)) slots))))))

