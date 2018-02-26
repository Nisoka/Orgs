;; 15.1 api
;; 1 获取目录中的文件列表
;; 2 检测给定名字的文件或目录是否存在
;; 3 递归遍历目录层次
;; 4 在目录树的每个路径名上调用给定的函数
;; 实际上 这些函数的功能 已经由directory probe-file 实现了.
;; 但是会有许多不同的方式来实现这些函数, 都属于语言标准的有效解释
;; 因此希望编写一套新的函数, 在不同实现提供一致的行为

;; 15.2 *features* 和 读取期条件话
;; *features* 全局变量 包含了 一个代表 当前底层平台/lisp实现等 移植性相关的符号列表
;; lisp 读取器 编译器
;; lisp 读取器 利用*features* 变量以及 lisp原生为了实现可移植 提供的附加语法 #+ #- 实现
;; 特性表达式  特性 --- 存在与*features*中的一些描述底层实现相关的关键字
;; 这样 允许条件化 在读取期就实现不同情况, 因此编译器都无法看到被跳过的表达式.
;; 这意味着不同的条件化版本 不会因此而带来人任何额外消耗.


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



;; 对库打包
;; 
