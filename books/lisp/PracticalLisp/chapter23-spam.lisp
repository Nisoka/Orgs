
(defpackage :nan.learnlisp.spam
  (:use :common-lisp :nan.learnlisp.pathnames))

(defpackage :nan.learnlisp.spam2
  (:use :common-lisp :nan.learnlisp.pathnames))


(in-package :nan.learnlisp.spam2)
(defparameter *this-is-a-test-var* 11)

(in-package :nan.learnlisp.spam)


(defparameter *max-ham-score* 0.4)
(defparameter *min-spam-score* 0.6)

(defun classification (score)
  (cond
    ((<= score *max-ham-score*) 'ham)
    ((>= score *min-spam-score*) 'spam)
    (t 'unsure)))



(defclass word-feature ()
  ((word
    :initarg :word
    :accessor word
    :initform (error "Must supply :word")
    :documentation "The word this feature represents")
   (spam-count
    :initarg :spam-count
    :accessor spam-count
    :initform 0
    :documentation "Number of spams we have seen this feature in.")
   (ham-count
    :initarg :ham-count
    :accessor ham-count
    :initform 0
    :documentation "Number of hams we have seen this feature in.")))


(defvar *feature-database* (make-hash-table :test #'equal))
(defun clear-feature-database ()
  (setf *feature-database* (make-hash-table :test #'equal)))

(defun intern-feature (word)
  (or (gethash word *feature-database*)
      (setf (gethash word *feature-database*)
            (make-instance 'word-feature :word word))))

(defun extract-words (text)
  (delete-duplicates
   (cl-ppcre:all-matches-as-strings "[a-zA-Z]{3,}" text)
   :test #'string=))

(defun extract-features (text)
  (mapcar #'intern-feature (extract-words text)))








;; Train ...

(defvar *total-spam* 0)

(defvar *total-ham* 0)


(defun train (text type)
  (dolist (feature (extract-features text))
    (increment-count feature type))
  (increment-total-count type))

(defun increment-count (feature type)
  (ecase type
    (ham (incf (ham-count feature)))
    (spam (incf (spam-count feature)))))

(defun increment-total-count (type)
  (ecase type
    (ham (incf *total-ham*))
    (spam (incf *total-spam*))))

(defun clear-database ()
  (clear-feature-database)
  (setf
   *feature-database* (make-hash-table :test #'equal)
   *total-spam* 1
   *total-ham* 1))

(defun spam-probability (feature)
  (with-slots (spam-count ham-count) feature
    (/ spam-count (max 1 *total-spam*))))


(defun ham-probability (feature)
  (with-slots (spam-count ham-count) feature
    (/ ham-count (max 1 *total-ham*))))

(defun bayes-spam-probability (feature)
  (let ((basic-probability (spam-probability feature)))
    (* basic-probability (/ *total-spam* (+ *total-ham* *total-spam*)))))

(defun bayes-ham-probability (feature)
  (let ((basic-probability (ham-probability feature)))
    (* basic-probability (/ *total-ham* (+ *total-ham* *total-spam*)))))


(defun untrained-p (feature)
  (with-slots (spam-count ham-count) feature
    (and (zerop spam-count)
         (zerop ham-count))))

(defun score (features)
  (let ((spam-probs ())
        (ham-probs ()))
    (dolist (feature features)
      (unless (untrained-p feature)
        (print (float (bayes-spam-probability feature) 0.0d0))
        (print (float (bayes-ham-probability feature) 0.0d0))
        (let ((spam-prob (float (bayes-spam-probability feature) 0.0d0))
              (ham-prob (float (bayes-ham-probability feature) 0.0d0)))
          (push spam-prob spam-probs)
          (push ham-prob ham-probs))))
    (let ((spam-res (reduce #'+ spam-probs :key #'log))
          (ham-res (reduce #'+ ham-probs :key #'log)))
      (/ spam-res (+ spam-res ham-res)))))



(defun classify (text)
  (classification (score (extract-features text))))


