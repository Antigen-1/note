#lang racket/base
(provide read read-syntax)

(define read
  (lambda ([in (current-input-port)])
    (cond ((regexp-match* #px"(\\S+)\n\n" in #:match-select (compose bytes->string/utf-8 cadr))) (else null))))
(define read-syntax
  (lambda ([src #f] [in (current-input-port)])
    (datum->syntax #f (read in) #f)))