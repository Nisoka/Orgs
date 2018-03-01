
;; 19.1 19.2
;; 状况处理系统 - 更一般的错误处理系统
(define-condition malformed-log-entry-error (error)
  ((text
    :initarg :text
    :reader text)))

(defun parse-log-entry (text)
  (if (well-formed-log-entry-p text)
      (make-instance 'log-entry ...)
      (error 'malformed-log-entry-error :text text)))



(defun parase-log-file (file)
  (with-open-file (in file :direction :input)
    (loop for text = (read-line in nil nil)
       while text for entry = (restart-case (parase-log-entry text)
                                (skip-log-entry () nil))
         when entry collect it)))


(defun parase-log-entry (text)
  (if (well-formed-log-entry-p text)
      (make-instance 'log-entry ...)
      (restart-case (error 'malformed-log-entry-error :text text)
        (use-value (value) value)
        (reparase-entry (fixed-text) (parase-log-entry fixed-text)))))
