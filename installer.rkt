#lang racket
(require pollen/core "database.rkt" "content.rkt")
(provide installer)

(define (installer _ root)
  (define source (build-path root "src"))
  (define htdocs (build-path root "htdocs"))
  (define xexpr (build-path root "xexpr"))
  (define build (build-path root "build"))

  (define pollen-build (build-path build "pollen-build"))
  (define pollen (build-path source "pollen"))
  (define database (build-path xexpr "db.rktd"))
  (define images (build-path source "pollen-images"))

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
  (define (last-name p)
    (call-with-values (lambda () (split-path p)) (lambda l (last (filter values l)))))

  (delete-directory/files build #:must-exist? #f)
  (make-directory* xexpr)
  (make-parent-directory* pollen-build)
  (make-directory* pollen-build)

  (make-database-file database)
  (call/database/update
   database
   (lambda (db)
     (for/fold ((db db)) ((src (in-list (filter page? (directory-list pollen)))))
       (database-set db
                     (path->string (get-html src))
                     (page-xexpr->list (get-doc (build-path pollen src)))))))

  (for ((css-p (in-list (directory-list #:build? #f source))) #:when (regexp-match #rx"\\.css\\.p.*$" css-p))
    (call-with-output-file (build-path pollen-build (path-replace-extension css-p #""))
      #:exists 'truncate/replace
      (lambda (out) (display (get-doc (build-path source css-p)) out))))

  (map (lambda (f/d) (copy-directory/files f/d (build-path build (last-name f/d)))) (list xexpr images htdocs))

  (void))
