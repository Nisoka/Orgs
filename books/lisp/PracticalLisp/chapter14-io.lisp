
;; lisp 提供了一套 基本的 处理文件的函数库
;; lisp 和其他语言一样 为读写数据 提供一个 流对象 和 一个成为路径名的 抽象对象。
;; 这样提供了一种 与 操作系统 无关的管理操作文件的处理方式.
;; lisp 还提供了 独特的读写 S-表达式的操作.

;; 14.1 读写文件数据
;; open close  read-char read-line  read(直接读取一个S-表达式 构建一个lisp对象)

;; read 函数 是lisp独有的 就是repl循环中读取。
;; print 以可读形式打印lisp对象. 就是repl 中的打印.
;; R E P L    读取 求值 打印 循环.

(defun test-io ()
  (let ((in (open "./name.txt" :if-does-not-exist nil)))
    (when in
      (loop for line = (read-line in nil)
           while line do (format t "~a~%" line))
      (close in))))


;; S-表达式 的设计 可以很好的作为配置文件等事务的良好格式




;; 14.2 读取二进制数据
;; open时 使用 :element-type '(unsigned-byte 8) 读取二进制数据流
;; 然后使用 READ-BYTE 读取二进制数据。
;; 以后 通过READ-BYTE  便利的读取结构化的二进制数据

;; 
