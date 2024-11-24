(require racket/base)

;;Determines if flip is heads (#t) or tails (#f)
(define head?
  (lambda (x)
    (if (= x 0) #t
        #f)))


;;Returns the probability given by the Viterbi best path that the casino used
;;a fair coin for the kth coin toss. Takes in emission (flip results), int k,
;;coin swap probability switchPr, probability of heads for one coin p1, and
;;probability of heads for other coin p2
(define viterbiProb
(lambda (emission k switchPr p1 p2)
  (letrec ((probSolve
           (lambda (k i v1 v2 lst)
             (cond ((null? lst) "Invalid k")
                   ((> i k) v1) ;;Use of fair coin on kth toss
                   (else
                    (let*
                        ((toss_fair (if (head? (car lst)) p1 (- 1 p1)))
                         (toss_bias (if (head? (car lst)) p2 (- 1 p2)))
                         (V_F_A (* v1 (- 1 switchPr) toss_fair))
                         (V_F_B (* v2 switchPr toss_fair))
                         (V_B_A  (* v1 switchPr toss_bias))
                         (V_B_B (* v2 (- 1 switchPr) toss_bias))
                         (new-v1 (max V_F_A V_F_B))
                         (new-v2 (max V_B_A V_B_B)))
                      (if (= 1 i)
                          (probSolve k (+ i 1) (* 0.5 toss_fair) (* 0.5 toss_bias) (cdr lst))
                         (probSolve k (+ i 1) new-v1 new-v2 (cdr lst)))))))))
           (probSolve k 1 0 0 emission))))

;;Test Cases

;;(viterbiProb '(0 0 1 1 0 1) 5 0.45 0.5 0.65)
;;0.0019770029296875004

;;(viterbiProb '(0 0 1 1 0 1) 7 0.45 0.5 0.65)
;;"Invalid k"

;;(viterbiProb '(1 0 1 0) 2 0.45 0.5 0.65)
;;0.06875

;;(viterbiProb '(0 0 1 1 1 0 1) 6 0.30 0.5 0.75)
;;0.0013130468749999995


;;Returns a list of 2 elements, where the first element is the best path and
;;the second element is the probability of this path. Takes in emission (flip results),
;;coin swap probability switchPr, probability of heads for one coin p1, and
;;probability of heads for other coin p2, and terms for p1 and p2, s1 and s2
(define viterbiPath
(lambda (emission switchPr s1 s2 p1 p2)
    (letrec ((probSolve
              (lambda (i v1 v2 lst path-1 path-2)
                (cond ((null? lst) 
                      (if (> v1 v2) (list path-1 v1) (list path-2 v2))) ;;Make this return correct path!
                      (else
                       (let*
                           ((toss_fair (if (head? (car lst)) p1 (- 1 p1)))
                            (toss_bias (if (head? (car lst)) p2 (- 1 p2)))
                            (V_F_A (* v1 (- 1 switchPr) toss_fair))
                            (V_F_B (* v2 switchPr toss_fair))
                            (V_B_A  (* v1 switchPr toss_bias))
                            (V_B_B (* v2 (- 1 switchPr) toss_bias))
                            (new-v1 (max V_F_A V_F_B))
                            (path-1-new (if (> V_F_A V_F_B)
                                            (append path-1 (list s1))
                                            (append path-2 (list s1))))
                            (new-v2 (max V_B_A V_B_B))
                            (path-2-new (if (> V_B_A V_B_B)
                                        (append path-1 (list s2))
                                        (append path-2 (list s2)))))
                         (if (= 1 i)
                             (probSolve (+ i 1) (* 0.5 toss_fair) (* 0.5 toss_bias) (cdr lst) path-1-new path-2-new)
                             (probSolve (+ i 1) new-v1 new-v2 (cdr lst) path-1-new path-2-new))))))))
      (probSolve 1 0 0 emission '() '()))))


;;Test Cases

;;(viterbiPath '(1 0 1) 0.45 'Fair 'Biased 0.5 0.55)
;;((Fair Fair Fair) 0.018906250000000003)

;;(viterbiPath '(1 1 0 0 1) 0.45 'Fair 'Biased 0.5 0.65)
;;((Fair Fair Biased Biased Fair) 0.0016175478515625004)

;;(viterbiPath '(1 0 0 0 1) 0.45 'Fair 'Biased 0.5 0.65)
;;((Fair Biased Biased Biased Fair) 0.002102812207031251)

;;(viterbiPath '() 0.45 'Fair 'Biased 0.5 0.65)
;;(() 0)

;;(viterbiPath '(0 0 1 1 0 1 0 1 0 1 1 1) 0.45 'Fair 'Biased 0.5 0.65)
;;((Biased Biased Fair Fair Fair Fair Fair Fair Fair Fair Fair Fair) 2.3514522801709788e-7)

;;(viterbiPath '(0 0 1 0 0 0 1 1 0 0 0 1) 0.45 'Fair 'Biased 0.5 0.65)
;;((Biased Biased Biased Biased Biased Biased Fair Fair Biased Biased Biased Fair) 5.318558887142886e-7)