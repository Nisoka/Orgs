(defun palindrome? (x)
  (let ((mid (/ (length x) 2)))
    (equal (subseq x 0 (floor mid))
           (reverse (subseq x (ceiling mid))))))

(defun our-truncate (n)
  (if (> n 0)
      (floor n)
      (ceiling n)))

