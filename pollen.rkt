#lang racket/base
(require txexpr racket/string racket/function racket/list sugar/list)
(provide tbl lst img lnk)

(define list->lines
  (lambda (list) (filter-not null? (filter-split list (lambda (string) (and (string? string) (string=? "\n" string)))))))

(define split-line
  (lambda (line)
    (let loop ((l line) (r (list null)))
      (cond ((null? l) (reverse r))
            ((string? (car l))
             (let ((s (string-split (car l) #rx"@" #:trim? #f)))
               (cond ((null? s) (loop (cdr l) r))
                     ((= 1 (length s)) (loop (cdr l) (cons (append (car r) s) (cdr r))))
                     (else (loop (cdr l) (append (map list (reverse (cdr s))) (cons (append (car r) (list (car s))) (cdr r))))))))
            (else (loop (cdr l) (cons (append (car r) (list (car l))) (cdr r))))))))

(define tbl
  (lambda elements
    (define lines (list->lines elements))
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
    (define lines (list->lines elements))
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
    (txexpr 'img (list (list 'src (car elements))
                       (list 'width "50%")
                       (list 'alt "not supported"))
            null)))

(define lnk (lambda elements
              (txexpr 'a
                      (list (list 'href (car elements)))
                      (list (car elements)))))
