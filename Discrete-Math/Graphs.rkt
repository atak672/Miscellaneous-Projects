;;PSET #3

;;Problem #1

;;Takes a vertex v and a graph G in that graph
;;Returns a list of vertices that can be reached
;;By traversing a single edge
(define exits
  (lambda (v G)
    (foldr (lambda (x y) (cons (finish x) y)) '()
                 (filter (lambda (a) (equal-vertex? v (start a))) (edges G)))))

;;Definition of g1 for testing
;;(define g1 (make-graph '(a b c d e) 
;;		       '((a b) (a c) (b c) (b e) (c d) (d b))))

;;Test cases 
;;(name-vertices (exits (lookup-vertex 'b (vertices g1)) g1))
;;(c e)
;;(name-vertices (exits (lookup-vertex 'e (vertices g1)) g1))
;;()
;;(name-vertices (exits (lookup-vertex 'e (vertices g1)) g1))
;;(b c)


;;Takes a graph G and a list of vertices lst
;;Verifies whether indeed the list is a valid path in the given graph
(define verify-path
  (lambda (G lst)
    (cond ((null? lst) #t) ;;Given empty path – empty set is a subset of any set s
          ((null? (cdr lst)) #t)
          ((member? (cadr lst) (exits (car lst) G))
           (verify-path G (cdr lst)))
          (else #f))))




;;Test cases (Using g1)
;;(verify-path g1 
;;    (map (lambda (x) (lookup-vertex x (vertices g1))) '(a b c d b e)))
;;#t
;;(verify-path g1 
;;    (map (lambda (x) (lookup-vertex x (vertices g1))) '(a b c d e)))
;;#f

;;(verify-path g1 
;;    (map (lambda (x) (lookup-vertex x (vertices g1))) '(a)))
;;#t


;;Problem #3

;;Takes an <automaton>, a state name, and input symbol
;;Filters lists that contain start name and label symbol
(define filter-label-edge
  (lambda (auto vname lab)
    (filter (lambda (x) (equal? vname (name (start x))))
            (filter (lambda (y) (equal? lab (label y)))
                    (edges auto)))))

;;Takes an <automaton>, a state name, and an input symbol
;;Finds the state of the DFA which is reachable from the
;;given state with the given symbol
(define step-dfa
  (lambda (auto state sym)
    (cond ((null? (filter-label-edge auto state sym)) #f) 
          ((not(null? (cdr (filter-label-edge auto state sym)))) #f)
          (else
           (name (finish (car (filter-label-edge auto state sym))))))))

;;Test Cases
;;(step-dfa dfa1 'c 1)
;;c
;;(step-dfa dfa1 'd 0)
;;#f
;;(step-dfa dfa1 'a 0)
;;a
;;(step-dfa dfa1 'a 1)
;;b
;;(step-dfa dfa1 'a 2)
;;#f
;;(step-dfa dfa1 'a 10)
;;#f
;;(step-dfa dfa1 'z 1)
;;#f

;;(define bad-dfa
;;    (make-automaton '(a b c)
;;                    '((a a 0) (a b 0) (b a 1) (b c 0) (c b 0) (c c 1))
;;                    'a
;;                    '(a)))
;;(step-dfa bad-dfa 'a 0)
;;#f
;;(step-dfa bad-dfa 'b 1)
;;a

;;Problem #4

;;Takes in an <automaton> and input sequence (lst)
;;Returns whether sequence drives DFA to final state
(define simulate-dfa
  (lambda (auto lst)
    (letrec ((track
              (lambda (start path final)
                (cond ((null? path) (member? start final))
                      ((null? (cdr path)) ;;Need check for null? path  ?
                       (member? (step-dfa auto start (car path)) final))
                      ((equal? (step-dfa auto start (car path)) #f) #f) 
                      (else
                       (track (step-dfa auto start (car path)) (cdr path) final))))))
      (track (start-state auto) lst (final-states auto)))))

;;Test Cases
;;(simulate-dfa dfa1 '(1 0 0 1))
;;#t
;;(simulate-dfa dfa1 '(1 0 1 1))
;;#f
;;(simulate-dfa bad-dfa '(1 0 0 1))
;;#f
;;(simulate-dfa dfa1 '())
;;(simulate-dfa dfa1 (integer->binary 12))
;;#t
;;(simulate-dfa dfa1 (integer->binary 10))
;;#f

;;Problem #5

;;Takes an <automaton>, a state name, and input symbol
;;Finds accessible state names given the above parameters
(define calc-label-edge-nfa
  (lambda (auto vname lab)
    (map (lambda (z) (name (finish z)))
         (filter (lambda (x) (equal? vname (name (start x))))
                      (filter (lambda (y) (equal? lab (label y)))
                              (edges auto))))))

;;Takes an <automaton>, a list of states, and an input symbol
;;Finds the states of the NFA which is reachable from the
;;given states with the given symbol
(define step-nfa
  (lambda (auto slst sym)
    (cond ((null? slst) '())
          ((null? (calc-label-edge-nfa auto (car slst) sym)) '())
          (else
           (append (calc-label-edge-nfa auto (car slst) sym)
                   (step-nfa auto (cdr slst) sym))))))


;;Test Cases
;;(step-nfa dfa1 '(c) 1)
;;(c)
;;(step-nfa dfa1 '(d) 0)
;;()
;;(step-nfa dfa1 '(a) 0)
;;(a)
;;(step-nfa dfa1 '(a) 1)
;;(b)
;;(step-nfa dfa1 '(a) 2)
;;()
;;(step-nfa nfa1 '(c) 1)
;;()
;;(step-nfa nfa1 '(d) 0)
;;(d)
;;(step-nfa nfa1 '(a) 0)
;;(a c)

;;Returns whether sequence drives NFA to final state
(define simulate-nfa
  (lambda (auto lst)
    (letrec ((track
              (lambda (start path final)
                (cond ((null? lst) (member? (car start) final)) ;;if no path; check if start is acceptable final state
                      ((null? (cdr path))
                       (not (null? (filter (lambda (x) (member? x final)) (step-nfa auto start (car path))))))
                      ((null? (step-nfa auto start (car path))) #f) 
                      (else
                       (track (step-nfa auto start (car path)) (cdr path) final))))))
      (track (list (start-state auto)) lst (final-states auto)))))

;;Test Cases
;;(simulate-nfa dfa1 '(1 0 0 1))
;;#t
;;(simulate-nfa dfa1 '(1 0 1 1))
;;#f
;;(simulate-nfa dfa1 (integer->binary 12))
;;#t
;;(simulate-nfa dfa1 (integer->binary 10))
;;#f
;;(simulate-nfa nfa1 '(0 0 1 1))
;:#t
;;(simulate-nfa nfa1 '(1 0 1 0 ))
;;#f
;;(simulate-nfa nfa1 '(0 0 0 0 1 1))
;;#t
;;(simulate-nfa dfa1 '(1 1 0 0))
;;#t
;;(simulate-nfa nfa1 '())
;;#f

;;Problem #6

;;Takes two vertex names, a graph G, and a lst
;;Helper function to determine if a path exists
;;Between the two vertices -- helper function
;;for path?
(define sort-path
  (lambda (start finish lst G)
    (cond ((equals? start finish) #t) ;;Start equal to finish
          ((member? (lookup-vertex finish (vertices G)) ;;finish directly connected via edge to current vertex
                    (exits (lookup-vertex start (vertices G)) G)) #t)
          ((null? (exits (lookup-vertex start (vertices G)) G)) #f) ;;No vertices directly connected--dead end
          ((member? start lst) #f) ;;Deadend -- prevents counting cycles
          (else
           (member? #t (map (lambda (x) (sort-path (name x) finish (cons start lst) G))
                            (exits (lookup-vertex start (vertices G)) G))))))) ;;Applies function to all direct access vertices


;;Takes in in two vertex names and a graph G
;;Returns #t if there exists a path between
;;The two inputted vertex names
(define path?
  (lambda (v1 v2 G)
    (cond ((not(member? (lookup-vertex v1 (vertices G)) (vertices G))) #f)
          ((not(member? (lookup-vertex v2 (vertices G)) (vertices G))) #f)
          (else
           (sort-path v1 v2 '() G)))))
           
 ;;Test Cases
;;(path? 'a 'e g1)
;;#t
;;(path? 'd 'a g1)
;;#f
;;(path? 'a 'c g2)
;;#t
;;(path? 'c 'b g2)
;;#t
;;(path? 'd 'd g3)
;;#t
;;(path? 'a 'd g3)
;;f
;;(path? 'b 'd g4)
;;t
;;(path? 'z 't g1)
;;#f
;;(path? 'a 'd g4)
;;#t


;;Problem #7

;;Takes in a start vertex, finish vertex, empty list
;;and graph G to find possible paths between vertices
(define find-path-help
  (lambda (start finish plst G)
    (cond ((not (path? start finish G)) '()) 
          ((equal? start finish) (list start finish)) 
          ((member? (lookup-vertex finish (vertices G)) ;;If finish is connected via direct edge to current vertex
                    (exits (lookup-vertex start (vertices G)) G))(append (list finish start) plst))
          ((null? (exits (lookup-vertex start (vertices G)) G)) '()) ;;No direct vertices via single edge
          ((member? start plst) '()) ;;Another dead end -- prevent cycles -- vertex already visited
          (else
           (map (lambda (x) (find-path-help (name x) finish (cons start plst) G))
                            (exits (lookup-vertex start (vertices G)) G)))))) ;;Apply function to all accessible vertices


;;Takes in a start vertex, a finish vertex, and graph G
;;Outputs vertex path to follow to connect two vertices
(define find-path
  (lambda (v1 v2 G)
    (cond ((not(member? (lookup-vertex v1 (vertices G)) (vertices G))) #f)
          ((not(member? (lookup-vertex v2 (vertices G)) (vertices G))) #f)
          ((not (path? v1 v2 G)) #f)
          (else
           (map (lambda (x) (lookup-vertex x (vertices G)))
                (reverse (single-path (edit-lst (find-path-help v1 v2 '() G)) v1)))))))


;;Intakes a lst and and makes sublists a list with
;;no sublists --> makes 1-Dimensional list
(define edit-lst
  (lambda (lst)
    (cond ((not(list? lst)) (list lst))
          ((null? lst) lst)
          (else
           (append (edit-lst (car lst)) (edit-lst (cdr lst)))))))

;;Takes in a 1D lst of all paths and vertex
;;Returns a single path in graph
(define single-path
  (lambda (l v)
    (cond ((null? l) '())
          ((equals? (car l) v) (list v))
          (else
           (cons (car l) (single-path (cdr l) v))))))

;;Test Cases
;;(name-vertices (find-path 'a 'e g1))
;;(a b e)
;;(find-path 'd 'a  g1)
;;#f
;;(name-vertices (find-path 'a 'c g2))
;;(a c)
;;(name-vertices (find-path 'c 'b g2))
;;(c a b)
;;(name-vertices (find-path 'd 'd g3))
;;(d)
;;(find-path 'a 'd g3)
;;#f
;;(name-vertices (find-path 'b 'd g4))
;;(b a d)

;;(define g5 (make-graph '(a b c) '((a b) (b a) (b c))))
;;(name-vertices (find-path 'b 'c g5))
;;(b c)
;;(name-vertices (find-path 'b 'a g5))
;;(b a)

;(define g6 (make-graph '(a b c d) '((a b) (b a) (b c) (c d) (c d))))
;;(name-vertices (find-path 'c 'd g6))
;;(c d)
;;(name-vertices (find-path 'a 'd g6))
;;(a b c d)
;;(name-vertices (find-path 'a 'a g6))
;;(a)

;;Bonus

;;Takes a state name, a label symbol, and a lst of edges and symbols
(define help-find-dup
  (lambda (state sym lst)
    (filter (lambda (x) (equal? state (car x))) ;;Then filter for same state
            (filter (lambda (z) (equal? sym (caddr z))) lst)))) ;;filter first for same symbol

;; make-dfa takes four parameters.  
;; The first is a list of symbols of the form (v1 v2 v3 ...) which 
;; becomes the list of vertices.
;; The second is a list of triples of the form 
;; ((u1 u2 l1) (u3 u4 l2) ...) which becomes the list of labeled
;; edges (with the u's symbols which represent vertices and the l's 
;; objects which become the labels).
;; The third is a single symbol for the start state.
;; The fourth is a list of symbols that represent final states
;;Returns #f if arguments do not specific a deterministic automaton

(define make-dfa
  (lambda (v-names e-list s-state f-states) ;v-names <list>, e-list <list>, s-state <symbol>, f-states <list>
    (cond ((member? #t (map (lambda (y) (not (null? (cdr (help-find-dup (car y) (caddr y) e-list)))))
                    e-list)) #f)
          (else
           (make-automaton v-names e-list s-state f-states)))))
             

;;Test Cases
;;(make-dfa '(a b c) '((a a 0) (b a 1) (b c 0) (a c 1)) 'a '(a))
;;#<automaton> --> not #f so returned automaton object

;;(make-dfa '(a b c d) '((a a 0) (a b 0) (b b 0) (c a 1) (c d 0)) 'b '(b))
;;f 



