#lang racket
(require pollen/core "database.rkt")
(provide installer)

(define (installer _ root)
  (define source (build-path root "src" "pollen"))
  (define xexpr (build-path root "xexpr"))
  (define database (build-path xexpr "db.rktd"))

  (define indexes (list "影像学.html.pm"
                        "英语.html.pm"
                        "外科学.html.pm"
                        "诊断学.html.pm"
                        "内科学.html.pm"
                        "传染病学.html.pm"
                        "药理学.html.pm"))

  (define (page? p)
    (and (or (path-has-extension? p #".html.pm") (path-has-extension? p #".html.pmd"))
         (not (findf (lambda (i) (string=? i (path->string p))) indexes))))
  (define (get-html p) (path-replace-extension p #""))

  (make-directory* xexpr)
  (make-database-file database)
  (call/database/update
   database
   (lambda (db)
     (for/fold ((db db)) ((src (in-list (filter page? (directory-list source)))))
       (database-set db (path->string (get-html src)) (get-doc (build-path source src)))))))
