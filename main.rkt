#lang racket
(require hasket
         web-server/formlets web-server/servlet web-server/servlet-env
         racket/runtime-path
         "database.rkt"
         (for-syntax racket racket/syntax))

(define-runtime-path build "build")

(define database (build-path build "xexpr" "db.rktd"))

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
(define (make-html-transfer-link link name #:id id)
  `(i ((id ,id)) ,(make-html-link link name)))
(define (make-html-id (orig 'id))
  (symbol->string (gensym orig)))

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
(define (make-type-info-form form-id)
  (define select-id (make-html-id 'type))
  (formlet
   (div
    (label ((for ,select-id)) "Select a type: ")
    ,((select-input (list "name" "content") #:attributes (list (list 'form form-id) (list 'id select-id))) . => . type))
   (string->symbol type)))
(define (make-pattern-info-form)
  (define id (make-html-id 'pattern))
  (formlet (div
            (label ((for ,id)) "Enter the pregexp pattern: ")
            ,((to-string (required (text-input #:attributes (list (list 'id id))))) . => . pattern))
           pattern))
(define (make-all-info-form)
  (define form-id (make-html-id 'form))
  (values
   form-id
   (formlet (#%# ,((make-type-info-form form-id) . => . type)
                 ,((make-pattern-info-form) . => . pattern)
                 ,((submit "Run") . => . submit))
            (list type pattern))))
(define make-form
  (lambda/curry/match
   ((form-id form make-handler embed/url)
    `(fieldset
      (legend "Search")
      (form ((action ,(embed/url (make-handler form)))
             (id ,form-id))
            ,@(formlet-display form))))))

;; Handlers and renders
(define (start req)
  (define (response-generator embed/url)
    (render-page
     `((h1 "Hi, there!")
       (h2 "Index")
       ,(make-html-list (map (lambda (nm) (make-html-link (embed/url (make-display-doc-handler (database-ref data nm))) nm)) names))
       ;; The return-to-index link is unnecessary here
       ,((call-with-values make-all-info-form make-form) make-search-handler embed/url))))

  ;; Create links to display pages
  ;; (-> (listof (listof xexpr?)) any/c (listof xexpr?))
  (define (make-doc pieces embed/url)
    (if (null? pieces)
        '((h1 "There's no content in this file."))
        (let loop ((last #f) (current (car pieces)) (rest (cdr pieces)))
          ;; Every time a page is linked a new url is created
          (define (make-prev)
            (if last
                (list
                 (make-html-transfer-link
                  (embed/url (make-display-piece-handler last))
                  "Prev"
                  #:id "prev-top"))
                null))
          (define (make)
            `((p
               ,@(make-prev)
               ,@(if (null? rest)
                     null
                     (list
                      (make-html-transfer-link
                       (embed/url
                        ;; Delayed
                        (lambda (req)
                          ((make-display-piece-handler (loop (make) (car rest) (cdr rest))) req)))
                       "Next"
                       #:id "next-top"))))
              ,@current))
          (make))))
  ;; (-> (listof (listof xexpr?)) (-> request? any))
  (define ((make-display-doc-handler pieces) _)
    (send/suspend/dispatch
     (lambda (embed/url)
       (render-page/suffix
        embed/url
        (make-doc pieces embed/url)))))
  ;; (-> any/c string? xexpr? any)
  (define (make-search-result embed/url name content)
    (make-html-link-content-pair
     (embed/url (make-display-doc-handler (database-ref data name)))
     name
     content))

  ;; Create links to display pieces of those pages
  ;; Pages are splitted in installer.rkt, with page-xexpr->list in content.rkt
  ;; (-> (listof xexpr?) (-> request? any))
  (define ((make-display-piece-handler piece) _)
    (send/suspend/dispatch
     (lambda (embed/url)
       (render-page/suffix embed/url piece))))
  ;; (-> any/c string? exact-nonnegative-integer? xexpr? any)
  (define (make-search-result/pieces embed/url name index content)
    (make-html-link-content-pair
     (embed/url (make-display-piece-handler (list-ref (database-ref data name) index)))
     (format "~a" (add1 index))
     content))

  (define (pregexp/handler exp cc embed/url)
    (pregexp exp
             (cc
              .
              (lambda (s)
                (render-page/suffix
                 embed/url
                 `((h1 "Illegal Perl-style Regular Expression")
                   (p ,s)
                   (a ((href "https://docs.racket-lang.org/reference/regexp.html"))
                      "Racket Reference")
                   ))))))
  (define ((make-search-handler all-info-form) req)
    (send/suspend/dispatch
     (lambda (embed/url)
       (let/cc cc
         (match-define (list type pattern) (formlet-process all-info-form req))
         (let ((cpattern (pregexp/handler pattern cc embed/url)))
           (cond
            ((eq? type 'content)
             (render-page/suffix
              embed/url
              `((h1 "Search Results")
                ;; List all files that match
                ,(make-html-list
                  (filter-map
                   (lambda (p)
                     (let* ((pieces (database-ref data p))
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
                )))
            ((eq? type 'name)
             (render-page/suffix
              embed/url
              `((h1 "Search Results")
                ,(make-html-list
                  (filter-map
                   (lambda (p)
                     (let ((result (include? cpattern p)))
                       (if result
                           `(a ((href ,(embed/url (make-display-doc-handler (database-ref data p)))))
                               ,p)
                           #f)))
                   names))
                )))))))))

  (define (return-to-index-handler embed/url)
    (start (redirect/get)))

  (define (add-common-suffix embed/url nodes)
    `(,@nodes
      ,((call-with-values make-all-info-form make-form) make-search-handler embed/url)
      ,(make-html-transfer-link (embed/url return-to-index-handler) "Return to index" #:id "prev-bottom")))
  (define render-page/suffix
    (render-page . add-common-suffix))

  (send/suspend/dispatch response-generator))

;; Formatter
(define (format-statistics total pages)
  (define (format-record name len) (format "~a: ~a" name len))
  (string-join
   `(,@(map (lambda/curry/match ((`(,name . ,len)) (format-record name len))) (sort pages > #:key cdr))
     ,(format-record "Total" total))
   "\n"
   #:after-last "\n"))

;; Main
(define connection-close? (vector #f "Every connection is closed after one request."))
(define launch-browser? (vector #f "A web browser is opened to \"http://localhost:<port><servlet-path>\"."))
(define quit? (vector #f "The URL \"/quit\" ends the server."))
(define banner? (vector #f "An informative banner is printed."))
(define listen-ip (vector #f "The server listens on this ip."))
(define/contract port
  (vector/c listen-port-number? any/c)
  (vector 6789 "The server listens on this port."))
(define ssl? (vector #f "Enable SSL."))
(define ssl-cert (vector #f "The server uses this certificate."))
(define ssl-key (vector #f "The server uses this private key."))
(define stats? (vector #f "Display statistics and exit."))
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
 (("--port" p ((vector-ref port 1)) (vector-set! port 0 (string->number p)))
  ("--stats" ((vector-ref stats? 1))
             (call-with-values
              (lambda ()
                (for/fold ((total 0) (pages null)) ((pair (in-list (database-pairs data))))
                  (define len (length (cdr pair)))
                  (values (+ total len)
                          (cons (cons (car pair) len) pages))))
              (display . format-statistics))
             (exit)))
 connection-close?
 launch-browser?
 quit?
 banner?
 listen-ip
 ssl?
 ssl-cert
 ssl-key
 )
(serve
 start
 ((#:extra-files-paths (list build))
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
