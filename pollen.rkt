#lang racket/base
(require txexpr racket/string racket/function racket/match racket/list racket/contract sugar/list)
(provide
 (contract-out
  (tbl tag-function/c)
  (lst tag-function/c)
  (img tag-function/c)
  (lnk tag-function/c)))

;;Contracts
(define fragments/c
  (recursive-contract (listof (or/c string? (cons/c symbol? fragments/c)))))
(define tag-function/c (-> fragments/c txexpr?))

;;Utilities
(define fragment-list->non-empty-lines
  (lambda (list) (filter-not null? (filter-split list (lambda (string) (and (string? string) (string=? "\n" string)))))))
(define split-line
  (lambda (line)
    (define (@-string? s) (and (string? s) (string-contains? s "@")))
    (let loop ((l line) (c null) (r null))
      (cond ((null? l) (reverse (if (null? c) r (cons c r))))
            ((@-string? (car l))
             (match (string-split (car l) #rx"@" #:trim? #f)
               ((list first other ... last)
                (loop (cdr l) (list last) (foldl (lambda (e r) (cons (list e) r)) (cons (reverse (cons first c)) r) other)))))
            (else (loop (cdr l) (cons (car l) c) r))))))

(module+ test
  (require rackunit)
  (check-equal? (fragment-list->non-empty-lines (list "ab" (list "ab") "\n" (list "ab"))) (list (list "ab" (list "ab")) (list (list "ab"))))
  (check-equal? (split-line (list "a@" (list "a") "b@c")) (list (list "a") (list "" (list "a") "b") (list "c"))))

;;Tags
(define tbl
  (lambda elements
    (define lines (fragment-list->non-empty-lines elements))
    (txexpr 'table
            null
            `(,(txexpr 'caption null (car lines))
              ,(txexpr 'tr null (map (curry cons 'th) (split-line (cadr lines))))
              ,@(map (lambda (line)
                       (txexpr
                        'tr null
                        (map (curry cons 'td) (split-line line))))
                     (cddr lines))))))
(define lst
  (lambda elements
    (define lines (fragment-list->non-empty-lines elements))
    (define type (string->symbol (caar lines)))
    (txexpr type
            null
            (map
             (case type
               ((ol ul) (curry cons 'li))
               ((dl) (lambda (line)
                       (define e (split-line line))
                       (cons '@ (cons (cons 'dt (car e)) (map (curry cons 'dd) (cdr e)))))))
             (cdr lines)))))
(define img
  (lambda elements
    (txexpr 'img (list (list 'src (path->string (build-path "pollen-images" (car elements))))
                       (list 'width "50%")
                       (list 'alt "not supported"))
            null)))
(define lnk (lambda elements
              (txexpr 'a
                      (list (list 'href (car elements)))
                      (list (car elements)))))
