#lang racket

; Section 1.3.1: Procedures as Arguments

(require "common.rkt")

;   Exercise 1.29
;   =============
;   
;   Simpson's Rule is a more accurate method of numerical integration than
;   the method illustrated above.  Using Simpson's Rule, the integral of a
;   function f between a and b is approximated as
;   
;   h
;   ─ [y₀ + 4y₁ + 2y₂ + 4y₃ + 2y₄ + ... + 2y    + 4y    + y ]
;   3                                      ⁿ⁻²     ⁿ⁻¹    ⁿ
;   
;   where h = (b - a)/n, for some even integer n, and y_(k) = f(a + kh).
;   (Increasing n increases the accuracy of the approximation.) Define a
;   procedure that takes as arguments f, a, b, and n and returns the value
;   of the integral, computed using Simpson's Rule. Use your procedure to
;   integrate cube between 0 and 1 (with n = 100 and n = 1000), and compare
;   the results to those of the integral procedure shown above.
;   
;   ------------------------------------------------------------------------
;   [Exercise 1.29]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.29
;   1.3.1 Procedures as Arguments - p60
;   ------------------------------------------------------------------------

(-start- "1.29")

(define (cube n)
  (* n n n))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a) (sum term (next a) next b))))

(define (inc n)
  (+ n 1))

(define (simpson f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (term k)
    (cond
      ((= k 0) (y 0))
      ((= k n) (y n))
      ((even? k) (* 2 (y k)))
      (else (* 4 (y k)))))
  (* (/ h  3)
     (sum term 0 inc n)))

(present simpson
         (list cube 0 1. 2)
         (list cube 0 1. 100)
         (list cube 0 1. 1000) 
         (list cube 0 1. 100000))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(present integral
         (list cube 0 1. 0.5)
         (list cube 0 1. 0.01)
         (list cube 0 1. 0.001)
         (list cube 0 1. 0.00001))

(prn "As promised Simpson Rule is much more accurate for a given number of
iterations.  It looks like it would take 100,000,000 iterations for
Integral to be as accurate as Simpson is after 100 iterations.

Integral appears to be approaching the solution from below whereas we
see Simpson producse positive errors as well as negative errors.

This particular integration does seem to suite Simpsons well as it gives
an exactly correct answer after just 2 iterations.")

(--end-- "1.29")

;   ========================================================================
;   
;   Exercise 1.30
;   =============
;   
;   The sum procedure above generates a linear recursion.  The procedure can
;   be rewritten so that the sum is performed iteratively. Show how to do
;   this by filling in the missing expressions in the following definition:
;   
;   (define (sum term a next b)
;     (define (iter a result)
;       (if <??>
;           <??>
;           (iter <??> <??>)))
;     (iter <??> <??>))
;   
;   ------------------------------------------------------------------------
;   [Exercise 1.30]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.30
;   1.3.1 Procedures as Arguments - p60
;   ------------------------------------------------------------------------

(-start- "1.30")

(define (sum-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))

(define (simpson-iter f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (term k)
    (cond
      ((= k 0) (y 0))
      ((= k n) (y n))
      ((even? k) (* 2 (y k)))
      (else (* 4 (y k)))))
  (* (/ h  3)
     (sum-iter term 0 inc n)))

(present simpson-iter
         (list cube 0 1. 2)
         (list cube 0 1. 100)
         (list cube 0 1. 1000) 
         (list cube 0 1. 100000))

(prn "Results appear equally accurate, but they are different; possibly just
the vagaries of floating point.")

(--end-- "1.30")

;   ========================================================================
;   
;   Exercise 1.31
;   =============
;   
;   a.  The sum procedure is only the simplest of a vast number of similar
;   abstractions that can be captured as higher-order procedures.⁽⁵¹⁾ Write
;   an analogous procedure called product that returns the product of the
;   values of a function at points over a given range. Show how to define
;   factorial in terms of product.  Also use product to compute
;   approximations to π using the formula⁽⁵²⁾
;   
;   π   2·4·4·6·6·8···
;   ─ = ──────────────
;   4   3·3·5·5·7·7···
;   
;   b.  If your product procedure generates a recursive process, write one
;   that generates an iterative process. If it generates an iterative
;   process, write one that generates a recursive process.
;   
;   ------------------------------------------------------------------------
;   [Exercise 1.31]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.31
;   [Footnote 51]:   http://sicp-book.com/book-Z-H-12.html#footnote_Temp_95
;   [Footnote 52]:   http://sicp-book.com/book-Z-H-12.html#footnote_Temp_96
;   1.3.1 Procedures as Arguments - p60
;   ------------------------------------------------------------------------

(-start- "1.31")

(define (prod-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))

(prn (str "Iterative product of terms:

    The product of numbers from 1 to 6: " (prod-iter identity 1 inc 6)))

(define (pi-term i)
  (/
   (* 2 (quotient (+ i 3) 2))
   (+ 1 (* 2 (quotient (+ i 2) 2)))))

(define (pi-iter n)
  (* 4.0 (prod-iter pi-term 0 inc n)))

(prn (str "
    Estimate of π with 100 steps " (pi-iter 100)))

(define (prod-rec term a next b)
  (if (= a b)
      (term a)
      (* (term a) (prod-rec term (next a) next b))))

(define (pi-rec n)
  (* 4.0 (prod-rec pi-term 0 inc n)))

(prn
 (str "

Recursive product of terms:

    The product of numbers from 1 to 6: " (prod-rec identity 1 inc 6))
 (str "
    Estimate of π with 100 steps " (pi-rec 100)))
         
(--end-- "1.31")

;   ========================================================================
;   
;   Exercise 1.32
;   =============
;   
;   a. Show that sum and product (exercise [1.31]) are both special cases of
;   a still more general notion called accumulate that combines a collection
;   of terms, using some general accumulation function:
;   
;   (accumulate combiner null-value term a next b)
;   
;   Accumulate takes as arguments the same term and range specifications as
;   sum and product, together with a combiner procedure (of two arguments)
;   that specifies how the current term is to be combined with the
;   accumulation of the preceding terms and a null-value that specifies what
;   base value to use when the terms run out.  Write accumulate and show how
;   sum and product can both be defined as simple calls to accumulate.
;   
;   b. If your accumulate procedure generates a recursive process, write one
;   that generates an iterative process. If it generates an iterative
;   process, write one that generates a recursive process.
;   
;   ------------------------------------------------------------------------
;   [Exercise 1.32]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.32
;   [Exercise 1.31]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.31
;   1.3.1 Procedures as Arguments - p61
;   ------------------------------------------------------------------------

(-start- "1.32")

(define (acc-iter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner result (term a)))))
  (iter a null-value))

(define (sum-acc-iter term a next b)
  (acc-iter + 0 term a next b))

(define (prod-acc-iter term a next b)
  (acc-iter * 1 term a next b))

(define (simpson-acc-iter f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (term k)
    (cond
      ((= k 0) (y 0))
      ((= k n) (y n))
      ((even? k) (* 2 (y k)))
      (else (* 4 (y k)))))
  (* (/ h  3)
     (sum-acc-iter term 0 inc n)))

(prn "Implementing product and sum in terms of general accumulators:
")

(present simpson-acc-iter
         (list cube 0 1. 2)
         (list cube 0 1. 100)
         (list cube 0 1. 1000) 
         (list cube 0 1. 100000))

(define (pi-acc-iter n)
  (* 4.0 (prod-acc-iter pi-term 0 inc n)))

(prn (str "Estimate of π with 100 steps (prod-acc-iter): "
          (pi-acc-iter 100)))

(define (acc-rec combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (acc-rec combiner null-value term (next a) next b))))

(define (sum-acc-rec term a next b)
  (acc-rec + 0 term a next b))

(define (prod-acc-rec term a next b)
  (acc-rec * 1 term a next b))

(define (simpson-acc-rec f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (term k)
    (cond
      ((= k 0) (y 0))
      ((= k n) (y n))
      ((even? k) (* 2 (y k)))
      (else (* 4 (y k)))))
  (* (/ h  3)
     (sum-acc-rec term 0 inc n)))

(prn "Implementing product and sum in terms of general accumulators:
")

(present simpson-acc-rec
         (list cube 0 1. 2)
         (list cube 0 1. 100)
         (list cube 0 1. 1000) 
         (list cube 0 1. 100000))

(define (pi-acc-rec n)
  (* 4.0 (prod-acc-rec pi-term 0 inc n)))

(prn (str "Estimate of π with 100 steps (prod-acc-rec): "
          (pi-acc-rec 100)))

(--end-- "1.32")

;   ========================================================================
;   
;   Exercise 1.33
;   =============
;   
;   You can obtain an even more general version of accumulate (exercise
;   [1.32]) by introducing the notion of a filter on the terms to be
;   combined.  That is, combine only those terms derived from values in the
;   range that satisfy a specified condition.  The resulting
;   filtered-accumulate abstraction takes the same arguments as accumulate,
;   together with an additional predicate of one argument that specifies the
;   filter.  Write filtered-accumulate as a procedure.  Show how to express
;   the following using filtered-accumulate:
;   
;   a. the sum of the squares of the prime numbers in the interval a to b
;   (assuming that you have a prime? predicate already written)
;   
;   b. the product of all the positive integers less than n that are
;   relatively prime to n (i.e., all positive integers i < n such that
;   GCD(i,n) = 1).
;   
;   ------------------------------------------------------------------------
;   [Exercise 1.33]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.33
;   [Exercise 1.32]: http://sicp-book.com/book-Z-H-12.html#%_thm_1.32
;   1.3.1 Procedures as Arguments - p61
;   ------------------------------------------------------------------------

(-start- "1.33")

(define (prime? n)
  (define (smallest-divisor-next-inline n)
    (define (find-divisor n test-divisor)
      (define (square n) (* n n))
      (define (divides? a b)
        (= (remainder b a) 0))
      (cond ((> (square test-divisor) n) n)
            ((divides? test-divisor n) test-divisor)
            (else (find-divisor n (if (= test-divisor 2)
                                      3 
                                      (+ test-divisor 2))))))
    (find-divisor n 2))
  (if (< n 2)
      #f
      (= n (smallest-divisor-next-inline n))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define
  (filtered-accumulate include-a? combiner null-value term a next b)
  (define (iter a result)
    (if (> a b) result
        (if (include-a? a)
            (iter (next a) (combiner result (term a)))
            (iter (next a) result))))
  (iter a null-value))

(define (sum-square-primes a b)
  (define (square n) (* n n))
  (filtered-accumulate prime? + 0 square a inc b))

(present-compare sum-square-primes
                 '((1 5) 38)
                 '((1000 1020) 3082611))

(define (product-of-coprimes n)
  (define (coprime? a)
    (= 1 (gcd a n)))
  (filtered-accumulate coprime? * 1 identity 2 inc n))

(present-compare product-of-coprimes
                 '((12) 385)
                 '((11) 3628800))

(--end-- "1.33")

