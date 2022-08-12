#lang racket/base
(provide read read-syntax)

(define read
  (lambda ([in (current-input-port)])
    (regexp-match* #px"(\\S+)\n\n" in #:match-select (compose bytes->string/utf-8 cadr))))
(define read-syntax
  (lambda ([src #f] [in (current-input-port)])
    (datum->syntax #f (read in) #f)))