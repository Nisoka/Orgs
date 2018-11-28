;; 3.1 函数式设计


(defun bad-reverse (lst)
  (let* ((len (length lst))
         (ilimit (truncate (/ len 2))))
    (do ((i 0 (1+ i))
         (j (1- len) (1- j)))
        ((>= i ilimit) 'done)
      (rotatef (nth i lst) (nth j lst)))))

(setq lst '(a b c))
(bad-reverse lst)

(princ lst)

(defun good-reverse (lst)
  (labels ((rev (lst acc)
             (if (null lst)
                 acc
                 (rev (cdr lst) (cons (car lst) acc)))))
    (rev lst nil)))
(setq lst '(a b c))
(setf lst-rev (good-reverse lst))
(princ lst)

;; 返回多值的函数, 以及多个返回值的使用
(truncate 26.77)
(multiple-value-bind (int frac) (truncate 26.77)
  (list int frac))
(defun powers (x)
  (values x (sqrt x) (expt x 2)))
(multiple-value-bind (v v-sqrt v-expt) (powers 26.77)
  (list v v-sqrt v-expt))


;; 内外颠倒的命令式
;; 函数式编程告诉你他想要什么
;; 命令式编程告诉你他要做什么
(defun FP-fun (x)
  (list 'a (expt (car x) 2)))

(defun IMP-fun (x)
  (let (y sqr)
    (setq y (car x))
    (setq sqr (expt y 2))
    (list 'a sqr)))


;; 3.3 函数式接口
;; 一个变量的从属关系, 认为某个变量属于某个调用.
;; 对副作用的有害程度进行评级, 有些函数修改了变量,产生副作用, 但是该变量不属于任何其他调用, 那么就认为该函数无害.

;; 1 不能直接修改传入参数
;; 2 函数不能修改可能同时属于其他操作的变量,如果想要修改, 自己copy 一个.
;; 3 不能返回传入参数的引用


;; 想要利用expr 进行拼接, 那么就要自己copy 一个
(defun qualify (expr)
  (nconc (copy-list expr) (list 'maybe)))

;; 这里的x每次都会重新生成list, 因此没什么问题
(defun ok (x)
  (nconc (list 'a x) (list 'c)))

;; 这里直接引用传入参数, 可能会导致问题
(defun not-ok (x)
  (nconc (list 'a) x (list 'c)))

;; 不能引用传入参数, 有可能其他调用,会实用他.
(defun exclaim (expression)
  (append expression '(oh my)))
;; 应该替换成这样??????
(defun exclaim (expression)
  (append expression (list ’oh ’my)))

(exclaim '(lions and tigers and bears))
(nconc * '(goodness))



