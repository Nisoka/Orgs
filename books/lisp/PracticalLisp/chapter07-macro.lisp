;;7.1 when and unless
(if (> 2 3) "You" "me")

(defmacro my-when (condition &rest body)
  `(if ,condition (progn ,@body)))

;; 7.2 COND
(cond
  (a (dothex))
  (b (dothey))
  (T (dothedefault)))

;; 7.3 AND OR NOT
;; AND OR 实现了对任意数量子表达式的 逻辑合并 和 解析的操作
;; 实现短路特性
;; AND false 则后面的不需要求职直接退出
;; AND TRUE 则继续求值后面的表达式
;; OR TRUE 则后面的推出
;; OR FALSE 计算后面的表达式

(not nil)
(not (= 1 1))
(and (= 1 2) (= 3 3))
(or (= 1 2) (= 3 3))

;; 7.4 7.5 循环
;; lisp的最基本循环是 DO 实现的结构
;; 但是DO 过于灵活 以至于复杂,
;; 因此 在DO上实现了 DOLIST DOTIMES等宏 来对一些简单常见情况
;; 进行抽象 简化代码
;; LOOP 宏 完美体现了 LISP 能够实现自己语法的能力. Loop更像是
;; C等语言的语法, 但是Loop是一个宏

(defmacro print-line (line)
  (print line)
  (format t "~%"))

(defun test-do ()
  (dotimes (i 5)
    (print i)
    (if (= i 3)
        (return)))
  (print-line "over the dotimes")
  (dolist (var '(1 2 3))
    (print var))
  (print-line "over the dolist")


  (do ((n 0 (1+ n))
       (cur 0 next)
       (next 1 (+ cur next)))
      ((= n 10) cur)
    (format t "n is ~a, cur is ~a, next is ~a~%" n cur next))

  (print-line "test get universal time")
  (let ((futhure-time (+ (get-universal-time) 5)))
    (do ()
        ( (> (get-universal-time) futhure-time))
      (format t "target time is ~a, cur is ~a ~%" (get-universal-time) futhure-time)
      (sleep 1)))
  )



;; 7.7 Loop
;; 两种形式, 简化形式 和 扩展形式
;; 简化形式 就是 无限循环 while(1){}
;;


(defun test-loop ()
  (print-line "test the base one")
  ;; (let ((future-time (+ (get-universal-time) 5)))
  ;;   (loop
  ;;      (when (> (get-universal-time) future-time)
  ;;        (return))
  ;;      (format t  "target is ~a, cur is ~a ~%" future-time (get-universal-time))
  ;;      (sleep 1)))

  (print-line "test the expend one")

  (setq loop1 (loop for i from 1 to 10 collecting i))

  (setq loop2 (loop for x from 1 to 10 summing (expt x 2)))


  (setq loop3
        (loop for i below 10
           and a = 0 then b
           and b = 1 then (+ b a)
             finally (return a)))
  (format t "~a~% ~a~% ~a~%" loop1 loop2 loop3)
  )




;; 8 如何定义自己的宏
;; 宏 就是产生 做某些事情的代码. 类似具有自定义语法的 C 宏

;; 8.3 defmacro
;; 宏的作用是 将宏形式(首元素为宏的 LISP形式) 转化为特定目的代码

;; 8.4 do-primes

;; when 类似if，并不是像C中一样是个循环
(defun primep (number)
  (when (> number 1)
    (loop for fac from 2 to (isqrt number)
       never (zerop (mod number fac)))))

(defun next-prime (number)
  (loop for n from number
     when (primep n) return n))



(defun test-macro ()
  (do ((p (next-prime 0) (next-prime (1+ p))))
      ((> p 19))
    (format t "~d " p)))

(defmacro do-primes (var-and-range &rest body)
  (let ((var (first var-and-range))
        (start (second var-and-range))
        (end (third var-and-range)))
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var))))
         ((> ,var ,end))
       ,@body)))

(defmacro do-primes2 ((var start end) &body body)
  `(do ((,var (next-prime ,start) (next-prime (1+ ,var))))
       ((> ,var ,end))
     ,@body))

;; 8.6 生成展开式
;; macroexpand-1 接受一个 macro 表达式, 所以不能进行求值
;; 所以需要使用 引用quote 符号 引用表达式并不让其进行求值
(macroexpand-1 '(do-primes (var 0 19) (print var)))

;; 8.7 堵住漏洞
;; 有漏洞的抽象 leaky abstraction
;; 泄露了一些本该抽象封装起来的细节
;; 因为宏 本身就是创造抽象的方式, 因此必须确保宏不产生不必要的泄露

;; 宏可能产生三种方式的泄露, 但是每种方式都很容易解决
;; 1 多重求值问题, 可以通过在do中不加入 incf step可以确定求值
;; 而解决多次求值问题
(defmacro do-primes3 ((var start end) &body body)
  `(do ((ending-value ,end)
        (,var (next-prime ,start) (next-prime (1+ ,var))))
       ((> ,var ending-value))
     ,@body))

;; 但是这样有引入另外两种漏洞
;; 2 求值顺序问题
(defmacro do-primes4 ((var start end) &body body)
  `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
        (ending-value ,end))
       ((> ,var ending-value))
     ,@body))


;; 3 符号重复问题, 内部提供了一个ending-value的临时变量
;; 但是宏实际上并不是一个函数, 没有产生一个局部作用域, 因此同名变量会产生问题,
;; 最好的方法是在宏内部的临时变量 需要产生一个绝对不会重复的变量名字---符号
;; 最好的方法是 使用 GENSYM在每次调用时返回唯一的符号
;; GENSYM会产生一个 未被Lisp读取器读取过的符号, 并且永远不会被读到
;; 因此 GENSYM 在每次被调用都会生成一个新的符号

;; 注意！！ ending-value-name 是一个变量, 保存的是一个变量名, 使用 ,ending-value-name 来得到真的变量.
(defmacro do-primes5 ((var start end) &body body)
  (let ((ending-value-name (gensym)))
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))

;; 堵上漏洞的方法
;; 1 将展开式中任何子形式放在一个位置上?, 使其求值顺序与宏调用的子形式相同
;; 2 确保子形式只求值一次, 方法是在展开式中创建唯一符号变量来持有 可求值参数形式的所得到的值.
;; 3 使用gensym生成唯一符号  (let ((temp-value-name (gensym))))

;; 8.8 编写宏的宏
;; 创建一个编写宏中模式的宏
;; 一个宏用来生成代码, 生成的代码又生成另外的代码
(defmacro with-gensym ((&rest name) &body body)
  `(let ,(loop for n in name collect `(,n (gensym)))
     ,@body))

(defmacro do-primes6 ((var start end) &body body)
  (with-gensym (ending-value-name)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))
