
(defconstant +null+ (code-char 0))


(defun read-u1 (in)
  (read-byte in))

(defun read-u2-1 (in)
  (+ (* (read-byte in) 256) (read-byte in)))

(defun read-u2 (in)
  (let ((u2 0))
    (setf (ldb (byte 8 8) u2) (read-byte in))
    (setf (ldb (byte 8 0) u2) (read-byte in))
    u2))

(defun write-u2 (out value)
  (write-byte (ldb (byte 8 8) value) out)
  (write-byte (ldb (byte 8 0) value) out))



(defun read-null-terminated-ascii (in)
  (with-output-to-string (s)
    (loop for char = (code-char (read-byte in))
       until (char= char +null+)
       do (write-char char s))))

(defun write-null-terminated-ascii (string out)
  (loop for char across string
     do (write-byte (char-code char) out))
  (write-byte (char-code +null+) out))




(defclass id3-tag ()
  ((identifier            :initarg :identifier
                          :accessor identifier)
   (major-version         :initarg :major-version
                          :accessor major-version)
   (reversion             :initarg :reversion
                          :accessor reversion)
   (flags                 :initarg :flags
                          :accessor flags)
   (size                  :initarg :size
                          :accessor size)
   (frames                :initarg :frames
                          :accessor frames)))



(defun read-id3-tag (in)
  (let ((tag (make-instance 'id3-tag)))
    (with-slots (identifier major-version reversion flags size frames) tag
      (setf identifier (read-iso-8859-1-string in :length 3))
      (setf major-version (read-u1 in))
      (setf reversion (read-u1 in))
      (setf flags (read-u1 in))
      (setf size (read-id3-encoded-size in))
      (setf frames (read-id3-frames :tag-size size)))
    tag))



(define-binary-class id3-tag
    ((file-identifiler (iso-8859-1-string :length 3))
     (major-version    u1)
     (reversion        u1)
     (flags            u1)
     (size             id3-tag-size)
     (frames           (id3-frames :tag-size size))))


