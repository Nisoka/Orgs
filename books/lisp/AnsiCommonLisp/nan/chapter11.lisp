

;; struct
;; lisp struct will define some base function associated with the struct
;; eg: make-rectangle rectangle-p  rectangle-height 
(defstruct rectangle
  height width)

(defstruct circle
  radius)

(defun area (x)
  (cond ((rectangle-p x)
         (* (rectangle-height x) (rectangle-width x)))
        ((circle-p x)
         (* pi (expt (circle-radius x) 2)))))


;; class
;; list defclass doesn't define any base class
;; but you can use general functions : (make-instance class)  (slot-value class 'member)
;; you can define your class function use
;; (defmethod func ((obj class)) body)
(defclass rectangle ()
  (height width))

(defclass circle ()
  (radius))

(defmethod area ((x rectangle))
  (* (slot-value x 'height) (slot-value x 'width)))

(defmethod area ((x circle))
  (* pi (expt (slot-value x 'radius) 2)))



;; 11.3 slot properties
;; defclass you can define some!!!
(defclass circle ()
  ((radius :accessor circle-radius      ;访问器, 可以不用slot-value 访问了.
           :initarg :radius             ;可以用在初始化参数中
           :initform 1)                 ;default value
   (center :accessor circle-center
           :initarg :center
           :initform (cons 0 0))))


