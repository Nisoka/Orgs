;; 向量和和哈希表
(make-array 5 :initial-element nil)
(make-array 5 :fill-pointer 0)

(defparameter *x* (make-array 5 :fill-pointer 0))

(defparameter *x1* (make-array 5 :fill-pointer 0 :adjustable t))

(defun test-vector-push ()
  (dotimes (var 10)
    (vector-push-extend 'a *x*)
    (vector-push-extend 'b *x1*)))

;; 11.2 向量子类型
;; 特化向量, 只保存特定类型的数据，这样可以更紧凑的存储数据
;; eg 字符串就是特化向量, 不过因为字符串如此重要 它具有很多自己独有的函数操作库 以及 "" 表达方法

(make-array 5 :fill-pointer 0 :adjustable t :element-type 'character)
;; 位向量
;; :element-type 'bit


;; 11.3 作为序列的向量
;; 向量和列表 都是 抽象类型 序列的 两种具体子类型
;; 所以序列函数, 是可以应用于 向量和列表的

;; 注意 elt 是一个支持setf的位置获得函数.
(length *x*)
(elt *x* 4)
(setf (elt *x* 4) 'x)

;; 11.4 序列迭代函数
;; 所有的序列操作函数 底层实际上都是 length elt setf的组合实现.
;; 序列操作函数中 具有很多 不需要使用循环结构就能够实现迭代操作的 迭代函数
;; count find position remove substitute
(count 1 #(1 2 3 1 2 2 2 ))
(remove 1 #(1 2 1 2 2 1 1 8 9))

(find 'c #((a 1) (b 2) (c 3) (d 5)) :key #'first :from-end t)

(remove #\a "foobarbaz" :count 1)
(remove #\a "foobarbaz" :count 1 :from-end t)


;; 11.5 高阶函数变体
(count-if-not #'evenp #((1 a) (2 b) (3 c) (4 d)) :key #'first)
(remove-if-not #'evenp #( 1 2 3 4 5 6))

;; 11.6 整个序列上的操作
(copy-seq #(1 2 3 4))
(reverse #(1 2 3 4 5))
(concatenate 'vector #(1 2 3) #(2 3 4 5))
(concatenate 'list #(1 2 3) #(2 3 4 5))
(concatenate 'string "abc" "dddd")

;; 11.7 排序 与 合并
;; sort stable-sort
;; 为了效率的考虑, sort函数 是一种破坏性函数, 会破坏传入的参数,
;; 因此 如果不能修改原数据, 必须传入给副本, 不能直接传原数据
;; 并且排序操作 一般是不再需要原本的数据顺序了, 所以使用破坏性 是合理的.
(sort (vector "foo" "bar" "baz") #'string<)

(defun test-sort ()
  (let ((my-seq (vector 1 3 88 12 94  92 12 3 4 5 33)))
    (print my-seq)
    (print (sort my-seq #'<))
    (print my-seq)
    ))

(defun test-merge ()
  (print (merge 'vector (vector 1 3 5) (vector 2 4 6) #'<))
  (print (merge 'list (vector 1 3 5) (vector 2 4 9 8 7) #'<))) 


;; 11.8 子序列操作
(defun test-subseq ()
  (print (subseq "foobarbza" 3))
  (print (search "bar" "foobarbza")))

;; 11.9 序列谓词
(every #'evenp #(1 2 3 4 5))
(every #'< #(1 2 3 4) #(2 3 4 5))
(some #'> #(1 2 3 4) #(2 3 4 5))
(notany #'< #(1 2 3 4) #(0 1 1 1))

;; 11.10 序列映射函数
;; 通用映射函数, 是最后常用的序列函数 map
(map 'vector #'* #(1 2 3) #(2 3 4))
(reduce #'* #(1 2 3 4 5 6))
(reduce #'max #(1 2 3 91 811 21314 12 1 3))

;; 11.11 哈希表
;; lisp 提供的另一种通用集合类型是 哈希表
;; 哈希表不仅允许使用整数，可以使用任意对象作为索引，或者key。
;; 向哈希表添加值时, 可以将数据保存到一个确定的键的位置下.
;; eql 是判断两个对象相同的函数
;; equal 可以认为数据内容等价 就是相等。
;; 一般需要判断等价的数据结构, 使用的默认都是eql---标准等价函数, 但是一般都可以通过传入
;; :test equal 方式指定测试参数来降低严格性
;; 
;; 哈希表需要两个函数进行构建,
;; 1 判断键值等价性的 键值比较函数
;; 2 从键值中计算出哈希码的哈希函数
;; make-hash-table 创建哈希表
;; gethash 访问哈希表中元素位置 --- place.
;; gethash 会的返回值 是 多值形式, 1 保存在键下的值或NIL(无该键值) 2 bool值表示是否存在该键值
;; 但对于多指的形式, 一般只看重首值, 剩下的值如果不注意,就会被丢掉.
(defparameter *h* (make-hash-table))

(defun test-hash ()
  (print (gethash 'foo *h*))
  (setf (gethash 'foo *h*) 'quux)
  (print (gethash 'foo *h*)))

(defun show-value (key hash-table)
  (multiple-value-bind (value present) (gethash key hash-table)
    (if present
        (format nil "Value ~a actually present." value)
        (format nil "Value ~a because key not found." value))))

(setf (gethash 'bar *h*) nil)
;; remhash 和 gethash 对应, 可以删除一个键值
;; clrhash 完全清楚 所有的hash的键值对

;; 11.12 哈希表迭代
;; 几种在哈希表项上 迭代的方式 最基本的是 MAPHASH
;; MAPHASH 和 序列map相似
;; 参数为  1 两参数的函数 2 哈希表
;; 效果， 在哈希表的每一个键值对上调用一次该函数, 把 键 值 作为参数 传给处理函数
(maphash #'(lambda (k v) (format t "~a => ~a ~%" k v)) *h*)

(maphash #'(lambda (k v) (when (equal v NIL) (remhash k *h*))) *h*)
;; LOOP 宏

(defun test-hash-iter ()
  (loop for k being the hash-keys in *h* using (hash-value v)
     do (format t "~a => ~a ~%" k v)))

;; lisp 支持的 很多集合数据(非list类型的)还有很多内容。
;; eg 多维数组 位数组 等的函数库
;; 但是11章介绍的 hash vector 已经能够应付很多变成情况了
;; 向量 向量子类型 序列迭代函数 高阶函数变体 序列性操作函数  排序合并 子序列操作 序列谓词  序列映射函数(通用序列操作函数)
;; 哈希表 哈希表迭代。
