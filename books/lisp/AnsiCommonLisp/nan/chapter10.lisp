(defun our-toplevel ()
  (do ()
      (nil)
    (format t "~%NAN> ")
    (print (eval (read)))))


(defmacro nil! (x)
  (list 'setf x nil))

(defun learn-macro (expr)
  (apply #'(lambda (x) (list 'setf x nil))
         (cdr expr)))


(defun learn-macro2 ()
  (let ((a 1)
        (b 2))
    `(a is ,a and b is ,b)))

(defmacro nil2 (x)
  `(setf ,x nil))

(defmacro while (test &rest body)
  `(do ()
       ((not ,test))
     ,@body))

(defun quicksort (vec l r)
  (let ((i l)
        (j r)
        (p (svref vec (round (+ l r) 2))))
    (while (<= i j)
      (while (< (svref vec i) p)
        (incf i))
      (while (< (svref vec j) p)
        (decf j))
      (when (<= i j)
        (rotatef (svref vec i) (svref vec j))
        (incf i)
        (decf j)))
    
    (if (>= (- j 1) 1) (quicksort vec l j))
    
    (if (>= (- r i) 1) (quicksort vec i r)))
  
  vec)




;; ntimes ---------------------------
;; (defmacro ntimes (n &rest body)
;;   `(do ((x 0 (+ x 1)))
;;        ((>= x ,n))
;;   ,@body))


;; (defmacro ntimes (n &rest body)
;;   (let ((g (gensym)))
;;     `(do ((,g 0 (+ ,g 1)))
;;          ((>= ,g ,n))
;;        ,@body)))

(defmacro ntimes (n &rest body)
  (let ((g (gensym))
        (h (gensym)))
    `(let ((,h ,n))
       (do ((,g 0 (+ ,g 1)))
           ((>= ,g ,h))
         ,@body))))

(let ((x 10))
  (ntimes 5
          (setf x (+ x 1)))
  x)


(let ((x 10))
  (do((x 0 (+ x 1)))
     ((>= x 5))
    (setf x (+ x 1)))
  x)



(let ((v 10))
  (ntimes (setf v (- v 1))
          (princ ".")))


(defmacro my-car (lst)
  `(car ,lst))

(let ((x (list 'a 'b  'c)))
  (setf (my-car x) 44)
  x)

;; (defmacro my-incf (x &optional (y 1))
;;   `(setf ,x (+ ,x ,y)))


(define-modify-macro my-incf (&optional (y 1))
  +)



;; example: macro utilities



