

(defgeneric withdraw (account amount)
  (:documentation "Withdraw the specified amount from the account"))


(defmethod withdraw ((account bank-account) amount)
  (when (< (balance account) amount)
    (error "Account overdown"))
  (decf (balance account) amount))

(defmethod withdraw ((account checking-account) amount)
  (let ((overdraft (- amount (balance account))))
    (when (plusp overdraft)
      (withdraw (overdraft-account account) overdraft)
      (incf (balance account) overdraft))
    (call-next-method)))

(defmethod withdraw ((account (eql *account-of-bank-president*)) amount)
  (let ((overdraft (- amount (balance account))))
    (when (plusp overdraft)
      (incf (balance account) (embezzle *bank* overdraft)))
    (call-next-method)))


(defmethod withdraw ((proxy proxy-account) amount)
  (withdraw (proxied-account proxy) amount))






(defmethod withdraw :before ((account checking-account) amount)
  (let ((overdraft (- amount balance account)))
    (when (plusp overdraft)
      (withdraw (overdraft-account account) overdraft)
      (incf (balance account) overdraft))))

;; main method and before method is this order that the more realty the forward.
;; and the after is the backward.

;; 3 2 1    3 2 1     1 2 3
;; before   main      after





(defgeneric priority (job)
  (:documentation "Return the priority at which the job should be run.")
  (:method-combination +))


