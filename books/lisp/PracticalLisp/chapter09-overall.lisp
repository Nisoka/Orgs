(defvar *test-name* nil)

(defmacro deftest (name parameters &body body)
  `(defun ,name ,parameters
     (let ((*test-name* (append *test-name* (list ',name))))
       ,@body)))


(defmacro check (&body forms)
  `(combine-results
     ,@(loop for f in forms collect `(report-result ,f ',f))))

(defmacro combine-results (&body forms)
  (with-gensym (result)
    `(let ((,result t))
       ,@(loop for f in forms collect `(unless ,f (setf ,result nil)))
       ,result)))

(defmacro with-gensym ((&rest name) &body body)
  `(let ,(loop for n in name collect `(,n (gensym)))
     ,@body))



(defun report-result (result form)
  (format t "~:[Fail~;Pass~] ... ~a: ~a~%" result *test-name* form)
  result)
