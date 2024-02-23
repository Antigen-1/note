#lang info
(define collection "note")
(define racket-launcher-names (list "display-note"))
(define racket-launcher-libraries (list "main.rkt"))
(define install-collection "installer.rkt")
(define deps (list (list "base" '#:version "8.12")
                   "web-server-lib"
                   "pollen"
                   "git://github.com/Antigen-1/hasket.git"))
