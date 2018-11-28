;; 2.1 作为数据的函数
;; 函数也是一个lisp对象
;; 在运行时期创建一个函数,
;; 把函数当作对象传递.
;; 在运行时创建函数的能力是相当厉害的.

;; 2.2  定义函数

(in-package :cl-user)
(defpackage :on-lisp-02
  (:use :cl)
  (:export))

(in-package :on-lisp-02)

(defun double (x)
  (* x 2))

(double 1)

#'double

(eql #'double (car (list #'double)))

#'(lambda (x) (* x 2))
(double 3)
((lambda (x) (* x 2)) 4)

(setq double 2)
(double double)

(symbol-value 'double)
(symbol-function 'double)
(setq x #'append)
(eql (symbol-value 'x) (symbol-function 'append))


;; defun 并不是一个关键字, 而是一个函数而已, 所以可以在运行时创建新的函数
(defun double (x) (* x 2))
(setf (symbol-function 'double)
      #'(lambda (x) (* x 2)))

;; 2.3 函数型参数
;; 调用函数对象,来运行函数  apply funcall

(+ 1 2)
;; apply 调用函数, 将余下的所有参数通过cons构成list, 然后传给函数.
(apply #'+ '(1 2))
(apply (symbol-function '+) '(1 2))
(apply #'(lambda (x y) (+ x y)) '(1 2))
(apply #'+ 1 '(2))

;; funcall 则相当于一个eval求值, 必须不需要构成list
(funcall #'+  1 2)

;; mapcar 带有两个以上参数
;; 一个函数加上一个以上的列表 (每个列表都分别是函数的参数),然后它
;; 可以将参数里的函数依次作用在每个列表的元素上

;; 使用lambda表达式表达函数,实际上是为了一些简单的函数,不必要写成函数去调用
(mapcar #'(lambda (x) (+ x 10))
        '(1 2 3))

(mapcar #'+
        '(1 2 3)
        '(1 10 100))

(sort '(1 4 2 5 6 7 3) #'<)

(remove-if #'evenp '(1 4 2 5 6 7 3))

(defun our-remove-if (fn list)
  (if (null list)
      nil
      (if (funcall fn (car list))
          (our-remove-if fn (cdr list))
          (cons (car list) (our-remove-if fn (cdr list))))))

(our-remove-if #'evenp '(1 4 2 5 6 7 3))
;; 注意到在这个定义里 fn 并没有前缀 #’。
;; 因为函数就是数据对象,变量可以将一个函数作为它的正规值。
;; #’ 仅用来引用那些以符号命名的函数, 通常是用 defun 全局定义的。
;; 但无论是使用内置的工具,比如 sort, 还是编写你的实用工具,基本原则是一样的:
;; 与其把功能写死, 不如传进去一个函数参数。


;; 2.4 作为属性的函数
(defun behave (animal)
  (case animal
    (dog (wag-tail)
         (bark))
    (rat (scurry)
         (squeak))
    (cat (rub-legs)
         (scratch-carept))))

(defun behave (animal)
  (funcall (get animal 'behavior)))

(setf (get 'dog 'behavior)
      #'(lambda ()
          (wag-tail)
          (bark)))

;; 2.5 作用域
;; CommonLisp 是一种词法作用域的lisp,
;; 词法作用域和动态作用域处理自由变量的方式不同,
(let ((y 7))
  (defun scope-test (x)
    (list x y)))

(scope-test 1)

;; 1 约束变量
;; 2 自由变量
;;   1 词法作用域(一般情况 闭包)
;;   2 动态作用域(特殊special定义)(几乎不用)

;; 这里x 就是受约束的, y则是自由的
;; 约束变量的值 是肯定的显而易见的.

;; 自由变量,则需要看当前是词法作用域还是动态作用域.(默认都是词法作用域(定义作用域))
;; 在词法作用域里, 逐层检查定义这个函数时,它所处的各层外部环境。
;; 在一个词法作用域 Lisp 里,我们的示例将捕捉到定义 scope-test 时,变量 y 的绑定 (let ((y 7)))。

;; 在一个动态作用域(只有在使用special定义才会是动态作用域), 要想找出当 scope-test 执行时自由变量的值,我们要往回逐个检查函数的调用链。当发现 y 被绑定时,这个被绑定的值即被用在 scope-test 中。如果没有发现,那就取 y 的全局值。这样,在用动态作用域的 Lisp 里,在调用的时候 y 将会产生这样的值:

(let ((y 5))
  (scope-test 2))

;; Lisp 社区对昨日黄花的动态作用域几乎没什么留恋。因为它经常会导致痛苦而又难以捉摸的 bug。而词法作用域不仅仅是一种避免错误的手段。在下一章我们会看到,它同时也带来了一些崭新的编程技术。




;; 2.6 闭包
;; Common Lisp 是词法作用域的,所以如果定义含有自由变量的函数,系统就必须在函数定义时保存那些变量的绑定。这种函数和一组变量绑定的组合称为闭包。
;; 闭包是带有局部状态的函数!

(defun list+ (lst n)
  (mapcar #'(lambda (x) (+ x n))
          lst))

(list+ '(1 2 3) 1000)



(let ((counter 0))
  (defun new-id ()
    (incf counter))
  (defun reset-id ()
    (setq counter 0)))

(princ (new-id))
(princ (reset-id))

;; 定义一个不能改变内部状态的闭包
(defun make-adder (n)
  #'(lambda (x) (+ x n)))

(setf adder2 (make-adder 2))
(setf adder10 (make-adder 10))

(funcall adder2 1)
(funcall adder10 11)


(defun make-adderb (n)
  #'(lambda (x &optional change)
      (if change
          (setf n x)
          (+ x n))))

(setf addx (make-adderb 1))
(funcall addx 1)
(funcall addx 100 t)
(funcall addx 1)

(defun make-dbms (db)
  (list
   #'(lambda (key)
       (cdr (assoc key db)))
   #'(lambda (key val)
       (push (cons key val) db)
       key)
   #'(lambda (key)
       (setf db (delete key db :key #'car))
       key)))

(setq cities (make-dbms '( (boston . us) (paris . france))))
(funcall (car cities) 'boston)
(funcall (second cities) 'london 'england)
(funcall (car cities) 'london)
(defun lookup (key db)
  (funcall (car db) key))
(lookup 'london cities)


;; 2.7 local function

(mapcar #'(lambda (x) (+ 2 x))
        '(2 5 7 3))

(mapcar #'copy-tree
        '((a b) (c d e)))

;; labels 关键字, 提供了一个方法, 能够同时利用闭包局部绑定(词法变量) 和 递归.
;; let的函数版本.

(defun count-instances (obj lsts)
  (labels ((instances-in (lst)
             (if (consp lst)
                 (+ (instances-in (cdr lst))
                    (if (eq (car lst) obj)
                        1
                        0))
                 0)))
    (mapcar #'instances-in lsts)))

(count-instances 'a '((a b c) (d a r p a) (d a r) (a a)))

;; 2.8 tail-recursion

(defun our-length (lst)
  (if (null lst)
      0
      (1+ (our-length (cdr lst)))))

(defun our-find-if (fn lst)
  (if (funcall fn (car lst))
      (car lst)
      (our-find-if fn (cdr lst))))

(defun our-length2 (lst)
  (labels ((rec (lst acc)
             (if (null lst)
                 acc
                 (rec (cdr lst) (1+ acc)))))
    (rec lst 0)))

;; 速度超过C的lisp 代码, 计算从 1 + 到 n
(defun triangle (n)
  (labels ((tri (c n)
             (declare (type fixnum n c)) ;类型声明,加快运行速度
             (if (zerop n)
                 c
                 (tri (the fixnum (+ n c))
                      (the fixnum (- n 1))))))
    (tri 0 n)))

(time (triangle 1000000))

;; 2.9 编译
;; lisp 函数 可以单独编译, 也可以以文件为单位进行编译(常用方法)

(defun foo (x)
  (1+ x))
(compile 'foo)                          ;编译一个函数
(compiled-function-p #'foo)             ;检查是否已经编译过

(progn
  (compile 'bar '(lambda (x) (* x 3)))
  (compiled-function-p #'bar))

;; 把 compile 集成进语言里意味着程序可以随时构造和编译新函数。不过,显式调用 compile 和调用 eval 一样,都属于非常规的手段,同样要多加小心

(defun 50th (lst)
  (nth 49 lst))

(proclaim '(inline 50th))

(defun foo (lst)
  (+ (50th lst) 1))
 

