(require racket/base)
(require racket/stream)


;;Returns first n elements of the stream as a list
(define stream->listn
  (lambda ((s <stream>) (n <integer>))
    (cond ((or (zero? n) (stream-empty? s)) '())
          (else (cons (stream-first s)
                      (stream->listn (stream-rest s) (- n 1)))))))

;;Adds two streams
(define add-streams
  (lambda ((s1 <stream>)(s2 <stream>))
    (cond ((stream-empty? s1) s2)
          ((stream-empty? s2) s1)
          (else (stream-cons (+ (stream-first s1) (stream-first s2))
                             (add-streams (stream-rest s1) (stream-rest s2)))))))

;;Stream representation of infinite ones
(define ones (stream-cons 1 ones))

;;Stream representation of positive integers
(define integers (stream-cons 1 (add-streams ones integers)))

;;Stream Representation of triangular numbers
(define triangular
  (stream-cons 3
               (add-streams triangular
                           (add-streams integers
                                       (add-streams ones ones)))))

;;Function to scale a stream by a constant 
(define scale-stream
  (lambda ((s <stream>) (factor <number>))
    (stream-map (lambda (x) (* x factor)) s)))

;;Stream representation of hexagonal numbers
(define hexagonal
  (stream-cons 6
               (add-streams hexagonal
                            (add-streams ones
                                         (scale-stream (add-streams ones integers) 4)))))

;;Define stream representation of triangular hexagonal numbers
(define triangular-and-hexagonal
  (stream-cons 6
               (add-streams triangular-and-hexagonal
                            (add-streams ones
                                         (scale-stream (add-streams ones integers) 4)))))

;;Define stream representation of triangular but not hexagonal numbers
(define triangular-not-hexagonal
  (stream-cons 3
               (add-streams triangular-not-hexagonal
                            (add-streams integers
                                         (scale-stream (add-streams ones integers) 3)))))

