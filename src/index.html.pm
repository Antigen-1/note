#lang pollen/markup
◊h1{索引}

◊(require racket/path)
◊(define (make-html-list . items) `(ul ,@(map (lambda (i) `(li ,i)) items)))
◊(define (make-page-link rel) `(a ((href ,rel)) ,(path->string (file-name-from-path rel))))

◊make-html-list{
◊make-page-link{pollen/影像学.html}
◊make-page-link{pollen/英语.html}
◊make-page-link{pollen/外科学.html}
◊make-page-link{pollen/诊断学.html}
◊make-page-link{pollen/内科学.html}
◊make-page-link{pollen/传染病学.html}
◊make-page-link{pollen/药理学.html}
}
