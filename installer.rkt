#lang racket
(require pollen/core "database.rkt" "content.rkt")
(provide installer)

(define (installer _ root)
  (define source (build-path root "src"))
  (define pollen (build-path source "pollen"))
  (define xexpr (build-path root "xexpr"))
  (define database (build-path xexpr "db.rktd"))
  (define MAKE (find-executable-path "make"))

  (cond (MAKE) (else (raise (make-exn:fail:user "Cannot find GNU make." (current-continuation-marks)))))

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

  (system* MAKE "-C" source)

  (make-directory* xexpr)
  (make-database-file database)
  (call/database/update
   database
   (lambda (db)
     (for/fold ((db db)) ((src (in-list (filter page? (directory-list pollen)))))
       (database-set db
                     (path->string (get-html src))
                     (let ((doc (get-doc (build-path pollen src))))
                       (make-record doc (page-xexpr->list doc))))))))
