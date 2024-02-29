#lang racket
(require hasket
         web-server/formlets web-server/servlet web-server/servlet-env
         racket/runtime-path racket/case
         "database.rkt"
         (for-syntax racket racket/syntax))

(define-runtime-path root ".")

(define database (build-path root "xexpr" "db.rktd"))
(define source (build-path root "src"))

(define data (read-database database))
(define names (database-names data))

(define servlet-path "/servlets/note")

;; Response
(define (render-page bodies)
  (response/xexpr
   #:preamble #"<!DOCTYPE html>"
   `(html (head (meta ((charset "UTF-8")))
                (link ((href "../pollen-build/styles.css") (rel "stylesheet") (type "text/css")))
                (link ((href "../htdocs/styles.css") (rel "stylesheet") (type "text/css")))
                )
          (body ,@bodies))))
(define (make-html-list ls) `(ul ,@(map (lambda (e) `(li ,e)) ls)))
(define (make-html-link link name)
  `(a ((href ,link)) ,name))
(define (make-html-link-content-pair link name content)
  `(div ,(make-html-link link name)
        ,content))

;; Predicates
;; (-> pregexp? string? (or/c #f string?))
(define include?
  (lambda/curry/match
   ((pattern content)
    (and (regexp-match pattern content) content))))
;; (-> pregexp? xexpr? (listof string?))
(define xexpr-include?
  (lambda/curry/match
   ((pattern content)
    (match content
      ((? string? str) (cond ((include? pattern str) => list) (else null)))
      (`(,(? symbol? _) ((,_ ,_) ...) ,@elements)
       (bindM elements (xexpr-include? pattern)))
      (`(,(? symbol? _) ,@elements)
       (bindM elements (xexpr-include? pattern)))
      (_ null)))))

;; Formlets
(define type-info-form
  (formlet (div
            (label ((for "Type")) "Enter the type: ")
            ,(input-symbol . => . type))
           type))
(define pattern-info-form
  (formlet (div
            (label ((for "Pattern")) "Enter the pregexp pattern: ")
            ,(input-string . => . pattern))
           pattern))
(define all-info-form
  (formlet (#%# ,(type-info-form . => . type)
                ,(pattern-info-form . => . pattern))
           (list type pattern)))
(define (make-form handler embed/url)
  `(form ((action ,(embed/url handler)))
         ,@(formlet-display all-info-form)
         (input ((type "submit") (value "submit")))))

;; Handlers and renders
(define (start req)
  (define (response-generator embed/url)
    (render-page
     `((h1 "Hi, there!")
       (h2 "All pages are listed as follows.")
       ,(make-html-list (map (lambda (nm) (make-html-link (embed/url (make-display-doc-handler nm)) nm)) names))
       (h2 "You can input a type and a pregexp pattern here.")
       ,(make-form search-handler embed/url))))

  ;; Create links to display pages
  ;; (-> string? (-> request? any))
  (define ((make-display-doc-handler name) _)
    (send/suspend/dispatch
     (lambda (embed/url)
       (render-page
        `(,(record-doc (database-ref data name)) ;; This returns a single node
          ,(make-form search-handler embed/url))))))
  ;; (-> any/c string? xexpr? any)
  (define (make-search-result embed/url name content)
    (make-html-link-content-pair
     (embed/url (make-display-doc-handler name))
     name
     content))

  ;; Create links to display pieces of those pages
  ;; Pages are splitted in installer.rkt, with page-xexpr->list in content.rkt
  ;; (-> string? exact-nonnegative-integer? (-> request? any))
  (define ((make-display-piece-handler name index) _)
    (send/suspend/dispatch
     (lambda (embed/url)
       (render-page
        `(,@(list-ref (record-pieces (database-ref data name)) index) ;; This returns a list of nodes
          ,(make-form search-handler embed/url))))))
  ;; (-> any/c string? exact-nonnegative-integer? xexpr? any)
  (define (make-search-result/pieces embed/url name index content)
    (make-html-link-content-pair
     (embed/url (make-display-piece-handler name index))
     (format "~a" (add1 index))
     content))

  (define (pregexp/handler exp cc embed/url)
    (pregexp exp
             (cc
              .
              (lambda (s)
                (render-page
                 `((h1 "Illegal Perl-style Regular Expression")
                   (p ,s)
                   (a ((href "https://docs.racket-lang.org/reference/regexp.html"))
                      "Racket Reference")
                   ,(make-form search-handler embed/url)))))))
  (define (search-handler req)
    (send/suspend/dispatch
     (lambda (embed/url)
       (let/cc cc
         (match-define (list type pattern) (formlet-process all-info-form req))
         (let ((cpattern (pregexp/handler pattern cc embed/url)))
           (case/eq
            type
            ((content CONTENT)
             (render-page
              `((h1 "Search Results")
                ;; List all files that match
                ,(make-html-list
                  (filter-map
                   (lambda (p)
                     (let* ((pieces (record-pieces (database-ref data p)))
                            (results
                             (filter-map
                              (lambda (i pc)
                                (define rs (bindM pc (xexpr-include? cpattern)))
                                (cond ((null? rs) #f) (else (cons i rs))))
                              (range 0 (length pieces))
                              pieces)))
                       (if (not (null? results))
                           (make-search-result
                            embed/url
                            p
                            ;; List all pieces that match in a file
                            (make-html-list
                             ;; List all strings that match in one piece
                             (map (lambda/curry/match ((`(,i . ,c)) (make-search-result/pieces embed/url p i (make-html-list c)))) results)))
                           #f)))
                   names))
                ,(make-form search-handler embed/url))))
            ((name NAME)
             (render-page
              `((h1 "Search Results")
                ,(make-html-list
                  (filter-map
                   (lambda (p)
                     (let ((result (include? cpattern p)))
                       (if result
                           `(a ((href ,(embed/url (make-display-doc-handler p))))
                               ,p)
                           #f)))
                   names))
                ,(make-form search-handler embed/url))))
            (else (render-page
                   `((h1 "Illegal Searching Type")
                     (p ,(format "~a is provided." type))
                     (p "Only content, CONTENT, name or NAME is allowed!")
                     ,(make-form search-handler embed/url))))))))))

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
(define ssl-cert (vector #f "The server uses this certificate."))
(define ssl-key (vector #f "The server uses this private key."))
(define-syntax (parse-command-line-arguments stx)
  (define (maybe-strip sym)
    (if (switch? sym)
        (let ((str (symbol->string sym))) (string->symbol (substring str 0 (sub1 (string-length str)))))
        sym))
  (define (switch? sym)
    (string-suffix? (symbol->string sym) "?"))
  (syntax-case stx ()
    ((_ (raw ...) box-name ...)
     #`(command-line
        #:once-each
        raw ...
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
 ()
 connection-close?
 launch-browser?
 quit?
 banner?
 listen-ip
 port
 ssl?
 ssl-cert
 ssl-key
 )
(serve
 start
 ((#:extra-files-paths (list root source))
  (#:servlet-path servlet-path))
 connection-close?
 launch-browser?
 quit?
 banner?
 listen-ip
 port
 ssl?
 ssl-cert
 ssl-key
 )
