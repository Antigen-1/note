#lang racket
(require hasket
         web-server/formlets web-server/servlet web-server/servlet-env
         racket/runtime-path racket/case
         (for-syntax racket racket/syntax))
(provide main)

(define-runtime-path xexpr "xexpr")

(define pages (directory-list xexpr))

;; Response
(define (render-page bodies)
  (response/xexpr
   #:preamble #"<!DOCTYPE html>"
   `(html (head (meta ((charset "UTF-8"))))
          (body ,@bodies))))
(define (make-html-list ls) `(ul ,@(map (lambda (e) `(li ,e)) ls)))
(define (make-html-link-content-pair link name content)
  `(div (a ((href ,link)) ,name)
        ,content))

;; Predicates
;; (-> pregexp? string? (or/c #f string?))
(define include?
  (lambda/curry/match
   ((pattern content)
    (and (regexp-match pattern content) content))))
(define xexpr-include?
  (lambda/curry/match
   ((pattern content)
    (match content
      ((? string? str) (include? pattern str))
      (`(,(? symbol? _) ((,_ ,_) ...) ,@elements) (ormap (lambda (e) (xexpr-include? pattern e)) elements))
      (`(,(? symbol? _) ,@elements) (ormap (lambda (e) (xexpr-include? pattern e)) elements))
      (_ #f)))))

;; Paths
(define (get-html filename)
  (path-replace-extension filename #""))

;; Patterns
(define (pregexp/handler exp cc)
  (pregexp exp
           (cc
            .
            (lambda (s)
              (render-page
               `((h1 "Illegal Regular Expression")
                 (p ,s)
                 (a ((href "https://docs.racket-lang.org/reference/regexp.html"))
                    "Racket Reference")))))))

;; Formlets
(define text-info-form
  (formlet (#%# (p ,(input-symbol . => . type))
                (p ,(input-string . => . pattern)))
           (list type pattern)))
(define (make-form handler embed/url)
  `(form ((action ,(embed/url handler)))
         ,@(formlet-display text-info-form)
         (input ((type "submit")))))

;; Handlers and renders
(define (start req)
  (main-renderer req))
(define (main-renderer req)
  (define (response-generator embed/url)
    (render-page
     `((h1 "Hi, there!")
       ,(make-form search-handler embed/url))))

  ;; (-> path-string? (-> request? any))
  (define ((make-display-doc-handler name) _)
    (send/suspend/dispatch
     (lambda (embed/url)
       (render-page
        `(,(make-form search-handler embed/url)
          ,(file->value (build-path xexpr name)))))))
  ;; (-> any path? string? any)
  (define (make-search-result embed/url name content)
    (make-html-link-content-pair
     (embed/url (make-display-doc-handler name))
     (path->string (get-html name))
     content))

  (define (search-handler req)
    (send/suspend/dispatch
     (lambda (embed/url)
       (let/cc cc
         (match-define (list type pattern) (formlet-process text-info-form req))
         (let ((cpattern (pregexp/handler pattern cc)))
           (case/eq
            type
            ((content CONTENT)
             (render-page
              `((h1 "Search Results")
                ,(make-form search-handler embed/url)
                ,(make-html-list
                  (filter-map
                   (lambda (p)
                     (let ((result
                            (xexpr-include? cpattern (file->value (build-path xexpr p)))))
                       (if result
                           (make-search-result embed/url p result)
                           #f)))
                   pages)))))
            ((name NAME)
             (render-page
              `((h1 "Search Results")
                ,(make-form search-handler embed/url)
                ,(make-html-list
                  (filter-map
                   (lambda (p)
                     (let ((result (include? cpattern p)))
                       (if result
                           (make-search-result embed/url p (path->string result))
                           #f)))
                   pages)))))
            (else (render-page
                   `((h1 "Illegal Searching Type")
                     ,(make-form search-handler embed/url)
                     (p ,(format "~a is provided" type))
                     (p "Only content, CONTENT, name or NAME is allowed!"))))))))))

  (send/suspend/dispatch response-generator))

;; Main
(define connection-close? (vector #f "Every connection is closed after one request."))
(define launch-browser? (vector #f "A web browser is opened to \"http://localhost:<port><servlet-path>\"."))
(define quit? (vector #f "The URL \"/quit\" ends the server."))
(define banner? (vector #f "An informative banner is printed."))
(define listen-ip (vector #f "The server listens on listen-ip."))
(define/contract port
  (vector/c exact-nonnegative-integer? any/c)
  (vector 6789 "The server listens on port."))
(define ssl? (vector #f "Enable SSL."))
(define-syntax (parse-command-line-arguments stx)
  (define (maybe-strip sym)
    (if (switch? sym)
        (let ((str (symbol->string sym))) (string->symbol (substring str 0 (sub1 (string-length str)))))
        sym))
  (define (switch? sym)
    (string-suffix? (symbol->string sym) "?"))
  (syntax-case stx ()
    ((_ box-name ...)
     #`(command-line
        #:once-each
        #,@(map
            (lambda (n b)
              (define vars (if (switch? n) null (list (generate-temporary n))))
              (define vals (if (switch? n) (list #t) vars))
              `(,(string-append "--" (symbol->string (maybe-strip n)))
                ,@vars
                ((vector-ref ,b 1))
                (vector-set! ,b 0 ,@vals)))
            (syntax->datum #'(box-name ...))
            (syntax->list #'(box-name ...)))))))
(define-syntax (serve stx)
  (syntax-case stx ()
    ((_ start ((kw val) ...) box-name ...)
     #`(let* ((original (list (cons 'kw val) ...))
              (generated (list #,@(map (lambda (b n)
                                         `(cons ',(string->keyword (symbol->string n)) (vector-ref ,b 0)))
                                       (syntax->list #'(box-name ...))
                                       (syntax->datum #'(box-name ...)))))
              (sorted (sort (append original generated) keyword<? #:key car)))
         (keyword-apply
          serve/servlet
          (map car sorted)
          (map cdr sorted)
          start
          null)))))

(parse-command-line-arguments
 connection-close?
 launch-browser?
 quit?
 banner?
 listen-ip
 port
 ssl?
 )
(serve start
       ()
       connection-close?
       launch-browser?
       quit?
       banner?
       listen-ip
       port
       ssl?
       )
