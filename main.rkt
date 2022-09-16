#lang racket/base
(require string sugar/file racket/port racket/function)
(provide (all-defined-out))

(define search
  (lambda (pattern (directory (current-directory)))
    (define compiled (compile-pattern pattern #:sequence->list string->list))
    (define check (lambda (port) (Sunday-match port compiled #:sequence->list (curry port->list read-char))))
    (parameterize ((current-directory directory))
      (filter (lambda (path) (and (has-ext? path "nt") (call-with-input-file path (lambda (in) (check in))))) (directory-list)))))