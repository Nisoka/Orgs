
;; ��ʱ������ һ�������Ѿ���������, �ٱ�����Ϊ���庯��, ����������
;; eg
(defun test-undefine-func (account)
  (setf account 0))

(defgeneric test-undefine-func (account)
  (:documentation "This is just a test!"))

;; ��Ҫȥ������д��Ķ���, ��Ҫ undefind ������ test-undefine-func �������
;; ��slime sbcl �� ����ͨ�� C-c C-u �����
