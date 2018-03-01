


;; 17.1 defclass
;; (defclass name (direct-superclass-name*)
;;   (slot-specifier*))

;; base class must be class -- STANDARD-OBJECT(default - no direct-superclass-name) or some class based on STANDARD-OBJECT.

;; (defclass bank-account () ...)          ; no point, that mean STANDARD-OBJECT is the base class
;; (defclass checking-account (bank-account) ...)
;; (defclass savings-account (checking-account) ...)






;; 17.2 class slot place. is a member variable.

(defclass bank-account ()
  (customer-name
   balance))          ; no point, that mean STANDARD-OBJECT is the base class

(print (make-instance 'bank-account))

(defparameter *account* (make-instance 'bank-account))
(setf (slot-value *account* 'customer-name) "john Doe")
(setf (slot-value *account* 'balance) 1000)


(defclass checking-account (bank-account)
  ())
(defclass savings-account (checking-account) ...)





;; 17.3 object initialize.
;; 1 :initarg  make-instance key parameters
;; 2 :initform  defaults value-form
;; 3 initialize-instance method  make-instance then initailize method


(defclass bank-account ()
  ((customer-name
    :initarg :customer-name
    :initform (error "Must supply a customer name."))
   (balance
    :initarg :balance
    :initform 0)
   (account-number
    :initform (incf *account-number*))
   account-type))

(defvar *account-number* 0)

(setf *account* (make-instance 'bank-account :customer-name "Ian" :balance 100))



(defmethod initialize-instance :after ((account bank-account) &key)
  (let ((balance (slot-value account 'balance)))
    (setf (slot-value account 'account-type)
          (cond
            ((>= balance 100000) :glod)
            ((>= balance 50000) :silver)
            (t :bronze)))))

(defmethod initialize-instance :after ((account bank-account) &key opening-bonus-percentage)
  (when opening-bonus-percentage
    (incf (slot-value account 'balance)
          (* (slot-value account 'balance) (/ opening-bonus-percentage 100)))))

(defparameter *acc* (make-instance 'bank-account
                                   :customer-name "Sally Sue"
                                   :balance 10000
                                   :opening-bonus-percentage 5))



;; make-instance slot-value
;; 

(defgeneric balance (account)
  (:documentation "Get the balance of a account"))


(defmethod balance ((account bank-account))
  (slot-value account 'balance))

;; (defun (setf customer-name) (name account)
;;   (setf (slot-value account 'customer-name) name))

(defgeneric (setf customer-name) (name account)
  (:documentation "setf the account customer-name's value"))

(defmethod (setf customer-name) (name (account bank-account))
  (setf (slot-value account 'customer-name) name))

(defgeneric customer-name (account)
  )

(defmethod customer-name ((account bank-account))
  (slot-value account 'customer-name))

(setf (customer-name *account*) "Sally Sue")
(customer-name *account*)





;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *account-number* 0)

;; auto generate the slot generic method..
;; Then the class of bank-account can define like ...
(defclass bank-account ()
  ((customer-name
    :initarg :customer-name
    :initform (error "Must apply a customer name.")
    :accessor customer-name
    :documentation "Custome's name")
   (balance
    :initarg :balance
    :initform 0
    :reader balance
    :documentation "Current account balance")
   (account-number
    :initform (incf *account-number*)
    :reader account-number
    :documentation "Account number, unique with a account")
   (account-type
    :reader account-type
    :documentation "Type of account")))





;; 17.5 WITH-SLOTS & WITH-ACCESSORS
;;

;; 17.6
;; :allocation
;; :allocation :instance ---- normal variable
;; :allocation :class    ---- static member variable

;; 17.7 slot and inherit
;; :after ....

;; 17.8 good object designed.


(defun test-class ()
  (make-instance)
  (print (slot-value *account* 'balance)))
