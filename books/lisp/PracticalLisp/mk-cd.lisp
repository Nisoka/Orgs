(defvar *db* nil)

(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))

(defun add-record (cd)
  (push cd *db*))

(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a: ~10t~a~%~}~%" cd)))

(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun prompt-for-cd ()
  (make-cd
   (prompt-read "Title")
   (prompt-read "Artist")
   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
   (y-or-n-p "Ripped [y/n]: ")))

(defun add-cds ()
  (loop (add-record (prompt-for-cd))
     (if (not (y-or-n-p "Another? [y/n]"))
         (return ))))


(defun save-db (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setq *db* (read in)))))

(remove-if-not #'evenp '(1 2 3 4 5 6 7 8 9))
(remove-if-not #'(lambda (x) (= 0 (mod x 2))) '(1 2 3 4 5 6 7 8 9))
;; 利用remove-if-not 选择 数据库中的记录, 但是比较简单,不具有通用性
;; where-old函数的通用性也很小, 不能修改数据库数据结构.
;; 使用where 宏 通用性最高, 并且代码很少, 不害怕后期数据库结构的修改.
(defun select-by-artist (artist)
  (remove-if-not
   #'(lambda (cd)
       (equal (getf cd :artist) artist))
   *db*))

(defun artist-selector (artist)
  #'(lambda (cd)
      (equal (getf cd :artist) artist))
  )



(defun where-old (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
      (and
       (if title (equal (getf cd :title) title) t)
       (if artist (equal (getf cd :artist) artist) t)
       (if rating (equal (getf cd :rating) rating) t)
       (if ripped-p (equal (getf cd :ripped) ripped) t))))

(defun select (selector-fn)
  (remove-if-not selector-fn *db*))

(defun update (selector-fn &key title artist rating (ripped nil ripped-p))
  (setq *db*
        (mapcar
         #'(lambda (row)
             (when (funcall selector-fn row)
               (if title (setf (getf row :title) title))
               (if artist (setf (getf row :artist) artist))
               (if rating (setf (getf row :rating) rating))
               (if ripped-p (setf (getf row :ripped) ripped)))
             row) *db*)))


(defun delete-rows (selector-fn)
  (setq *db* (remove-if selector-fn *db*)))


(defmacro backwards (expr) (reverse expr))

(defun make-comparison-expr (field value)
  `(equal (getf cd ,field) ,value))

(defun make-comparison-list (fields)
  (loop while fields
     collecting (make-comparison-expr (pop fields) (pop fields))))

(defmacro where (&rest clauses)
  `#'(lambda (cd)
       (and ,@(make-comparison-list clauses))))

