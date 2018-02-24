;; lexicon(local) dynamic(global)

;;6.1 base knowlage
;; (let (variable-initial-form*)
;;      body-form*)

(defun test-let (x)
  (format t "Parameter: ~a test ~%" x)
  (let ((x 2))
    (format t "Outer Let: ~a OO ~%" x)
    (let ((x 3))
      (format t "Inner Let: ~a ii ~%" x))
    (format t "Outer Let: ~a OO ~%" x))
  (format t "Parameter: ~a test ~%" x))

;;6.2 lexicon variable and closure
;; ����������lambda�� ���Թ���һ���հ�
(defparameter *fn*
  (let ((count 0))
    #'(lambda ()
        (setq count (+ count 1)))))


;; 6.3 dynamic �� global ��������
;; ���ǿ���ʵ��, ��ĳ������������, ʵ�����°�, ����ĳ���������ý�����, ����ԭ��
;; ����ȫ�ֱ������Ƕ�̬����, ����������������˵�����⹦��
;; ��һ�������� ���� Ϊ ȫ�ֱ���ʱ, ������let����ֲ��� func�����β�ʱ������ �ʷ�������ʱ
;; ȫ�ֱ������е����Ի��� let function ����ʷ������� ��Ч, ��ɶ�̬��.
;; �����ʱ�� �������ʷ�������ʱ, ϣ��֪���Ƿ��Ǹ�ȫ�ֱ����� ��������Լ���������� ȫ�ֱ�����**��Χ����
(defvar *count* 0)
(defun increment-widget-count ()
  (incf *count*))
(defun print-count ()
  (format t "before is ~18t~d ~%" *count*)
  (setq *count* (+ *count* 1))
  (format t "after is ~18t~d ~%" *count*))

(defun dynamic-band ()
  (print-count)
  (let ((*count* 0))
    (print-count)
    )
  (print-count))

(defun change-count (x)
  (setq *count* x))


;; 6.4 ���� constant variable
;;
(defconstant +pi+ 3.14)
(defconstant pppp 2.2222)

;; 6.5 ��ֵ
;; set and get
(setf *count* 1)
;; setf �ڲ�����ݱ����Ĳ�ͬ��� ���ܻ����setq ������������
;; setf ��һ���꣬ ��setq��һ��������
(incf *count*)
(decf *count*)
