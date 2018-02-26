
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

;; 14.3 ������ȡ
;; read-sequence ���ж�ȡ, ���ظ���ȡread-byte read-char �����һ�����и�Ц

;; 14.4 �ļ����
;; print pprint  write-char write-line write-string terpri fresh-line 
;; ��Ҫָ��open���� :direction :output

;; 14.5 �ر��ļ�
;; close
;; һ���ļ��ı�׼ʹ��ϰ�� ����ģ��
(let ((stream (open "/some/some.file")))
  ;; do stuffs with steam
  (close stream))

;; ȷ����������һ���ض������(������ �ر��ļ�����, ���뱻����)
;; ʹ�� UNWIND-PROTECT
;; ������ UNWIND-PROTECT ֮�ϵĺ� WITH-OPEN-FILE ��װ������Ľṹ
(WITH-OPEN-FILE (stream "some.file")
  ;; do stuffs with stream )
  )
;; WITH-OPEN-FILE ��ȷ��stream ���� WITH-OPEN-FILE ����֮ǰ���ر�.

(WITH-OPEN-FILE (stream "/some/some.file" :direction :output)
  (format stream "Some text."))

;; ����99%���ļ�IO���������õ� WITH-OPEN-FILE
;; ��Ҫʹ����ԭʼ�� OPEN CLOSE �������
;; 1 �㲻��ʹ�� WITH-OPEN-FILE
;; 2 ȷʵ��Ҫ���ر������ eg ��׼��cin cout ��һ�±��� , ֪��������� ����close.

;; 14.6 �ļ���
;; �ļ�·�� �������᲻����ϵͳ��ֲ��
;; lisp �ṩ�˿���ֲ·��������.
;; ����ϵͳ��·���ַ��� �� lispʵ���ļ�·�� ��ת����������ͨ��lisp���.
;; �û�֪������ϵͳ�е��ļ�·��, �����ṩ�����ļ�·���ַ���. ���ݸ�lisp����õ� lisp·��.
;; ϵͳ����ļ����ַ��� lisp·������ lisp�ļ��� �ܳ�Ϊ·���������� pathname designer
;;

;; 14.7 ·���� ��α�ʾ�ļ���
;; ·����: ����host , �豸device , Ŀ¼directory , ����name , ����type , �汾version��
;; �� �ļ����ַ��� ֱ�ӽ���Ϊһ�� ·��������.
;; eg PATHNAME ����һ��·����������(�ļ����ַ���/lisp·������/lisp�ļ���)

(pathname-directory (pathname "/foo/bar/baz.txt"))
(pathname-name (pathname "/foo/bar/baz.txt"))
(pathname-type (pathname "/foo/bar/baz.txt"))

;; ·���� Ҳ��һ�� ������������ ·��������� S-���ʽΪ-- #p""
;; �����ӡ����ȡ�غ���·��������� S-���ʽ
;; 
(pathname "/foo/bar/baz.txt")

;; NAMESTRING ���Խ�һ��·�������� ת��Ϊ �ļ����ַ���

;; 14.8 ������·����
;; make-pathname ����һ��·��������
(make-pathname
 :directory '(:absolute "foo" "bar")
 :name "baz"
 :type "txt")

(make-pathnem
 :type "html"
 :defaults input-file)

(make-pathname
 :directory '(:relative "backups")
 :defaults #p"/foo/bar/baz.txt")

;; merge-pathname
;; ���Ժϲ�����·��.

;; *default-pathname-defaults* ��һ��Ĭ��LISPĿ¼.
;; ��һ��lisp ·�������� ȷʵһЩ���ʱ, �ڸö���open��ʹ��ʱ, �ͻ����� *default-pathname-defaults*�е�������


;; 14.9 Ŀ¼�������ֱ�ʾ����
;; linux windows ����Ŀ¼Ϊһ���������͵��ļ�
;; ���� Ŀ¼���ַ����е��������Ԫ�� ���Է��� ·���������е�������� ���� ������Ŀ¼�����, ���ֱ�ʾ�����ԡ�


;; 14.10 ���ļ�ϵͳ����
(probe-file "name.txt")
(directory ".")
;; delete-file rename-file       ;; �ɹ�ʱ ������, �������һ�� file-error ����
;; rename-file ��������·����������, ������1���� Ϊ2����
;; ensure-directories-exist ������Ŀ¼, ���ر����ݵ�·����.
;; file-write-date �����ļ��ϴ�д��ʱ��
;; file-author �ļ�ӵ����
;;
;; ������Ϊ����
;; file-length --------- ��������������·������Ϊ����, ���˺���ֻ����һ������
;; ���ʹ�� file-length ������ͬһ�� open
;; file-postion Ҳ��������Ϊ�������, ���ص�ǰ���ļ��еĵ�ǰλ��---- �Ѿ�д����ȡ����������
;; ���� ����λ��������-p ����file-postion ʱ, �����ĵ�ǰλ������Ϊ λ��������-p.
;; λ�������� 1 :start 2 :end 3 �Ǹ�����
;;


;; 14.11 ������IO����
;; �� ���� �ļ��� ��, lisp��֧���������͵���. ���ǿ������ڸ��� ���� д ��ӡ��IO����
;; eg
;; string-stream ��һ���ַ�����д����
;;        make-string-input-stream make-string-output-stream ������string-stream
;; make-string-input-stream ����Ҫ���ַ������� �Լ�һ����ѡ�Ŀ�ʼ����ָʾ���������ַ���������Ӧ�ö�д������
;;    ����һ���ɱ����ݵ��κ�READ-CHAR READ-LINE READ �������� �ַ�----char �����뺯�����ַ�����

(defun fstring-to-float (fString)
  (let ((s (make-string-input-stream fString)))
    (UNWIND-PROTECT (read s)
      (close s))))

;; make-string-output-stream ����һ���� ���Ա� format print write-char write-line �Ƚ������������
;; with-input-from-string �� with-open-file ����
(with-input-from-string (s "1.23")
  (READ s))

;; ��������һЩ������
;; broadcast-stream �㲥��. ��������д������� �㲥���͵� һ���������
;; ͨ������ make-broadcast-stream ������Ŀ����, Ȼ�󴴽�һ���㲥��
;; concatenated-stream ƴ����, ��broadcast-stream�����෴, ��һ���������е����� д��һ��Ŀ����
;; ͨ�� make-concatename-stream ������������, ����Ҫ�� ƴ����

;; two-way-stream echo-stream ����������1 ������ 2 �����
;; ����һ�� �������� �������
;; echo-stream�Ķ�����Щ����,����ͬʱ ��д�뵽�����.

;; ʹ���������� ���Թ�������������ʽ�� �����˽ṹ
;; lisp��׼û�� ����API, ���Ǵ����lispʵ�ֶ�֧��socket. һ��socket��ʵ��Ϊ ������, ����ͨ�� read write �Ȳ���

;; ���� ����һ������·����������Ϊ����ֲ�Ե� ·����������.
