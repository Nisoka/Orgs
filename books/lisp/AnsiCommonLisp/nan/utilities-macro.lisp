
(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))       ;do first iterable var 
          (,gstop ,stop))               ;do second iterable var
         ((> ,var ,gstop))              ;do stop condition
       ,@body)))


(defmacro in (obj &rest choices)
  (let ((insym (gensym)))                ;will be eval when compile
    `(let ((,insym ,obj))                ;will return as a list, will be eval when runing.
       (or ,@(mapcar #'(lambda (c)         ;mapcar will be eval on the list when compile
                         `(eql ,insym ,c)) ;the inner lambda func must use ` to disable eval
                     choices)))))          ;choices is a list

(defmacro in? (obj choice-list)
  (let ((insym (gensym)))                ;will be eval when compile
    `(let ((,insym ,obj))                ;will return as a list, will be eval when runing.
       (or ,@(mapcar #'(lambda (c)         ;mapcar will be eval on the list when compile
                         `(eql ,insym ,c)) ;the inner lambda func must use ` to disable eval
                     choice-list)))))          ;choices is a list

(defmacro random-choice (&rest exprs)
  `(case (random ,(length exprs))          ;case index list, select the list[index]
     ,@(let ((key -1))                     ;
         (mapcar #'(lambda (expr)          ;
                     `(,(incf key) ,expr)) ;
                 exprs))))                 ;

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))


(defmacro with-gensym (syms &body body)
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym)))    ;syms is a var list, and gensym will generage
                 syms)                  ;globle defined var, but what the let???
     ,@body))

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))






;;
;;
;;Test use
;; 
;; 
(in '- '+ '- '*)
(in? '-  ('+ '- '*))                    ;

(random-choice 'left 'right)
(macroexpand '(random-choice 'left 'right))

(with-gensym (x y z)
  (setf x 10)
  (setf y 5)
  (setf z 1)
  (format t "~A ~A ~A~%" x y z))


(macroexpand '(with-gensym (x y z)
               (setf x 10)
               (setf y 5)
               (setf z 1)
               (format t "~A ~A ~A~%" x y z)))

(avg 2 4 8)
(macroexpand '(avg 2 4 8))


(let ((val (+ 1 1)))
  (if val
      (1+ val)
      0))

(aif (+ 1 1)
     (1+ it)
     0)
(macroexpand '(aif (+ 1 1)
               (1+ it)
               0))


