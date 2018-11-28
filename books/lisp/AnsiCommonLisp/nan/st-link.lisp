;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; 12.1 shared structure
;;

(defun our-tailp (x y)
  (or (eql x y)                       ;or : one true is true, one true return.
      (and (consp y)                  ;and: all true is true, one false return
           (our-tailp x (cdr y)))))   ;recurasion: return stop recursion.

;; 'whole 'part share the 'part.
(setf part (list 'b 'c))
(setf whole (cons 'a part))

(tailp part whole)
(our-tailp part whole)


;; 'whole1 'whole2 part share the 'part
(setf part (list 'b 'c)
      whole1 (cons 1 part)
      whole2 (cons 2 part))

;; 当存在嵌套列表时，重要的是要区分是列表共享了结构，还是列表的元素共享了结构。
;; 顶层列表结构指的是，直接构成列表的那些 cons ，而不包含那些用于构造列表元素的 cons

(setf element (list 'a 'b)
      holds1 (list 1 element 2)
      holds2 (list element 3))

;; 这样的copy 会逐个拷贝顶层list的元素,
;; 但是嵌套列表因为是顶层list的一个元素,因此依旧会共享
(defun our-copy-list (lst)
  (if (null lst)
      nil                               ;stop condition
      (cons (car lst) (our-copy-list (cdr lst))))) ;recursion cons

;; 如果将嵌套list 看作树, 则内部嵌套list元素可以认为是左子树
;; 这样的copy-tree 会所有元素都拷贝, 因此不会再存在任何共享结构.
(defun our-copy-tree (tree)
  (if (atom tree)
      tree
      (cons (our-copy-tree (car tree))
            (our-copy-tree (cdr tree)))))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 12.2 modification
;; 要避免共享结构, 因为共享结构, 会导致不期待的修改另外一个结构的数据.
;; 无意的修改了共享结构，一次会修改两个对象, 这将会引入一些非常微妙的 bug。
;; Lisp 程序员要培养对共享结构的意识，并且在这类错误发生时能够立刻反应过来。
;; 当一个列表神秘的改变了的时候，很有可能是因为改变了其它与之共享结构的对象

;; 当你调用别人写的函数的时候要加倍小心。除非你知道它内部的操作，
;; 否则，你传入的参数时要考虑到以下的情况：

;; 1.它对你传入的参数可能会有破坏性的操作

;; 2.你传入的参数可能被保存起来，如果你调用了一个函数，然后又修改了之前作为参数传入该函数的对象，那么你也就改变了函数已保存起来作为它用的对象[1]。
;; -----------------------------------------------
;; 在这两种情况下，解决的方法是传入一个拷贝。
;; -----------------------------------------------



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 12.3 queues : shared struct example

;; 使用list 实现 queue : 一个队列就是一'对'列表

(defun make-queue ()
  (cons nil nil))

(defun enqueue (obj q)
  (if (null (car q))
      ;; if empty, q-head q-tail point same
      (setf (cdr q) (setf (car q) (list obj)))
      ;; else, q-tail-pointer point new obj,
      ;;       and q-tail point new obj,
      ;;       then the q-tail-pointer point the last obj
      (setf (cdr (cdr q)) (list obj)    
            (cdr q) (cdr (cdr q))))
  (car q))

(defun dequeue (q)
  (pop (car q)))

(setf q1 (make-queue))
(progn
  (enqueue 'a q1)
  (enqueue 'b q1)
  (enqueue 'c q1)
  (enqueue 'd q1)
  (enqueue 'e q1)
  (enqueue 'f q1)
  )

q1

(dequeue q1)
