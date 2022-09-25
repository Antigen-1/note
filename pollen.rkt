#lang racket/base
(require txexpr racket/string racket/function racket/port racket/list)
(provide tbl lst)

(define string->lines (lambda (string) (port->list (compose string-trim read-line) (open-input-string string))))

(define tbl
  (lambda (string)
    (define lines (filter-not non-empty-string? (string->lines string)))
    (txexpr 'table
            null
            `(,(txexpr 'caption null (list (car lines)))
              ,(txexpr 'tr null (map (curry list 'th) (string-split (cadr lines) #rx"@")))
              ,@(map (lambda (line)
                       (txexpr
                        'tr null
                        (map (curry list 'td) (string-split line #rx"@"))))
                     (cddr lines))))))

(define lst
  (lambda (string)
    (define lines (filter-not non-empty-string? (string->lines string)))
    (define type (string->symbol (car lines)))
    (txexpr type
            null
            (map
             (case type
               ((ol ul) (curry list 'li))
               ((dl) (lambda (line)
                       (define e (string-split line #rx"@"))
                       (cons (list 'dt (car e)) (map (curry list 'dd) (cdr e))))))
             (cdr lines)))))