;; 15.1 api
;; 1 ��ȡĿ¼�е��ļ��б�
;; 2 ���������ֵ��ļ���Ŀ¼�Ƿ����
;; 3 �ݹ����Ŀ¼���
;; 4 ��Ŀ¼����ÿ��·�����ϵ��ø����ĺ���
;; ʵ���� ��Щ�����Ĺ��� �Ѿ���directory probe-file ʵ����.
;; ���ǻ�����಻ͬ�ķ�ʽ��ʵ����Щ����, ���������Ա�׼����Ч����
;; ���ϣ����дһ���µĺ���, �ڲ�ͬʵ���ṩһ�µ���Ϊ

;; 15.2 *features* �� ��ȡ��������
;; *features* ȫ�ֱ��� ������ һ������ ��ǰ�ײ�ƽ̨/lispʵ�ֵ� ��ֲ����صķ����б�
;; lisp ��ȡ�� ������
;; lisp ��ȡ�� ����*features* �����Լ� lispԭ��Ϊ��ʵ�ֿ���ֲ �ṩ�ĸ����﷨ #+ #- ʵ��
;; ���Ա��ʽ  ���� --- ������*features*�е�һЩ�����ײ�ʵ����صĹؼ���
;; ���� ���������� �ڶ�ȡ�ھ�ʵ�ֲ�ͬ���, ��˱��������޷������������ı��ʽ.
;; ����ζ�Ų�ͬ���������汾 ������˶��������κζ�������.


;; CL-USER> *features*
;; (:SWANK :64-BIT :64-BIT-REGISTERS :ALIEN-CALLBACKS :ANSI-CL :ASH-RIGHT-VOPS
;;  :C-STACK-IS-CONTROL-STACK :COMMON-LISP :COMPARE-AND-SWAP-VOPS
;;  :COMPLEX-FLOAT-VOPS :CYCLE-COUNTER :FLOAT-EQL-VOPS :FP-AND-PC-STANDARD-SAVE
;;  :GENCGC :IEEE-FLOATING-POINT :INLINE-CONSTANTS :INTEGER-EQL-VOP :LINKAGE-TABLE
;;  :LITTLE-ENDIAN :MEMORY-BARRIER-VOPS :MULTIPLY-HIGH-VOPS :OS-PROVIDES-DLOPEN
;;  :OS-PROVIDES-PUTWC :PACKAGE-LOCAL-NICKNAMES :PRECISE-ARG-COUNT-ERROR
;;  :RAW-INSTANCE-INIT-VOPS :RAW-SIGNED-WORD :SB-DOC :SB-DYNAMIC-CORE :SB-EVAL
;;  :SB-FUTEX :SB-LDB :SB-PACKAGE-LOCKS :SB-QSHOW :SB-SAFEPOINT
;;  :SB-SAFEPOINT-STRICTLY :SB-SIMD-PACK :SB-SOURCE-LOCATIONS :SB-THREAD
;;  :SB-THRUPTION :SB-UNICODE :SB-WTIMER :SBCL :STACK-ALLOCATABLE-CLOSURES
;;  :STACK-ALLOCATABLE-FIXED-OBJECTS :STACK-ALLOCATABLE-LISTS
;;  :STACK-ALLOCATABLE-VECTORS :STACK-GROWS-DOWNWARD-NOT-UPWARD :SYMBOL-INFO-VOPS
;;  :UNBIND-N-VOP :UNDEFINED-FUN-RESTARTS :UNWIND-TO-FRAME-AND-CALL-VOP :WIN32
;;  :X86-64)

(defun test-features ()
  #+sbcl (print "This is a sbcl ")
  #-(or sbcl nil) (print "false"))



;; �Կ���
;; 
