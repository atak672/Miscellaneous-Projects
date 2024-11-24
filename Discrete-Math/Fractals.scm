;;; Go to Language, Choose Language, Other Languages, Swindle, Full Swindle
;;; This may have to be done in cs230-graphics.scm as well
;;; cs230.ps1.scm


(require racket/base) ;;This allows the type system to work.
(require (file "cs230-graphics.scm")) ;;Pull in the definitions for the drawing window and stuff. Assumes the file is in the same directory. 

;; Here are the procedures you will modify in the problem set
(define side
  (lambda ((length <real>) (heading <real>) (level <integer>))
    (if (zero? level)
        (drawto heading length)
        (let ((len/3 (/ length 3))
              (lvl-1 (- level 1)))
          (side len/3 heading lvl-1)
          (side len/3 (- heading PI/3) lvl-1)
          (side len/3 (+ heading PI/3) lvl-1)
          (side len/3 heading lvl-1)))))

(define snowflake:0
  (lambda ((length <real>) (level <integer>))
    (side length 0.0 level)
    (side length (* 2 PI/3) level)
    (side length (- (* 2 PI/3)) level)))

;;Question #1

;;New generator function 'flip-side'
(define flip-side
  (lambda ((length <real>)(heading <real>)(level <integer>))
   (if (zero? level)
    (drawto heading length)
    (let ((len/2sqrt2 (/ length (* 2 (sqrt 2))))
          (lvl-1 (- level 1)))
      (flip-side len/2sqrt2 (- heading PI/4) lvl-1)
      (flip-side (* 2 len/2sqrt2) (+ heading PI/4) lvl-1)
      (flip-side len/2sqrt2 (- heading PI/4) lvl-1)))))

;;New initiator function 'pentagon-snowflake:1'
(define pentagon-snowflake:1
  (lambda ((length <real>) (level <integer>))
    (let ((PI/5 (/ PI 5)))
    (flip-side length 0.0 level)
    (flip-side length (* 2 PI/5) level)
    (flip-side length (* 4 PI/5) level)
    (flip-side length (- (* 4 PI/5)) level)
    (flip-side length (- (* 2 PI/5)) level))))

;;Test Cases for Question #1

;;(pentagon-snowflake:1 150 3)

;;(pentagon-snowflake:1 100 5)

;;(pentagon-snowflake:1 100 0)

;;(flip-side 100 0 1)


;;Question #2

;;Altered copy of 'pentagon-snowflake:1' as to parameterize a generator
(define pentagon-snowflake:2
  (lambda ((length <real>) (level <integer>) (generator <function>))
    (let ((PI/5 (/ PI 5)))
    (generator length 0.0 level)
    (generator length (* 2 PI/5) level)
    (generator length (* 4 PI/5) level)
    (generator length (- (* 4 PI/5)) level)
    (generator length (- (* 2 PI/5)) level))))

;;Altered copy of 'snowflake:1' as to parameterize a generator
(define snowflake:2
  (lambda ((length <real>) (level <integer>) (generator <function>))
    (generator length 0.0 level)
    (generator length (* 2 PI/3) level)
    (generator length (- (* 2 PI/3)) level)))

;;Test Cases for Question #2

;;van Koch initiator with van Koch generator
;;(snowflake:2 200 3 side)

;; van Koch initiator with flip-side generator
;;(snowflake:2 150 3 flip-side)

;;pentagon initiator with van Koch generator
;;(pentagon-snowflake:2 200 3 side)

;;pentagon initiator with flip-side generator
;;(pentagon-snowflake:2 150 3 flip-side)

;;pentagon initiator with flip-side generator
;;(pentagon-snowflake:2 100 8 flip-side)


;;Question #3

;;Copy of 'side' as to parameterize inversion
(define side-inv
  (lambda ((length <real>) (heading <real>) (level <integer>) (inverter <function>))
    (if (zero? level)
        (drawto heading length)
        (let ((len/3 (/ length 3))
              (lvl-1 (- level 1))
              (orient (inverter level)))
          (side-inv len/3 heading lvl-1 inverter)
          (side-inv len/3 (- heading (* orient PI/3)) lvl-1 inverter)
          (side-inv len/3 (+ heading (* orient PI/3)) lvl-1 inverter)
          (side-inv len/3 heading lvl-1 inverter)))))

;;Altered copy of 'snowflake:2' as to parameterize inversion
(define snowflake-inv
  (lambda ((length <real>) (level <integer>) (generator <function>) (inverter <function>))
    (generator length 0.0 level inverter)
    (generator length (* 2 PI/3) level inverter)
    (generator length (- (* 2 PI/3)) level inverter)))

;;Test Cases for Question #3

;;(snowflake-inv 150 3 side-inv
;;               (lambda ((level <integer>)) 
;;	           (if (odd? level) 1 -1)))

;;(snowflake-inv 150 3 side-inv
;;               (lambda ((level <integer>)) 
;;	         (if (even? level) 1 -1)))


;;(side-inv 100 0 1
;;           (lambda ((level <integer>))
;;              (if (odd? level) 1 -1)))

;;(side-inv 200 0 2
;;            (lambda ((level <integer>))
;;              (if (= level 1) 1 -1)))


;;Question #4

;;Produces total length that function would draw given some parameters
(define side-length
  (lambda ((length <real>) (heading <real>) (level <integer>) (inverter <function>))
    (if (zero? level)
        length
        (let ((len/3 (/ length 3))
              (lvl-1 (- level 1))
              (orient (inverter level)))
          (+ (side-length len/3 heading lvl-1 inverter)
             (side-length len/3 (- heading (* orient PI/3)) lvl-1 inverter)
             (side-length len/3 (+ heading (* orient PI/3)) lvl-1 inverter)
             (side-length len/3 heading lvl-1 inverter))))))
    
;;Produces total length function would draw given some parameters
(define snowflake-length
  (lambda ((length <real>) (level <integer>) (generator <function>) (inverter <function>))
    (+ (generator length 0.0 level inverter)
       (generator length (* 2 PI/3) level inverter)
       (generator length (- (* 2 PI/3)) level inverter))))

;;Test Cases for Question #4

;;(snowflake-length 100.0 3 side-length 
;;                  (lambda ((level <integer>)) 1))
;;Output: 711.1111111111112

;;(snowflake-length 100.0 4 side-length 
;;                  (lambda ((level <integer>)) 1))
;;Output: 948.1481481481483

;;(snowflake-length 150.0 3 side-length 
;;                  (lambda ((level <integer>)) 1))
;;Output: 1066.6666666666667

;;(side-length 100 0 2
;;             (lambda ((level <integer>)) 1))
;;Output: 1600/9

;; Make the graphics window visible, and put the pen somewhere useful
(init-graphics 640 480)
(clear)
(moveto 100 100)

    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
