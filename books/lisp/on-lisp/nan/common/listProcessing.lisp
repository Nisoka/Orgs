(proclaim '(inline last1 single append1 conc1 mklist))


;; 4.3 base
(defun last1 (lst)
  (car (last lst)))


;; 1 is a consp, 2 cdr is null. ==> single
(defun single (lst)
  (and (consp lst) (not (cdr lst))))

;; this is a push_back
(defun append1 (lst obj)
  (append lst (list obj)))

;; this is a push too, but a destroy version
(defun conc1 (lst obj)
  (nconc lst (list obj)))

(defun mklist (obj)
  (if (listp obj)
      obj
      (list obj)))


;; some bigger funcs about list processing.

(defun longer (x y)
  ;; on the labels local closure of function compare(x y)
  (labels ((compare (x y)
             (and (consp x)
                  (or (null y)
                      (compare (cdr x) (cdr y))))))
    (if (and (listp x) (listp y))
        (compare x y)
        (> (length x) (length y)))))

(defun filter (fn lst)
  (let ((acc nil))
    (dolist (x lst)
      (let ((val (funcall fn x)))
        (if val
            (push val acc))))
    (nreverse acc)))

;; source is a list, group n obj to a list, then get a ( (n*obj) (n*obj) ..)
(defun group (source n)
  (if (zerop n)
      (error "zero length"))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons (subseq source 0 n) acc))
                   (nreverse (cons source acc))))))
    (if source
        (rec source nil)
        nil)))



;; some double recursion utilities
(defun flatten (x)
  ;; flatten the x -> acc
  (labels ((rec (x acc)
             (cond
               ((null x) acc)
               ((atom x) (cons x acc))
               (t (rec (car x) (rec (cdr x) acc))))))
    (rec x nil)))

(defun prune (test tree)
  ;; rec the tree -> acc
  (labels ((rec (tree acc)
             (cond
               ((null tree) (nreverse acc))
               ((consp (car tree))
                (rec (cdr tree)
                     (cons (rec (car tree) nil) acc)))
               (t (rec (cdr tree)
                       (if (funcall test (car tree))
                           acc
                           (cons (car tree) acc)))))))
    (rec tree nil)))




;; ;;;;;;;;;;;;;;;;;;;;
(last1 "bule")
(last1 '(1 2 3))
(append1 '(1 2 3) 'a)
(conc1 '(1 2 3) 'a)

(filter #'(lambda (x)
            (if (numberp x)
                x))
        '(a 1 2 3 4 b 5 6 c))


(flatten '(a (a b) (d e) (x y z)))

(prune #'evenp '(1 2 (3 (4 5) 6) 7 8 (9)))



;; 4.4 list search
(defun find2 (fn lst)
  (if (null lst)
      nil
      (let ((val (funcall fn (car lst))))
        (if val
            (values (car lst) val)
            (find2 fn (cdr lst))))))

(defun before (x y lst &key (test #'eql))
  (and lst
       (let ((first (car lst)))
         (cond
           ((funcall test y first) nil)
           ((funcall test x first) lst)
           (t (before x y (cdr lst) :test test))))))

(defun after (x y lst &key (test #'eql))
  (let ((rest (before y x lst :test test)))
    (and rest
         (member x rest :test test))))

(defun duplicate (obj lst &key (test #'eql))
  (member obj
          (cdr (member obj lst :test test))
          :test test))

(defun split-if (fn lst)
  (let ((acc nil))
    (do ((src lst (cdr src)))
        ((or (null src)                 ;stop condtion
             (funcall fn (car src)))
         (values (nreverse acc) src))   ;stop return.
      (push (car src) acc))))


(before 'a 'b '(a))
(after 'b 'a '(a))
(after 'b 'a '(a b c))
(member 'b '(a b c))

(duplicate 'a '(a b c d e a b c))

(split-if #'(lambda (x) (> x 4))
          '(1 2 3 4 5 6 7 8 9))


;; obj compare; search

(defun most (fn lst)
  (if (null lst)
      (values nil nil)
      (let* ((wins (car lst))
             (max (funcall fn wins)))
        (dolist (obj (cdr lst))
          (let ((score (funcall fn obj)))
            (when (> score max)
              (setq wins obj
                    max score))))
        (values wins max))))

(defun best (fn lst)
  (if (null lst)
      nil
      (let ((wins (car lst)))
        (dolist (obj (cdr lst))
          (if (funcall fn obj wins)
              (setq wins obj)))
        wins)))

(defun mostn (fn lst)
  (if (null lst)
      (values nil nil)
      (let ((result (list (car lst)))
            (max (funcall fn (car lst))))
        (dolist (obj (cdr lst))
          (let ((score (funcall fn obj)))
            (cond
              ((> score max)
               (setq max score
                     result (list obj)))
              ((= score max)
               (push obj result)))))
        (values (nreverse result) max))))



(most #'length '((a b) (a b c) (d e f)))

(best #'> '( 1 2 3 4 5))

(mostn #'length '((a b) (a b c) (a) (d e f)))





