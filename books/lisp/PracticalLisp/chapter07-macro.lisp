;;7.1 when and unless
(if (> 2 3) "You" "me")

(defmacro my-when (condition &rest body)
  `(if ,condition (progn ,@body)))

;; 7.2 COND
(cond
  (a (dothex))
  (b (dothey))
  (T (dothedefault)))

;; 7.3 AND OR NOT
;; AND OR ʵ���˶����������ӱ��ʽ�� �߼��ϲ� �� �����Ĳ���
;; ʵ�ֶ�·����
;; AND false �����Ĳ���Ҫ��ְֱ���˳�
;; AND TRUE �������ֵ����ı��ʽ
;; OR TRUE �������Ƴ�
;; OR FALSE �������ı��ʽ

(not nil)
(not (= 1 1))
(and (= 1 2) (= 3 3))
(or (= 1 2) (= 3 3))

;; 7.4 7.5 ѭ��
;; lisp�������ѭ���� DO ʵ�ֵĽṹ
;; ����DO ������� �����ڸ���,
;; ��� ��DO��ʵ���� DOLIST DOTIMES�Ⱥ� ����һЩ�򵥳������
;; ���г��� �򻯴���
;; LOOP �� ���������� LISP �ܹ�ʵ���Լ��﷨������. Loop������
;; C�����Ե��﷨, ����Loop��һ����

(defmacro print-line (line)
  (print line)
  (format t "~%"))

(defun test-do ()
  (dotimes (i 5)
    (print i)
    (if (= i 3)
        (return)))
  (print-line "over the dotimes")
  (dolist (var '(1 2 3))
    (print var))
  (print-line "over the dolist")


  (do ((n 0 (1+ n))
       (cur 0 next)
       (next 1 (+ cur next)))
      ((= n 10) cur)
    (format t "n is ~a, cur is ~a, next is ~a~%" n cur next))

  (print-line "test get universal time")
  (let ((futhure-time (+ (get-universal-time) 5)))
    (do ()
        ( (> (get-universal-time) futhure-time))
      (format t "target time is ~a, cur is ~a ~%" (get-universal-time) futhure-time)
      (sleep 1)))
  )



;; 7.7 Loop
;; ������ʽ, ����ʽ �� ��չ��ʽ
;; ����ʽ ���� ����ѭ�� while(1){}
;;


(defun test-loop ()
  (print-line "test the base one")
  ;; (let ((future-time (+ (get-universal-time) 5)))
  ;;   (loop
  ;;      (when (> (get-universal-time) future-time)
  ;;        (return))
  ;;      (format t  "target is ~a, cur is ~a ~%" future-time (get-universal-time))
  ;;      (sleep 1)))

  (print-line "test the expend one")

  (setq loop1 (loop for i from 1 to 10 collecting i))

  (setq loop2 (loop for x from 1 to 10 summing (expt x 2)))


  (setq loop3
        (loop for i below 10
           and a = 0 then b
           and b = 1 then (+ b a)
             finally (return a)))
  (format t "~a~% ~a~% ~a~%" loop1 loop2 loop3)
  )




;; 8 ��ζ����Լ��ĺ�
;; �� ���ǲ��� ��ĳЩ����Ĵ���. ���ƾ����Զ����﷨�� C ��

;; 8.3 defmacro
;; ��������� ������ʽ(��Ԫ��Ϊ��� LISP��ʽ) ת��Ϊ�ض�Ŀ�Ĵ���

;; 8.4 do-primes

;; when ����if����������C��һ���Ǹ�ѭ��
(defun primep (number)
  (when (> number 1)
    (loop for fac from 2 to (isqrt number)
       never (zerop (mod number fac)))))

(defun next-prime (number)
  (loop for n from number
     when (primep n) return n))



(defun test-macro ()
  (do ((p (next-prime 0) (next-prime (1+ p))))
      ((> p 19))
    (format t "~d " p)))

(defmacro do-primes (var-and-range &rest body)
  (let ((var (first var-and-range))
        (start (second var-and-range))
        (end (third var-and-range)))
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var))))
         ((> ,var ,end))
       ,@body)))

(defmacro do-primes2 ((var start end) &body body)
  `(do ((,var (next-prime ,start) (next-prime (1+ ,var))))
       ((> ,var ,end))
     ,@body))

;; 8.6 ����չ��ʽ
;; macroexpand-1 ����һ�� macro ���ʽ, ���Բ��ܽ�����ֵ
;; ������Ҫʹ�� ����quote ���� ���ñ��ʽ�������������ֵ
(macroexpand-1 '(do-primes (var 0 19) (print var)))

;; 8.7 ��ס©��
;; ��©���ĳ��� leaky abstraction
;; й¶��һЩ���ó����װ������ϸ��
;; ��Ϊ�� ������Ǵ������ķ�ʽ, ��˱���ȷ���겻��������Ҫ��й¶

;; ����ܲ������ַ�ʽ��й¶, ����ÿ�ַ�ʽ�������׽��
;; 1 ������ֵ����, ����ͨ����do�в����� incf step����ȷ����ֵ
;; ����������ֵ����
(defmacro do-primes3 ((var start end) &body body)
  `(do ((ending-value ,end)
        (,var (next-prime ,start) (next-prime (1+ ,var))))
       ((> ,var ending-value))
     ,@body))

;; ����������������������©��
;; 2 ��ֵ˳������
(defmacro do-primes4 ((var start end) &body body)
  `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
        (ending-value ,end))
       ((> ,var ending-value))
     ,@body))


;; 3 �����ظ�����, �ڲ��ṩ��һ��ending-value����ʱ����
;; ���Ǻ�ʵ���ϲ�����һ������, û�в���һ���ֲ�������, ���ͬ���������������,
;; ��õķ������ں��ڲ�����ʱ���� ��Ҫ����һ�����Բ����ظ��ı�������---����
;; ��õķ����� ʹ�� GENSYM��ÿ�ε���ʱ����Ψһ�ķ���
;; GENSYM�����һ�� δ��Lisp��ȡ����ȡ���ķ���, ������Զ���ᱻ����
;; ��� GENSYM ��ÿ�α����ö�������һ���µķ���

;; ע�⣡�� ending-value-name ��һ������, �������һ��������, ʹ�� ,ending-value-name ���õ���ı���.
(defmacro do-primes5 ((var start end) &body body)
  (let ((ending-value-name (gensym)))
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))

;; ����©���ķ���
;; 1 ��չ��ʽ���κ�����ʽ����һ��λ����?, ʹ����ֵ˳�������õ�����ʽ��ͬ
;; 2 ȷ������ʽֻ��ֵһ��, ��������չ��ʽ�д���Ψһ���ű��������� ����ֵ������ʽ�����õ���ֵ.
;; 3 ʹ��gensym����Ψһ����  (let ((temp-value-name (gensym))))

;; 8.8 ��д��ĺ�
;; ����һ����д����ģʽ�ĺ�
;; һ�����������ɴ���, ���ɵĴ�������������Ĵ���
(defmacro with-gensym ((&rest name) &body body)
  `(let ,(loop for n in name collect `(,n (gensym)))
     ,@body))

(defmacro do-primes6 ((var start end) &body body)
  (with-gensym (ending-value-name)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
          (,ending-value-name ,end))
         ((> ,var ,ending-value-name))
       ,@body)))
