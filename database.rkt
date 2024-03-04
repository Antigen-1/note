#lang racket
(provide call/database/update read-database make-database-file
         database-set database-ref database-names database-xexprs database-pairs)

(define (read-database f)
  (file->value f))
(define (write-database d f)
  (write-to-file d f #:exists 'truncate/replace))

(define (call/database/update f p)
  (write-database (p (read-database f)) f))
(define (make-database-file f)
  (write-database (make-empty-database) f))

(define (make-empty-database) (hash))
(define (database-set d name xexpr)
  (hash-set d name xexpr))
(define (database-ref d name)
  (hash-ref d name))
(define (database-names d)
  (hash-keys d))
(define (database-xexprs d)
  (hash-values d))
(define (database-pairs d)
  (hash->list d))
