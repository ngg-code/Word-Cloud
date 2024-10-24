#lang racket
(require csc151)
(require 2htdp/image)

;;; word-cloud.rkt
;;;   A word-cloud, created for MP7
;;; The word cloud transformation begins by taking a valid word file and converting it into a list of strings. This list is then processed to count the frequency
;;; of each string, eliminating common words like "a" and "the" using a hash table for efficiency. The resulting hash table is transformed into a list of pairs
;;; using the 'counted' procedure, where each pair consists of a string and its corresponding frequency. Next, the list is sorted in descending order of usage
;;; frequency using the 'sorted' procedure. The top 50 frequently used words are selected using the 'select' procedure. These high-frequency words are then
;;; converted into a text image of a given size with randomly assigned colors using the 'change-image' procedure. Finally, the 'stack' and 'sequence' procedures
;;; are utilized to construct the word cloud, incorporating the processed words into the visual representation.
;;;  
;;;   CSC-151-01 2023Fa.
;;;
;;; Author: Nahom gebreegziabher
;;; Date submitted: 2023/19/11
;;;
;;; Acknowledgements:csc151 website, dr,racket referece website, Samuel Reblsky (help me with some errors including errorr in sample image)



;;; (count lst words) -> void
;;;  lst : list of words
;;;  words : hash?
;;; Counts the occurrences of words in the given list and make a hash table of words and their frequence.
(define count
  (lambda (lst words)
    (if (null? lst)
        void
        (let ((word (string-upcase (car lst))))
          (if (or (equal? word "A")
                  (equal? word "AN")
                  (equal? word "THE")
                  (equal? word "IS")
                  (equal? word "ARE")
                  (equal? word "WAS")
                  (equal? word "To")
                  (equal? word "BY")
                  (equal? word "S")
                  (equal? word "IT")
                  (equal? word "E")
                  (equal? word "IN")
                  (equal? word "OR"))
              (count (cdr lst) words)
              (if (hash-has-key? words word)
                  (o (hash-update! words word add1) (count (cdr lst) words))
                  (o (hash-set! words word 1) (count (cdr lst) words))))))))
;;; (counted lst words) -> list
;;;  lst : list of words
;;;  words : hash?
;;; Returns a list of pairs representing word frequencies of the given list(lst) using hash-table.
(define counted
  (lambda (lst words)
    (let ([call (count lst words)])
      (hash->list words))))

;;; (sort/helper pairs) -> list?
;;;  pairs : list? of pairs?
;;; Helper function that return list of frequences to sort a list of pairs for further processing.
(define sort/helper
  (lambda (pairs)
    (if (null? pairs)
        null
        (if (and (string? (caar pairs)) (pair? (car pairs)))
            (cons (cdr (car pairs)) (sort/helper (cdr pairs)))
            (cons (car (car pairs)) (sort/helper (cdr pairs)))))))

;;; (check-list? value lst) -> boolean?
;;;   value : any/c
;;;   lst : list?
;;; Checks if a given value is present in the list.
(define check-list?
  (lambda (value lst)
    (if (null? lst)
        #f
        (if (equal? (car lst) value)
            #t
            (check-list? value (cdr lst))))))

;;; (single-words list) -> list?
;;;  list : list? of pairs?
;;; Extracts the first element from each pair of the given list.
(define single-words
  (lambda (list)
    (if (null? list)
        null
        (cons (car (car list)) (single-words (cdr list))))))

;;; (sorted lst words) -> list?
;;;  lst : list?
;;;  words : hash?
;;; Returns a sorted list of word frequencies in descending order.
(define sorted
  (lambda (lst words)
    (sort (sort/helper (counted lst words))  >)))

;;; (top-50 list words) -> list?
;;;  list : list?
;;;  words : hash?
;;; Returns the top 50 words from the given sorted list of word frequencies.
(define top-50
  (lambda (list words)
    (let ((sorted (sorted list words)))
    (if (<= (length sorted) 50)
        (single-word list words)
        (top-50/helper sorted 0)))))

;;; (top-50/helper list n) -> list?
;;;  list : list?
;;;  n : number?
;;; Helper function to retrieve the top 50 words from a sorted list.
(define top-50/helper
  (lambda (list n)
    (if (or (null? list) (not (< n 50)))
        null
        (cons (car list) (top-50/helper (cdr list) (+ n 1))))))

;; (select lists words) -> list?
;;;  lists : list?
;;;  words : hash?
;;; Selects top-50 words in the list.
(define select
  (lambda (lists words)
    (select/helper (single-word lists words) (top-50 lists words) words)))

;;; (select/helper lists lst words) -> list?
;;;  lists : list?
;;;  lst : list?
;;;  words : hash?
;;; Helper function to select lists based on criteria from the given list.
(define select/helper
  (lambda (lists lst words)
    (if (null? lists)
        null
        (if (check-list? (hash-ref words (car lists)) lst)
            (cons (car lists) (select/helper (cdr lists) lst words))
            (select/helper (cdr lists) lst words)))))

;;; (single-word list words) -> list?
;;;  list : list?
;;;  words : hash?
;;; Extracts the first element from each pair in the given list.
(define single-word
  (lambda (list words)
    (single-words (counted list words))))


;;; (random-colors n) -> string?
;;;  n : number?
;;; Generates a random color string based on the given number.
(define random-colors
  (lambda (n)
    (let ([randoms (random n)])
      (cond [(equal? randoms 0) "yellow"]
            [(equal? randoms 1) "red"]
            [(equal? randoms 2) "blue"]
            [(equal? randoms 3) "green"]
            [(equal? randoms 4) "purple"]
            [(equal? randoms 5) "pink"]))))
;;; (change-image lst) -> image?
;;;  lst : list?
;;; Changes the given list of words into an image representation.
(define change-image
  (lambda (lst words)
    (change-image/helper lst 10 words)))

;;; (change-image/helper lst n) -> list?
;;;  lst : list?
;;;  n : number?
;;; Helper function to create an image representation from a list of words with varying font sizes and colors.
(define change-image/helper
  (lambda (lst n words)
    (if (null? lst)
        null
        (if (> n 30)
            (if (>= n 9)
                (cons (text/font (car lst) (floor (/ (hash-ref words (car lst)) 40)) (random-colors 5) "Gill Sans" 'roman 'normal 'bold #f)
                      (change-image/helper (cdr lst) (- n 20) words))
                void)
            (cons (text/font (car lst) (floor (/ (hash-ref words (car lst)) 40)) (random-colors 5) "Gill Sans" 'swiss 'normal 'bold #f)
                  (change-image/helper (cdr lst) (+ n 1) words))))))

;;---------------------------------------THIS PROCEDURE IS TAKEN FROM CODES I WROTE FOR MINI-PROJECT-4-------------------------------------------
;;; (stack images) -> image?
;;;   images: A list of images to be stacked.
;;;  Returns a single image created by stacking the provided images vertically.
;(define list-image (lambda (lst) (and (list? lst) (image? lst
(define stack
  (lambda (image)
    (if (null?  image)
        (square 0 0 "white") 
        (if (image? (car image))
            (above (car image) (stack (cdr image)))
            (stack (cdr image))))))

;;---------------------------------------THIS PROCEDURE IS TAKEN FROM CODES I WROTE FOR MINI-PROJECT-4-------------------------------------------
;;; (sequence images) -> image?
;;;   images : list of shape-params?
;;; Applies the 'above' operation to a list of shape-params, creating a vertically
;;; stacked image from the provided shape parameters. Returns the resulting image.
(define sequence
  (lambda (image)
    (if (null? image)
        (square 0 0 "white")
        (if (image? (car image))
            (beside (car image) (sequence (cdr image)))
            (sequence (car image))))))



;;---------------------------------------THIS PROCEDURE IS TAKEN FROM CODES I WROTE FOR MINI-PROJECT-4-------------------------------------------
;;; (stack-then-sequence staff) -> image?
;;;   staff: A list of images or lists of images.
;;; Returns a single image created by stacking or sequencing the images in 'staff' based on their type.
(define stack-then-sequence
  (lambda (staff)
    (if (null? staff)
        (square 0 0 "white")
        (if (image? (car staff))
            (sequence(list (car staff) (stack-then-sequence (cdr staff))))
            (sequence (list (stack (car staff)) (stack-then-sequence (cdr staff))))))))

;;---------------------------------------THIS PROCEDURE IS TAKEN FROM CODES I WROTE FOR MINI-PROJECT-4-------------------------------------------
;;; (sequence-then-stack staff) -> image?
;;;   staff: A list of images or lists of images.
;;; Returns a single image created by sequencing or stacking the images in 'staff' based on their type.
(define sequence-then-stack
  (lambda (staff)
    (if (null? staff)
        (square 0 0 "white")
        (if (image? (car staff))
            (stack (list (car staff) (sequence-then-stack (cdr staff))))
            (stack (list (sequence (car staff)) (sequence-then-stack (cdr staff))))))))

;;---------------------------------------THIS PROCEDURE IS TAKEN FROM CODES I WROTE FOR MINI-PROJECT-4-------------------------------------------
;;; (stacked-ss staff) -> image?
;;;   staff: A list of images or lists of images.
;;; Returns a single image created by first sequencing or stacking images in 'staff' based on their type and then stacking the result.
(define stacked-ss
  (lambda (staff)
    (if (null? staff)
        (square 0 0"white")
        (if (image? (car staff))
            (stack (list (car staff) (stacked-ss (cdr staff))))
            (stack (list (stack-then-sequence (car staff)) (stacked-ss (cdr staff))))))))

;;---------------------------------------THIS PROCEDURE IS TAKEN FROM CODES I WROTE FOR MINI-PROJECT-4-------------------------------------------
;;; (sequence-ss staff) -> image?
;;;   staff: A list of images or lists of images.
;;; Returns a single image created by first stacking or sequencing images in 'staff' based on their type and then sequencing the result.
(define sequence-ss
  (lambda (staff)
    (if (null? staff)
        (square 0 0"white")
        (if (image? (car staff))
            (sequence (list (car staff) (stacked-ss (cdr staff))))
            (sequence (list (sequence-then-stack (car staff)) (sequence-ss (cdr staff))))))))


;;; (word-cloud file) -> image?
;;;  file : amy valid text file
;;; create word cloud using the most frequently used words in a file
(define word-cloud
  (lambda (file)
    (let ([words (make-hash)])
      (sequence-ss (list-of-five (change-image (select (file->words file) words) words ))))))

;;; (list-of-five lst) -> list?
;;;   lst : list?
;;; Divides a given list into sublists of up to five elements each.
(define list-of-five
  (lambda (lst)
    (if (null? lst)
        null
        (if (< (length lst) 5)
            (list lst)
            (cons (take lst 5) (list-of-five (cddr (cdddr lst))))))))

;This image is created by list of top 50 frequently used words in filename.txt.crdownload (from Project Gutenberg. original name "Le Peuple du Pôle" by
;Charles Derennes) and sequence-ss them by changing the list into five sublists.
;(save-image (word-cloud "filename.txt.crdownload") "sample.png")