
;; lisp 就是 list process。
;; 所以list 是LISP最重要的数据结构.
;; list 对特定问题 提供了 极佳的解决方案
;; 例如 将代码表示为数据，从而支持代码生成 和 代码转换
;; list 也是表示 任何异构和层次数据的极佳数据结构
;; list 相当轻量级 并且支持函数式变成风格
;; list 的工作方式应该更加深刻理解, 如此才能 灵活的使用list

;; 12.1 list列表 没有列表 是 CONS组合
;; list 是构建在更基本数据类型上的 抽象数据类型。
;; list 的基础类型 是 cons  点对类型  cons cell -- 是成对的值
;; CONS -- construct
;; CONS 两个参数。
;; CONS == CAR+CDR
;;

(car (cons 1 2))
(cdr (cons 1 2))
;; car cdr 都返回位置， 可以使用setf.

(defparameter *cons* (cons 1 2))
(setf (car *cons*) 10)
;; CONS 点对 中的两个值可以使对任意类型对象的 引用。
;; 因此可以通过 CONS-CONS-CONS 这样连接形成 list
;; list中的元素 保存在 CONS中的car中， 然后用 cdr进行连接下一个CONS， 就是一个C中的 link.
;; 链中的最后一个CONS的CDR=NIL（同时代表空list 和 false）。
;; lisp中将 link 直接内置为 list类型. 相当重要.
;; lisp 对cons的支持很多, 以至于让lisp 就叫做 list处理语言.
;; 因此 一个list 实际上 和 C中的 link 列表一样, 之际上就是一个 CONS对象, 不过CONS
;; 不过CONS对象后面会接有其他的CONS 构成一个序列.
;; lisp 中能够理解CONS构建的列表, 并加以很多处理方式.
(cons 1 nil)
(cons 1 (cons 2 nil))                   ;这样 最后一个 CONS的CDR 必须是nil 才会形成 正常的list
(cons 1 (cons 2 3))                     ;这样最后一个CONS的 CDR 不是nil 会形成 (1 2 . 3)的形式, 不算一个list
(cons 1 (cons 2 (cons 3 nil)))

;; 而当你想要创建一个list 时 可以使用lisp提供的list的库函数
;; (list 1 2 3) 直接构建一个 CONS序列 --- list 类型对象.
(list 1 2 3)                            ;===== (cons 1 (cons 2 (cons 3 nil)))

(defparameter *list* (list 1 2 3 4))
(first *list*)                          ;1        返回CONS 的CAR , 是元素值
(rest *list*)                           ;(2 3 4)  返回CONS 的CDR , 实际上是个CONS 构建的list 所以返回的是 (2 3 4)

;; 保存list 的list

(list "foo" (list 1 2) 10)              ;("foo" (1 2) 10)

;; 因为list 可以保存任意类型, 所以list可以用来表示任意深度与任意复杂度的树
;; 因此 list 可以作为 任何异构和层次结构数据的 极佳表达方式
;; 例如 lisp 构建的XML 处理器 常常直接用list保存xml文档。
;; 另一个树形结构数据 就是 lisp代码
;; 后面 会介绍一个HTML生成库. 使用list的list来保存html数据
;; 13 章描述如何用点对来表示其他数据结构
;; lisp 中 对list 构建了一个很大的函数库
;; 利用函数式编程方式思想考虑这些函数 易于理解.

;; 12.2 函数式编程和列表
;; 函数式编程的本质 就是 程序完全由没有副作用（不破环参数数据）的函数组成.
;; ？？？？ 这一小节到底讲了什么？？？
(append (list 1 2 3) (list 2 3 4))      ;结果 (list 1 2 3 2 3 4) 会与 (list 2 3 4) 共享后面的list结构.
;; 共享结构
;; 函数式编程 有时候会有共享结构的情况
;; eg 刚刚的append 函数 是list函数, list函数一般都是函数式实现的。
;; 而对于list的函数式编程 会使用共享结构的方式实现函数式。
;; append 不会修改 两个参数列表, 而产生一个新的list.
;; 但是又会尽量的较少内存消耗. 实现高效率.
;; 



;; 12.3 破坏性操作
;; 破坏性操作-改变对象的的状态就是破坏
;; 破坏性分为两种 1 副作用性 2 回收性操作

;; 1 副作用性操作
;; 是那些专门利用副作用的操作。
;; setf 绝对是破坏性的
;; 破坏性操作 尤其需要注意的是 一些共享结构.
;; eg 

(defparameter *list-1* (list 1 2 3))
(defparameter *list-2* (list 2 3 4))
(defparameter *list-3* (append *list-1* *list-2* ))

;; 这里 list-3 list-2 会共享 结构. 所以一个 setf破坏性操作, 会同时修改 *list-2* *list-3*
(setf (first *list-2*) 0)

;; 2 回收性操作
;; 本来就是用于函数式代码中。
;; 他们的副作用仅是一种优化手段。
;; 他们在构造结果时, 会重用来自他们实参的特定 点对单元。
;; 但是 回收性操作 和 append这种在返回列表中直接 与 传入实参共享结构的函数不同的是,
;; 回收性操作 将点对单元作为原材料重用, 在必要时候 还会修改 CAR CDR 来构建想要的结果.
;; 因此只有当原来的列表参数 不在被需要时候, 才可以直接使用回收性函数

;; reverse  nreverse 分别是逆序 的 非回收性 与 回收性函数
;; reverse 不会修改参数, 而为创建的逆序列表的每个元素都分配一个新的点对单元。
;; nreverse 会回收原参数列表的每个 CONS对象, 通过修改每个CONS对象的CDR 实现逆序。
;; 这样回收性函数不需要重新分配节点,并且没有产生垃圾回收操作.
;; 一般 回收性的破坏性函数 都配对一个 非破坏性的同名函数.

(defparameter *x* (list 1 2 3))
(defparameter *y* (list 4 5 6))
(nconc *x* *y*)

;; 12.4 组合回收性函数 和 共享结构
;; 共享结构 和 回收性函数
;; 共享结构 是 基于不在乎究竟是由哪些点对单元构成列表的假设, 不管是那些点对单元被共享, 只要能够构成目的结果的list即可
;; 这样在不改变输入list 的前提下, 尽可能少的重新构建点对单元.

;; 回收性函数 是 基于必须要求构成结果的所有点对单元会在哪里被引用到.
;; 或者说当前的单元不管有没有别人用到, 不管不顾的从参数列表中取得点对单元，然后构造结果列表.
;; 这样很可能会导致参数列表 被破坏.


;; 自己构建回收性函数的一般习惯是
;; 构造一个局部列表, 然后用push 向局部列表前端加入 点对单元。 最后通过NREVERSE 就可以返回结果对象.
(defun upto (max)
  (let ((result nil))
    (dotimes (i max)
      (push i result))
    (nreverse result)))


;; 12.5 列表处理函数
;; 如下才是真的 列表处理函数库
;; first second third .. tenth. 的调用 + rest  + NTH 直接获得任意位置的元素
;; car cdr  caar  cddr  cadadr ....  这些函数必须应用于 list的list 才有用, 因为 普通list 的CAR 只能获取一次, car car 就获得不到东西.

;;


;; 12.6 映射
;; 函数式编程的另一个重要方面 是 高阶函数的使用.
;; MAP 可以应用于任何 序列结构上, 而list还有除了MAP之外的 几个映射函数(不同在于构造结果的方式)
(map 'list #'(lambda (x) (* 2 x)) (list 1 2 3))
(mapcar  #'(lambda (x) (* 2 x)) (list 1 2 3))          ;不需要生成结构类型, 必须生成list类型


;; 12.7 其他结构
;; 点对单元 和 列表
;; 使用点对单元 或者 列表的列表 表示树.




