(require racket/base)
(require racket/stream)



;;Part I: Finite Sets


;;Takes in two sets A & B as list and returns their
;;Cartesian product
(define cart
  (lambda (A B)
    (if (null? A) '()
        (append (map (lambda (x) (list (car A) x)) B)
                (cart (cdr A) B)))))

;;Test Cases

;;(define A (list 1 2 3))
;;(define B (list 4 5 6))
;;(cart A B)
;;((1 4) (1 5) (1 6) (2 4) (2 5) (2 6) (3 4) (3 5) (3 6))

;;(define A (list 1 2))
;;(define B (list 1 3 5))
;;(cart A B)
;;((1 1) (1 3) (1 5) (2 1) (2 3) (2 5))

;;(define A (list 1 4 5))
;;(define B (list 0 2))
;;(cart A B)
;;((1 0) (1 2) (4 0) (4 2) (5 0) (5 2))

;;(define A '())
;;(define B (list 1 2 3))
;;(cart A B)
;;()


;;Given a set S ⊂ A × B, fcn? returns #t when S represents a
;;function, and #f when it does not
(define fcn?
  (lambda (S)
    (not (member #f (foldl (lambda (x y)
                        (if (not (member (car x) y))
                            (cons (car x) y)
                            (cons #f y)))
                      '()
                      S)))))
;;Test Cases

;;(define A (list 1 2 3))
;;(define B (list 4 5 6))
;;(define X (cart A B))
;;(fcn? X)
;;#f

;;(define y (list (list 1 2) (list 2 3) (list 3 3)))
;;(fcn? y)
;;#t

;;(fcn? '())
;;#t

;;Removes any duplicates in inputted list lst
(define remove-duplicates
  (lambda (lst)
    (reverse (foldl (lambda (e a)
                      (if (not (member e a))
                          (cons e a)
                          a))
                    '()
                    lst))))

;;Takes in an S ⊂ A×B and computes π1(S)where π1 : A × B → A
(define p1
  (lambda (S)
    (remove-duplicates (map (lambda (x) (car x)) S))))

;;Test Cases

;;(define prod (cart (list 1 2 3) (list 3 4 5)))
;;(p1 prod)
;;(1 2 3)

;;(define S (list (list 1 2) (list 2 3) (list 3 4)))
;;(p1 S)
;;(1 2 3)

;;(define S '())
;;(p1 S)
;;()

;;(define S (list (list 1 2) (list 2 3) (list 3 4) (list 4 5)))
;;(p1 S)
;;(1 2 3 4)

;;Takes in an S ⊂ A×B and computes π2(S) where π2 : A × B → B
(define p2
  (lambda (S)
    (remove-duplicates (map (lambda (x) (cadr x)) S))))

;;Test Cases

;;(define prod (cart (list 1 2 3) (list 3 4 5)))
;;(p2 prod)
;;(3 4 5)

;;(define S (list (list 1 2) (list 2 3) (list 3 4)))
;;(p2 S)
;;(2 3 4)

;;(define S '())
;;(p2 S)
;;()

;;(define S (list (list 1 2) (list 2 3) (list 3 4) (list 4 5)))
;;(p2 S)
;;(2 3 4 5)

;;Computes the diagonal given some set A
(define diag
  (lambda (A)
    (map (lambda (x) (list x x)) A)))

;;Test Cases
;;(define A (list 1 2 3))
;;(diag A)
;;((1 1) (2 2) (3 3))

;;(define A '())
;;(diag A)
;;()

;;(define A (list 2 4 6 7 8))
;;(diag A)
;;((2 2) (4 4) (6 6) (7 7) (8 8))

;;Takes in some set of ordered pairs D, returns #t
;;iff D is a diagonal set
(define diag?
  (lambda (D)
    (not (member #f (map (lambda (x) (equal? (car x) (cadr x))) D)))))

;;Test Cases
;;(define x (diag (list 1 2 3)))
;;(diag? x)
;;#t

;;(diag? '())
;;#t

;;(define lst (list (list 1 2) (list 2 2) (list 3 3)))
;;(diag? lst)
;;#f

;;Given a diagonal set delta, returns a set A such that diag(A) = delta
(define diag-inv
  (lambda (delta)
    (map (lambda (x) (car x)) delta)))

;;Test Cases

;;(define x (diag (list 1 2 3)))
;;(diag-inv x)
;;(1 2 3)

;;(diag-inv '())
;;()

;;(define A (diag (list 2 4 6 7 8)))
;;(diag-inv A)
;;(2 4 6 7 8)

;;Uses remove-duplicates helper function defined above
;;Takes in a set A and returns its powerset
(define powerset
  (lambda (L)
    (remove-duplicates
     (foldr (lambda (a e)
              (append (map (lambda (x) (cons a x))
                      e)
                 e))
         '(())
         L))))


;;Test Cases
;;(powerset (list 1 2 3))
;;((1 2 3) (1 2) (1 3) (1) (2 3) (2) (3) ())

;;(powerset '())
;;(())

;;(powerset (list 0 1 2 3))
;;((0 1 2 3) (0 1 2) (0 1 3) (0 1) (0 2 3) (0 2) (0 3) (0) (1 2 3) (1 2) (1 3) (1) (2 3) (2) (3) ())

;;Part II: Infinite Sets

;;Takes in a stream and prints the first n elements
(define stream->listn
  (lambda ((s <stream>) (n <integer>))
    (cond ((or (zero? n) (stream-empty? s)) '())
          (else (cons (stream-first s)
                      (stream->listn (stream-rest s) (- n 1)))))))

;;Takes in two infinite sets as streams A & B and returns their
;;Cartesian product
(define stream-cart
  (lambda (A B)
    (cond ((stream-empty? A) A)
          ((stream-empty? B) B)
          (else
           (letrec ((iter
                     (lambda (x y current)
                       (if (= x 0)
                           (stream-cons (list (stream-ref A x) (stream-ref B y))
                                        (iter (+ current x) 0 (+ current 1)))
                           (stream-cons (list (stream-ref A x) (stream-ref B y))
                                        (iter (- x 1) (+ y 1) current))))))
             (iter 0 0 1))))))


;;Test Cases
;;(stream->listn (stream-cart ones ones) 10)
;;((1 1) (1 1) (1 1) (1 1) (1 1) (1 1) (1 1) (1 1) (1 1) (1 1))

;;(stream->listn (stream-cart integers integers) 20)
;;((1 1) (2 1) (1 2) (3 1) (2 2) (1 3) (4 1) (3 2) (2 3) (1 4) (5 1) (4 2) (3 3) (2 4) (1 5) (6 1) (5 2) (4 3) (3 4) (2 5))


;;Takes in an S ⊂ A×B as stream and computes π1(S)where π1 : A × B → A
(define stream-pi1
  (lambda (S)
    (stream-map (lambda (x) (car x)) S)))

;;Test Cases

;;(define x (list 1 2))
;;(define ones-ordered (stream-cons x ones-ordered))
;;(stream->listn (stream-pi1 ones-ordered) 5)
;;(1 1 1 1 1)

;;(define test (stream-cart ones integers))
;;(stream->listn (stream-pi1 test) 7)
;;(1 1 1 1 1 1 1)

;;(define x (list 2 1))
;;(define ordered (stream-cons x ordered))
;;(stream->listn (stream-pi1 ordered) 10)
;;(2 2 2 2 2 2 2 2 2 2)

;;Takes in an S ⊂ A×B as stream and computes π2(S)where π2 : A × B → B
(define stream-pi2
  (lambda (S)
    (stream-map (lambda (x) (cadr x)) S)))

;;Test Cases

;;(define test (stream-cart ones integers))
;;(stream->listn (stream-pi2 test) 7)
;;(1 1 1 1 1 1 1)

;;(define x (list 1 2))
;;(define ones-ordered (stream-cons x ones-ordered))
;;(stream->listn (stream-pi2 ones-ordered) 5)
;;(2 2 2 2 2)

;;(define x (list 2 1))
;;(define ordered (stream-cons x ordered))
;;(stream->listn (stream-pi2 ordered) 10)
;;(1 1 1 1 1 1 1 1 1 1)


;;Computes the diagonal given some set A as a stream
(define stream-diag
  (lambda (S)
    (stream-map (lambda (x) (list x x)) S)))

;;Function to add-streams for testing
(define add-streams 
  (lambda ((a <stream>) (b <stream>))
    (cond ((stream-empty? a) b)
          ((stream-empty? b) a)
          (else (stream-cons (+ (stream-first a) (stream-first b))
                                (add-streams (stream-rest a) (stream-rest b)))))))

;;Stream definitions for testing
(define ones (stream-cons 1 ones))
(define integers (stream-cons 1 (add-streams ones integers)))

;;Test Cases
;;(stream->listn (stream-diag ones) 5)
;;((1 1) (1 1) (1 1) (1 1) (1 1))
;;(stream->listn (stream-diag integers) 10)
;;((1 1) (2 2) (3 3) (4 4) (5 5) (6 6) (7 7) (8 8) (9 9) (10 10))

;;Given a diagonal set delta as a stream, returns a set as stream A
;;such that diag(A) = delta
(define stream-diag-inv
  (lambda (S)
    (stream-map (lambda (x) (car x)) S)))

;;Test Cases
;;(define test (stream-diag ones))
;;(stream->listn (stream-diag-inv test) 10)
;;(1 1 1 1 1 1 1 1 1 1)

;;(define test2 (stream-diag integers))
;;(stream->listn (stream-diag-inv test2) 10)
;;(1 2 3 4 5 6 7 8 9 10)

