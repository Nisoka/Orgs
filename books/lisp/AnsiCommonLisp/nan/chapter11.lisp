

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.3 slot properties
;; defclass you can define some!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass circle ()
  ((radius :accessor circle-radius      ;访问器, 可以不用slot-value 访问了.
           :initarg :radius             ;可以用在初始化参数中 初始化变量
           :initform 1)                 ;default value
   (center :accessor circle-center
           :initarg :center
           :initform (cons 0 0))))

(setf c (make-instance 'circle :radius 3))
(circle-radius c)
(circle-center c)

(defclass tabloid ()
  ((top-story :accessor tabloid-story
              :documentation "the doc of the slot"
              :type number
              :allocation :class)))     ;声明为类共享槽(变量)(默认是
                                        ;; :allocation :instance 对象变量.

(setf daily-blab (make-instance 'tabloid)
      unsolicited-mail (make-instance 'tabloid))
(setf (tabloid-story daily-blab) 'adultery-of-senator)
(tabloid-story unsolicited-mail)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.4 superclass or ? baseclass
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass graphic ()
  ((color :accessor graphic-color
          :initarg :color)
   (visiable :accessor graphic-visiable
             :initarg :visiable
             :initform t)))

(defclass screen-circle (circle graphic)
  ((color :initform 'puple)))

(graphic-color (make-instance 'screen-circle
                              :color 'red
                              :radius 3))
(graphic-color (make-instance 'screen-circle))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.6 generic function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defmethod combine (x y)
  (list x y))

(combine 'a 'b)

(defclass stuff ()
  ((name :accessor name
         :initarg :name)))
(defclass ice-cream (stuff)
  ())
(defclass topping (stuff)
  ())

(defmethod combine ((ic ice-cream) (top topping))
  (format t "~A ice-create with ~A topping"
          (name ic)
          (name top)))

(combine (make-instance 'ice-cream :name 'fig)
         (make-instance 'topping :name 'treacle))

(combine 23 'skiddoo)

(defmethod combine ((ic ice-cream) x)
  (format nil "~A ice-create with ~A"
          (name ic)
          x))

(combine (make-instance 'ice-cream :name 'Test)
         'a)

;; 对象特化!!! 可以省去判断值的操作?
;; 只有参数满足 eql 求值时, 就直接进入此函数
(defmethod combine ((x (eql 'powder)) (y (eql 'spark)))
  'boom)


;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.7 auxiliary method
;; ;;;;;;;;;;;;;;;;;;;;;;;;

;; :before :after :around
(defclass speaker ()
  ())

(defmethod speak ((s speaker) string)
  (format t "~%~A~%" string))

(defmethod speak :before ((s speaker) string)
  (format t "in speaker-method before "))

(defmethod speak :after ((s speaker) string)
  (format t " in speaker-method after"))

(speak (make-instance 'speaker)
       "I'm hungry")

(defclass intellectual (speaker)
  ())

(defmethod speak :before ((i intellectual) string)
  (princ "in intellectual-method before "))
(defmethod speak :after ((i intellectual) string)
  (princ " in intellectual-method after"))

(speak (make-instance 'intellectual)
       "I'm hungry")
;; will call the before of self, and then call the father's before
;; --- before-self -> before-father -> main-method -> after-father -> after-self


(defclass courtier (speaker)
  ())

(defmethod speak :around ((c courtier) string)
  (format t "Does the king believe that ~A?" string)
  (if (eql (read) 'yes)
      (if (next-method-p)
          (call-next-method))
      (format t "Indeed, it a ??? idea. ~%"))
  'bow)

(speak (make-instance 'courtier) "kings will last")


;; ;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.8 method combination
;; ;;;;;;;;;;;;;;;;;;;;;;;;;

(defgeneric price (x)
  (:method-combination +))

(defclass jacket ()
  ())

(defclass trouser ()
  ())

(defclass suit (jacket trouser)
  ())

(defmethod price + ((jk jacket))
  350)
(defmethod price + ((tr trouser))
  200)

(price (make-instance 'suit))

;; 下列符号可以用来作为 defmethod 的第二个参数
;; 作为 defgeneric 调用中，method-combination 的选项 形成函数组合.
;; +    and    append    list    max    min    nconc    or    progn

;; 一旦你指定了通用函数要用何种方法组合，所有替该函数定义的方法必须用同样的机制。
;; 如果我们想要改变 price 的方法组合机制，我们需要通过调用 fmakunbound 来移除整个通用函数


;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.9 封装
;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; 在 Common Lisp 里，包是标准的手段来区分公开及私有的信息
;; 隐藏实现细节带来两个优点：
;; 你可以改变实现方式，而不影响对象对外的样子，
;; 你可以保护对象在可能的危险方面被改动
;; 隐藏细节有时候被称为封装 (encapsulated)。
;; 要限制某个东西的存取，我们将它放在另一个包里，
;; 针对外部介面，仅输出需要用的名字。

;; 我们可以通过输出可被改动的名字，来封装一个槽，但不是槽的名字
;; 不export槽, 而 export一个封装了槽的方法
;; 这样 包外部的代码 只能够创建 counter 实例,
;; 也可以调用关联了counter的方法 increment clear 作为接口
;; 来通过该接口操作counter内部数据
;; 但是不可以直接操作counter内部数据槽

(defpackage "CTR"
  (:use "COMMON-LISP")
  (:export "COUNTER" "INCREMENT" "CLEAR"))

(in-package ctr)

(defclass counter ()
  ((state :initform 0)))

(defmethod increment ((c counter))
  (incf (slot-value c 'state)))

(defmethod clear ((c counter))
  (setf (slot-value c 'state) 0))

;; ????????????????????????
;; 如果你想要更进一步区别类的内部及外部介面，并使其不可能存取一个槽所存的值，
;; 你也可以在你将所有需要引用它的代码定义完，将槽的名字 unintern：

;; (unintern 'state)

;; 则没有任何合法的、其它的办法，从任何包来引用到这个槽


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.10 two models
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ???????????????????????
