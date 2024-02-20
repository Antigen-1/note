#lang hasket
(require racket/file racket/path pollen/core)
(provide installer)

(define (installer _ root)
  (define source (build-path root "pollen"))
  (define xexpr (build-path root "xexpr"))

  (define (page? p)
    (path-has-extension? p #".html.pm"))

  (make-directory* xexpr)
  (for ((src (in-list (filter page? (directory-list source)))))
    (write-to-file (get-doc (build-path source src)) (build-path xexpr (path-replace-extension src #".xexpr")))))
