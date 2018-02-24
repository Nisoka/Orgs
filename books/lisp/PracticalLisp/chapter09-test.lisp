
(defun test-+ ()
  (format t "~:[Fail~;Pass~] ... ~a~%" (= (+ 1 2) 3) '(= (+ 1 2) 3))
  (format t "~:[Fail~;Pass~] ... ~a~%" (= (+ 1 2 3) 6) '(= (+ 1 2 3) 6))
  (format t "~:[Fail~;Pass~] ... ~a~%" (= (+ -1 -2) -3) '(= (+ -1 -2) -3)))

(defun report-result (result form)
  (format t "~:[Fail~;Pass~] ... ~a~%" result form))

;; 想要做的是将 代码看作数据, 这时候一定需要用到宏
;; 将代码看作数据, 那么操作的就是代码, 能够操作代码的能力 就是 宏的能力.
(defmacro check (form)
  `(report-result ,form ',form))

(defun test-+2 ()
  (check (= (+ 1 2) 3))
  (check (= (+ 1 2 3) 6))
  (check (= (+ -1 -2) -3)))


(defmacro check2 (&body forms)
  `(progn
     ,@(loop for f in forms collect `(report-result ,f ',f))))

(defun test-+3 ()
  (check2
    (= (+ 1 2) 3)
    (= (+ 1 2 3) 6)
    (= (+ -1 -2) -3)))


(defun report-result2 (result form)
  (format t "~:[Fail~;Pass~] ... ~a~%" result form)
  result)

(defvar *test-name* nil)
(defun report-result3 (result form)
  (format t "~:[Fail~;Pass~] ... ~a ~a ~%" result *test-name* form))

(defmacro combine-results (&body forms)
  (with-gensym (result)
    `(let ((,result t))
       ,@(loop for f in forms collect `(unless ,f (setf ,result nil)))
       ,result)))

(defmacro check3 (&body forms)
  `(combine-results
     ,@(loop for f in forms collect `(report-result3 ,f ',f))))

(defun test-+4 ()
  (check3
    (= (+ 1 2) 3)
    (= (+ 1 2 3) 6)))


;; ;; combine-results
;; (let ((value-name (gensym)))
;;   ;; with-gensym
;;   (let  (((value-name) t))
;;     ;; ,@(loop ...)
;;     (unless (report-result2 test1 'test1) (setf (value-name) nil))
;;     (unless (report-result2 test1 'test1) (setf (value-name) nil))
;;     (unless (report-result2 test1 'test1) (setf (value-name) nil))
;;     value-name)



(defun test-* ()
  (check3
    (= (* 1 2) 2)
    (= (* 1 2 3) 6)))


(defun test-*1 ()
  (let ((*test-name* 'test-*1))
    (check3
      (= (* 1 2) 2)
      (= (* 1 2 3) 6))))

(defun test-+5 ()
  (let ((*test-name* 'test-+5))
    (check3
      (= (+ 1 2) 3)
      (= (+ 1 2 3) 6))))

(defun test-arithmetic()
  (combine-results
    (test-+5)
    (test-*1)))



(defmacro deftest (name parameters &body body)
  `(defun ,name ,parameters
     (let ((*test-name* ',name))
       ,@body)))

(deftest test-+6 ()
  (check3
    (= (+ 1 2) 3)
    (= (+ 1 2 3) 6)))
