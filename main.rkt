#lang racket/base
(require (prefix-in o: string))
(provide (all-defined-out))

(define load-items
  (lambda ((directory (current-directory)) (filter-proc values))
    (parameterize ((current-directory directory))
      (for/list ((file (in-list (filter file-exists? (directory-list)))))
        (cons file (filter filter-proc (dynamic-require (list 'file (path->string file)) 0)))))))

(define match-to-filter
  (lambda (pattern #:equal? [equal? equal?])
    (define compiled (o:compile-pattern pattern #:sequence->list string->list))
    (lambda (item)
      (o:Sunday-match item compiled #:sequence->list string->list #:equal? equal?))))