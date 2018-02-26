
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

;; 14.3 批量读取
;; read-sequence 序列读取, 比重复读取read-byte read-char 来填充一个序列搞笑

;; 14.4 文件输出
;; print pprint  write-char write-line write-string terpri fresh-line 
;; 需要指定open方向 :direction :output

;; 14.5 关闭文件
;; close
;; 一个文件的标准使用习惯 代码模板
(let ((stream (open "/some/some.file")))
  ;; do stuffs with steam
  (close stream))

;; 确保必须运行一个特定代码块(就例如 关闭文件代码, 必须被运行)
;; 使用 UNWIND-PROTECT
;; 构建在 UNWIND-PROTECT 之上的宏 WITH-OPEN-FILE 封装了上面的结构
(WITH-OPEN-FILE (stream "some.file")
  ;; do stuffs with stream )
  )
;; WITH-OPEN-FILE 会确保stream 流在 WITH-OPEN-FILE 返回之前被关闭.

(WITH-OPEN-FILE (stream "/some/some.file" :direction :output)
  (format stream "Some text."))

;; 几乎99%的文件IO操作都会用到 WITH-OPEN-FILE
;; 需要使用最原始的 OPEN CLOSE 的情况是
;; 1 你不会使用 WITH-OPEN-FILE
;; 2 确实需要不关闭这个流 eg 标准的cin cout 会一致保持 , 知道程序结束 你在close.

;; 14.6 文件名
;; 文件路径 正常都会不具有系统移植性
;; lisp 提供了可移植路径名方案.
;; 本地系统的路径字符串 与 lisp实现文件路径 的转化工作可以通过lisp完成.
;; 用户知道具体系统中的文件路径, 所以提供的是文件路径字符串. 传递给lisp处理得到 lisp路径.
;; 系统相关文件名字符串 lisp路径对象 lisp文件流 总称为路径名描述符 pathname designer
;;

;; 14.7 路径名 如何表示文件名
;; 路径名: 主机host , 设备device , 目录directory , 名称name , 类型type , 版本version。
;; 将 文件名字符串 直接解析为一个 路径名对象.
;; eg PATHNAME 接受一个路径名描述符(文件名字符串/lisp路径对象/lisp文件流)

(pathname-directory (pathname "/foo/bar/baz.txt"))
(pathname-name (pathname "/foo/bar/baz.txt"))
(pathname-type (pathname "/foo/bar/baz.txt"))

;; 路径名 也是一个 内置数据类型 路径名对象的 S-表达式为-- #p""
;; 允许打印并读取回含有路径名对象的 S-表达式
;; 
(pathname "/foo/bar/baz.txt")

;; NAMESTRING 可以将一个路径名对象 转化为 文件名字符串

;; 14.8 构造新路径名
;; make-pathname 构建一个路径名对象
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
;; 可以合并两个路径.

;; *default-pathname-defaults* 是一个默认LISP目录.
;; 当一个lisp 路径名对象 确实一些组件时, 在该对象被open打开使用时, 就会利用 *default-pathname-defaults*中的组件填充


;; 14.9 目录名的两种表示方法
;; linux windows 都将目录为一种特殊类型的文件
;; 所以 目录名字符串中的最后名字元素 可以放入 路径名对象中的名称组件 或者 保存在目录组件中, 两种表示都可以。


;; 14.10 与文件系统交互
(probe-file "name.txt")
(directory ".")
;; delete-file rename-file       ;; 成功时 返回真, 否则产生一个 file-error 报错
;; rename-file 接受两个路径名描述符, 重命名1参数 为2参数
;; ensure-directories-exist 来创建目录, 返回被传递的路径名.
;; file-write-date 返回文件上次写入时间
;; file-author 文件拥有者
;;
;; 接受流为参数
;; file-length --------- 其他函数都接受路径名作为参数, 而此函数只接受一个流。
;; 因此使用 file-length 必须连同一个 open
;; file-postion 也就收流作为输入参数, 返回当前流文件中的当前位置---- 已经写入或读取该流的数量
;; 当以 流和位置描述符-p 调用file-postion 时, 将流的当前位置设置为 位置描述符-p.
;; 位置描述符 1 :start 2 :end 3 非负整数
;;


;; 14.11 其他的IO类型
;; 流 除了 文件流 外, lisp还支持其他类型的流. 他们可以用于各种 都读 写 打印当IO函数
;; eg
;; string-stream 从一个字符串读写数据
;;        make-string-input-stream make-string-output-stream 来创建string-stream
;; make-string-input-stream 接受要给字符串对象 以及一个可选的开始结束指示符来鉴定字符串中数据应该读写的区域
;;    返回一个可被传递到任何READ-CHAR READ-LINE READ 这样基于 字符----char 的输入函数的字符流。

(defun fstring-to-float (fString)
  (let ((s (make-string-input-stream fString)))
    (UNWIND-PROTECT (read s)
      (close s))))

;; make-string-output-stream 创建一个流 可以被 format print write-char write-line 等将数据输出到流
;; with-input-from-string 和 with-open-file 相似
(with-input-from-string (s "1.23")
  (READ s))

;; 还有其他一些特殊流
;; broadcast-stream 广播流. 它将向其写入的数据 广播发送到 一组输出流中
;; 通过利用 make-broadcast-stream 传入多个目标流, 然后创建一个广播流
;; concatenated-stream 拼接流, 与broadcast-stream总用相反, 将一组输入流中的数据 写入一个目标流
;; 通过 make-concatename-stream 传入多个输入流, 创建要给 拼接流

;; two-way-stream echo-stream 接受两个流1 输入流 2 输出流
;; 返回一个 可以输入 输出的流
;; echo-stream的读入有些特殊,读入同时 会写入到输出流.

;; 使用这五种流 可以构造出任意情况形式的 流拓扑结构
;; lisp标准没有 网络API, 但是大多数lisp实现都支持socket. 一般socket都实现为 网络流, 可以通过 read write 等操作

;; 下面 构建一个基本路径名函数行为可移植性的 路径名函数库.
