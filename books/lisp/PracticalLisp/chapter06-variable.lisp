;; lexicon(local) dynamic(global)

;;6.1 base knowlage
;; (let (variable-initial-form*)
;;      body-form*)

(defun test-let (x)
  (format t "Parameter: ~a test ~%" x)
  (let ((x 2))
    (format t "Outer Let: ~a OO ~%" x)
    (let ((x 3))
      (format t "Inner Let: ~a ii ~%" x))
    (format t "Outer Let: ~a OO ~%" x))
  (format t "Parameter: ~a test ~%" x))

;;6.2 lexicon variable and closure
;; 匿名函数（lambda） 可以构建一个闭包
(defparameter *fn*
  (let ((count 0))
    #'(lambda ()
        (setq count (+ count 1)))))


;; 6.3 dynamic 与 global 变量类似
;; 但是可以实现, 在某个函数调用内, 实现重新绑定, 而在某个函数调用结束后, 返回原绑定
;; 所有全局变量都是动态变量, 不过变量具有上面说的特殊功能
;; 当一个变量被 声明 为 全局变量时, 当利用let定义局部绑定 func创建形参时这样的 词法作用域时
;; 全局变量具有的特性会让 let function 定义词法作用域 有效, 变成动态绑定.
;; 因此有时候 当构建词法作用域时, 希望知道是否是个全局变量， 所有命名约定很有作用 全局变量用**包围起来
(defvar *count* 0)
(defun increment-widget-count ()
  (incf *count*))
(defun print-count ()
  (format t "before is ~18t~d ~%" *count*)
  (setq *count* (+ *count* 1))
  (format t "after is ~18t~d ~%" *count*))

(defun dynamic-band ()
  (print-count)
  (let ((*count* 0))
    (print-count)
    )
  (print-count))

(defun change-count (x)
  (setq *count* x))


;; 6.4 常量 constant variable
;;
(defconstant +pi+ 3.14)
(defconstant pppp 2.2222)

;; 6.5 赋值
;; set and get
(setf *count* 1)
;; setf 内部会根据变量的不同情况 可能会调用setq 或者其他操作
;; setf 是一个宏， 而setq是一个操作符
(incf *count*)
(decf *count*)
