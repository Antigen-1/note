#lang racket/base
(provide read read-syntax)

(define read
  (lambda ([in (current-input-port)])
    (regexp-match* #rx"(.+)\n\n" in #:match-select cadr)))
(define read-syntax
  (lambda ([src #f] [in (current-input-port)])
    (datum->syntax #f (read in) #f)))