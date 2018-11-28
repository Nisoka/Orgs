;; ;;;;;;;;;;;;;;;;;;;;;;;;
;; 12.1 shared structure
;;

(defun our-tailp (x y)
  (or (eql x y)                       ;or : one true is true, one true return.
      (and (consp y)                  ;and: all true is true, one false return
           (our-tailp x (cdr y)))))   ;recurasion: return stop recursion.

;; 'whole 'part share the 'part.
(setf part (list 'b 'c))
(setf whole (cons 'a part))

(tailp part whole)
(our-tailp part whole)


;; 'whole1 'whole2 part share the 'part
(setf part (list 'b 'c)
      whole1 (cons 1 part)
      whole2 (cons 2 part))

