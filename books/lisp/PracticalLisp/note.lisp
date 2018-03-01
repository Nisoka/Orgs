
;; 有时候会出现 一个函数已经被定义了, 再被定义为广义函数, 会出错的问题
;; eg
(defun test-undefine-func (account)
  (setf account 0))

(defgeneric test-undefine-func (account)
  (:documentation "This is just a test!"))

;; 想要去掉上面写错的定义, 需要 undefind 函数将 test-undefine-func 解除定义
;; 在slime sbcl 中 可以通过 C-c C-u 解除绑定
