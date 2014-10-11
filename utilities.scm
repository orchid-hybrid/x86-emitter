(define first car)
(define second cadr)
(define third caddr)

(define (all p l)
  (if (null? l)
      #t
      (if (p (car l))
          (all p (cdr l))
          #f)))

(define (any p l)
  (if (null? l)
      #f
      (if (p (car l))
          #t
          (any p (cdr l)))))

(define (filter p l)
  (if (null? l)
      '()
      (if (p (car l))
          (cons (car l) (filter p (cdr l)))
          (filter p (cdr l)))))

(define (for-each/separated each sep list)
  (cond ((null? list) #f)
        ((null? (cdr list)) (each (car list)))
        (else
         (each (car list))
         (sep)
         (for-each/separated each sep (cdr list)))))
