
;; lisp �ṩ��һ�� ������ �����ļ��ĺ�����
;; lisp ����������һ�� Ϊ��д���� �ṩһ�� ������ �� һ����Ϊ·������ �������
;; �����ṩ��һ�� �� ����ϵͳ �޹صĹ�������ļ��Ĵ���ʽ.
;; lisp ���ṩ�� ���صĶ�д S-���ʽ�Ĳ���.

;; 14.1 ��д�ļ�����
;; open close  read-char read-line  read(ֱ�Ӷ�ȡһ��S-���ʽ ����һ��lisp����)

;; read ���� ��lisp���е� ����replѭ���ж�ȡ��
;; print �Կɶ���ʽ��ӡlisp����. ����repl �еĴ�ӡ.
;; R E P L    ��ȡ ��ֵ ��ӡ ѭ��.

(defun test-io ()
  (let ((in (open "./name.txt" :if-does-not-exist nil)))
    (when in
      (loop for line = (read-line in nil)
           while line do (format t "~a~%" line))
      (close in))))


;; S-���ʽ ����� ���Ժܺõ���Ϊ�����ļ�����������ø�ʽ




;; 14.2 ��ȡ����������
;; openʱ ʹ�� :element-type '(unsigned-byte 8) ��ȡ������������
;; Ȼ��ʹ�� READ-BYTE ��ȡ���������ݡ�
;; �Ժ� ͨ��READ-BYTE  �����Ķ�ȡ�ṹ���Ķ���������

;; 
