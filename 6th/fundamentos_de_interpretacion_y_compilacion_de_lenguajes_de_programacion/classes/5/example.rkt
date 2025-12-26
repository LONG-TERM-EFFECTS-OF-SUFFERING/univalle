#lang eopl

(define lexica
'((white-sp
   (whitespace) skip)
  (comment
   ("//" (arbno (not #\newline))) skip)
  (identifier
   (letter (arbno (or letter digit "?"))) symbol)
  (number
   (digit (arbno digit)) number)
  (number
   ("-" digit (arbno digit)) number)))

; Esto debe comentarse ya que los datatypes se definen en gramatica

; (define-datatype declaracion declaracion?
;   (declaracion-compuesta (primera declaracion?)
;                          (segunda declaracion?)
;                          )
;   (declaracion-while (exp expresion?)
;                      (decl declaracion?)
;                      )
;   (declaracion-asignacion (ssss symbol?)
;                           (expr expresion?)
;                           )
;   )
; 
; (define-datatype expresion expresion?
;   (var-exp (id symbol?)
;           )
;   (sum-exp (sum1 expresion?)
;            (sum2 expresion?)
;            ))


(define gramatica
  '(
   (declaracion ("{" declaracion ";" declaracion "}")  declaracion-compuesta)
   (declaracion ("while" expresion "do" declaracion) declaracion-while)
   (declaracion (identifier ":=" expresion)  declaracion-asignacion)
   (expresion (identifier) var-exp)
   (expresion ("(" expresion "+" expresion ")") sum-exp)))


(sllgen:make-define-datatypes lexica gramatica)

(define show-the-datatypes
  (lambda () (sllgen:list-define-datatypes lexica gramatica)))

( define scan&parse
   ( sllgen:make-string-parser
     lexica
     gramatica ) )

(define just-scan
  (sllgen:make-string-scanner lexica gramatica))