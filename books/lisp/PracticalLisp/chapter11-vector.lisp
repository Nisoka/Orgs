;; �����ͺ͹�ϣ��
(make-array 5 :initial-element nil)
(make-array 5 :fill-pointer 0)

(defparameter *x* (make-array 5 :fill-pointer 0))

(defparameter *x1* (make-array 5 :fill-pointer 0 :adjustable t))

(defun test-vector-push ()
  (dotimes (var 10)
    (vector-push-extend 'a *x*)
    (vector-push-extend 'b *x1*)))

;; 11.2 ����������
;; �ػ�����, ֻ�����ض����͵����ݣ��������Ը����յĴ洢����
;; eg �ַ��������ػ�����, ������Ϊ�ַ��������Ҫ �����кܶ��Լ����еĺ��������� �Լ� "" ��﷽��

(make-array 5 :fill-pointer 0 :adjustable t :element-type 'character)
;; λ����
;; :element-type 'bit


;; 11.3 ��Ϊ���е�����
;; �������б� ���� �������� ���е� ���־���������
;; �������к���, �ǿ���Ӧ���� �������б��

;; ע�� elt ��һ��֧��setf��λ�û�ú���.
(length *x*)
(elt *x* 4)
(setf (elt *x* 4) 'x)

;; 11.4 ���е�������
;; ���е����в������� �ײ�ʵ���϶��� length elt setf�����ʵ��.
;; ���в��������� ���кܶ� ����Ҫʹ��ѭ���ṹ���ܹ�ʵ�ֵ��������� ��������
;; count find position remove substitute
(count 1 #(1 2 3 1 2 2 2 ))
(remove 1 #(1 2 1 2 2 1 1 8 9))

(find 'c #((a 1) (b 2) (c 3) (d 5)) :key #'first :from-end t)

(remove #\a "foobarbaz" :count 1)
(remove #\a "foobarbaz" :count 1 :from-end t)


;; 11.5 �߽׺�������
(count-if-not #'evenp #((1 a) (2 b) (3 c) (4 d)) :key #'first)
(remove-if-not #'evenp #( 1 2 3 4 5 6))

;; 11.6 ���������ϵĲ���
(copy-seq #(1 2 3 4))
(reverse #(1 2 3 4 5))
(concatenate 'vector #(1 2 3) #(2 3 4 5))
(concatenate 'list #(1 2 3) #(2 3 4 5))
(concatenate 'string "abc" "dddd")

;; 11.7 ���� �� �ϲ�
;; sort stable-sort
;; Ϊ��Ч�ʵĿ���, sort���� ��һ���ƻ��Ժ���, ���ƻ�����Ĳ���,
;; ��� ��������޸�ԭ����, ���봫�������, ����ֱ�Ӵ�ԭ����
;; ����������� һ���ǲ�����Ҫԭ��������˳����, ����ʹ���ƻ��� �Ǻ����.
(sort (vector "foo" "bar" "baz") #'string<)

(defun test-sort ()
  (let ((my-seq (vector 1 3 88 12 94  92 12 3 4 5 33)))
    (print my-seq)
    (print (sort my-seq #'<))
    (print my-seq)
    ))

(defun test-merge ()
  (print (merge 'vector (vector 1 3 5) (vector 2 4 6) #'<))
  (print (merge 'list (vector 1 3 5) (vector 2 4 9 8 7) #'<))) 


;; 11.8 �����в���
(defun test-subseq ()
  (print (subseq "foobarbza" 3))
  (print (search "bar" "foobarbza")))

;; 11.9 ����ν��
(every #'evenp #(1 2 3 4 5))
(every #'< #(1 2 3 4) #(2 3 4 5))
(some #'> #(1 2 3 4) #(2 3 4 5))
(notany #'< #(1 2 3 4) #(0 1 1 1))

;; 11.10 ����ӳ�亯��
;; ͨ��ӳ�亯��, ������õ����к��� map
(map 'vector #'* #(1 2 3) #(2 3 4))
(reduce #'* #(1 2 3 4 5 6))
(reduce #'max #(1 2 3 91 811 21314 12 1 3))

;; 11.11 ��ϣ��
;; lisp �ṩ����һ��ͨ�ü��������� ��ϣ��
;; ��ϣ��������ʹ������������ʹ�����������Ϊ����������key��
;; ���ϣ�����ֵʱ, ���Խ����ݱ��浽һ��ȷ���ļ���λ����.
;; eql ���ж�����������ͬ�ĺ���
;; equal ������Ϊ�������ݵȼ� ������ȡ�
;; һ����Ҫ�жϵȼ۵����ݽṹ, ʹ�õ�Ĭ�϶���eql---��׼�ȼۺ���, ����һ�㶼����ͨ������
;; :test equal ��ʽָ�����Բ����������ϸ���
;; 
;; ��ϣ����Ҫ�����������й���,
;; 1 �жϼ�ֵ�ȼ��Ե� ��ֵ�ȽϺ���
;; 2 �Ӽ�ֵ�м������ϣ��Ĺ�ϣ����
;; make-hash-table ������ϣ��
;; gethash ���ʹ�ϣ����Ԫ��λ�� --- place.
;; gethash ��ķ���ֵ �� ��ֵ��ʽ, 1 �����ڼ��µ�ֵ��NIL(�޸ü�ֵ) 2 boolֵ��ʾ�Ƿ���ڸü�ֵ
;; �����ڶ�ָ����ʽ, һ��ֻ������ֵ, ʣ�µ�ֵ�����ע��,�ͻᱻ����.
(defparameter *h* (make-hash-table))

(defun test-hash ()
  (print (gethash 'foo *h*))
  (setf (gethash 'foo *h*) 'quux)
  (print (gethash 'foo *h*)))

(defun show-value (key hash-table)
  (multiple-value-bind (value present) (gethash key hash-table)
    (if present
        (format nil "Value ~a actually present." value)
        (format nil "Value ~a because key not found." value))))

(setf (gethash 'bar *h*) nil)
;; remhash �� gethash ��Ӧ, ����ɾ��һ����ֵ
;; clrhash ��ȫ��� ���е�hash�ļ�ֵ��

;; 11.12 ��ϣ�����
;; �����ڹ�ϣ������ �����ķ�ʽ ��������� MAPHASH
;; MAPHASH �� ����map����
;; ����Ϊ  1 �������ĺ��� 2 ��ϣ��
;; Ч���� �ڹ�ϣ���ÿһ����ֵ���ϵ���һ�θú���, �� �� ֵ ��Ϊ���� ����������
(maphash #'(lambda (k v) (format t "~a => ~a ~%" k v)) *h*)

(maphash #'(lambda (k v) (when (equal v NIL) (remhash k *h*))) *h*)
;; LOOP ��

(defun test-hash-iter ()
  (loop for k being the hash-keys in *h* using (hash-value v)
     do (format t "~a => ~a ~%" k v)))

;; lisp ֧�ֵ� �ܶ༯������(��list���͵�)���кܶ����ݡ�
;; eg ��ά���� λ���� �ȵĺ�����
;; ����11�½��ܵ� hash vector �Ѿ��ܹ�Ӧ���ܶ��������
;; ���� ���������� ���е������� �߽׺������� �����Բ�������  ����ϲ� �����в��� ����ν��  ����ӳ�亯��(ͨ�����в�������)
;; ��ϣ�� ��ϣ�������
