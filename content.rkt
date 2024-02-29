#lang racket
(require pollen/core)
(provide page-xexpr->list)

;; Lists
;; (-> list? (-> any/c boolean?) list?)
;; #f | #t
(define (list-trim-left-until lst pred)
  (if (null? lst) null (if (pred (car lst)) lst (list-trim-left-until (cdr lst) pred))))
;; (-> list? (-> any/c boolean?) (listof list?))
;; #f | #t
(define (list-splitf lst pred (remain null))
  (define (merge-remain-to-result remain lst)
    ((if (null? remain) values (lambda (l) (cons (reverse remain) l)))
     lst))
  (if (null? lst)
      (merge-remain-to-result remain null)
      (if (pred (car lst))
          (merge-remain-to-result
           remain
           (list-splitf (cdr lst) pred (list (car lst))))
          (list-splitf (cdr lst) pred (cons (car lst) remain)))))

;; Page
#; (root
    <elem> ...
    (@ (h2 <title>)
       <elem> ...)
    ...)
(define (page-xexpr->list xexpr)
  (match xexpr
    (`(root ,children ...)
     (define (h2? e) (and (not (string? e)) (select 'h2 e)))
     (list-splitf (list-trim-left-until children h2?) h2?))))

(module+ test
  (require rackunit)
  (check-equal? (page-xexpr->list `(root "\n" "\n" (h2 "a") "\n" (h2 "b") "\n" (a "1")))
                `(((h2 "a") "\n") ((h2 "b") "\n" (a "1")))))
