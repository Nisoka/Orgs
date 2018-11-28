
(let ((town (find-if #'bookshops towns)))
  (values town (bookshops town)))


(defun bookshops (town)
  (if (null town)
      nil
      t))

(defun find-bookshop-town (towns)
  (if (null towns)
      nil
      (let ((shops (bookshops (car towns))))
        (if shops
            (values (car towns) shops)
            (find-bookshop-town (cdr towns))))))

;; 对 find-bookshop-town 的一次抽象
(defun find2 (fn lst)
  (if (null lst)
      null
      (let ((val (funcall fn (car lst))))
        (if val
            (values (car lst) val)
            (find2 fn (cdr lst))))))


;; 4.2 投资抽象函数--
(> (length x) (length y))

(mapcar fn (append x y z))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 下面介绍一些 实践中 被证明很有效的实用工具函数
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 4.3 列表处理


  
