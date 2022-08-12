#lang racket/base
(require (prefix-in o: string))
(provide load-items compile-pattern match-to-filter)

(define load-items
  (lambda ((directory (current-directory)) (filter-proc (lambda (item) #t)))
    (parameterize ((current-directory directory))
      (for/list ((file (in-list (filter file-exists? (directory-list)))))
        (cons file (filter filter-proc (dynamic-require (list 'file (path->string file)) 0)))))))

(define compile-pattern
  (lambda (pattern)
    (o:compile-pattern pattern #:sequence->list string->list)))

(define match-to-filter
  (lambda (compiled #:equal? [equal? equal?])
    (lambda (item)
      (o:Sunday-match item compiled #:sequence->list string->list #:equal? equal?))))