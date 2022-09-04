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

(define compare-to-filter0
  (lambda (pattern #:char=? [char=? char=?])
    (define min-len (/ (length (regexp-match* #px"\\S" pattern)) 2))
    (lambda (item)
      (define res (o:get-longest-common-substring pattern item #:substring substring #:string->list string->list #:elem=? char=?))
      (>= (apply max (map (lambda (r) (length (regexp-match* #px"\\S" r))) res)) min-len))))

(define compare-to-filter1
  (lambda (pattern #:char=? [char=? char=?])
    (define len (string-length pattern))
    (lambda (item)
      (= (o:longest-common-subsequence-length pattern item #:sequence->list string->list #:elem=? char=?)
         len))))