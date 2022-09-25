#lang racket/base
(require txexpr racket/string racket/function)
(provide tbl)
(define tbl
  (lambda (string)
    (define lines (string-split (string-trim string)))
    (txexpr 'table
            null
            `(,(txexpr 'caption null (list (car lines)))
              ,(txexpr 'tr null (map (curry list 'th) (cadr lines)))
              ,@(map (lambda (line)
                       (txexpr
                        'tr null
                        (map (curry list 'td) line)))
                     (cddr lines))))))