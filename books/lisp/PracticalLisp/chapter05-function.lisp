(defun func-name (paramter)
  "optional documention string."
  (format t paramter))

(func-name "hello func")


(defun verbose-num (x y)
  "sum any two numbers after printing a message"
  (format t "sum ~d and ~d. ~%" x y)
  (+ x y))

(verbose-num 1 3)

(defun foo (a b &optional c d)
  (list a b c d))

(foo 1 2)
(foo 1 2 3)

(defun foo2 (a b &optional (c 10))
  (list a b c))

(foo2 1 2)

(defun make-rectangle (width &optional (height width))
  (format t "~%rectangle is ~d X ~d. ~%" width height))

(make-rectangle 10)

(defun foo3 (a b &optional (c 3 c-))
  (list a b c c-))

(foo3 1 2)

(defun rest-format-para (&rest values)
  (format t "~%~d~%" values))

(rest-format-para "this" "is" "a" "test")


;; 关键字 以冒号开始的符号 是以自身为值的 常量变量.
(defun key-foo (&key a b c)
  (list a b c))

(key-foo :a 1 :b 4 :c 1111)

(defun key-foo-default (&key (a 0) (b 1 b-p) (c 3))
  (list a b c b-p))


(key-foo-default :a 1 :b 1 :c 1)
