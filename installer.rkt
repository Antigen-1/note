#lang hasket
(require racket/file racket/path pollen/core)
(provide installer)

(define (installer _ root)
  (define source (build-path root "pollen"))
  (define xexpr (build-path root "xexpr"))

  (define indexes (list "index.html.pm"
                        "影响学.html.pm"
                        "英语.html.pm"
                        "外科学.html.pm"
                        "诊断学.html.pm"
                        "内科学.html.pm"
                        "传染病学.html.pm"
                        "药理学.html.pm"))

  (define (page? p)
    (and (path-has-extension? p #".html.pm")
         (not (findf (lambda (i) (string=? i (path->string p))) indexes))))

  (make-directory* xexpr)
  (for ((src (in-list (filter page? (directory-list source)))))
    (write-to-file (get-doc (build-path source src)) (build-path xexpr (path-replace-extension src #".xexpr")))))
