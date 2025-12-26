#lang eopl
;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;
;Interfaz: Definición de funciones para sumas anidadas con representación utilizando listas

;suma-anidada ::= <valor> <numero>
;             ::=(<suma> suma-anidada suma-anidada)

;constructores
(define suma
  (lambda (x y)
    (list 'suma x y)))

(define valor
  (lambda (x)
    (list 'valor x)))
  
;predicados
(define suma?
  (lambda (l)
    (eqv? (car l) 'suma)))

;Una mejor verificación de suma:
; (define suma?
;   (lambda (l)
;     (if (and (eqv? (car l) 'valor) (number? (cadr l))) #t
;         (if (eqv? (car l) 'suma)
;             (and (suma? (cadr l))
;                  (suma? (caddr l)))
;             #f))))


(define valor?
  (lambda (l)
    (eqv? (car l) 'valor)))

;extractores
;estos extractores pueden tener validaciones para revisar si efectivamente
;la expresión es suma o un valor
(define suma->valDer
  (lambda (l)
    (caddr l)))

(define suma->valIzq
  (lambda (l)
    (cadr l)))

(define valor->numero
  (lambda (l)
    (cadr l)))


;código cliente

(define a
  (suma (valor 4)        
        (suma (valor 5) (valor 6) )
        ))

(define suma-anidada
  (lambda (exp)
    (if (valor? exp)
        (valor->numero exp)
        (+ (suma-anidada (suma->valIzq exp))
           (suma-anidada (suma->valDer exp))
           )
        )
    )
  )


(suma-anidada a)


;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;
;Interfaz: Definición de funciones para sumas anidadas con representación utilizando procedimientos

;suma-anidada ::= <valor> <numero>
;             ::=(<suma> suma-anidada suma-anidada)

;constructores
(define sumaP
  (lambda (izq der)
    (lambda (signal)
      (cond
        [(= signal 1) 'suma]
        [(= signal 2) (+ (sumaXP izq) (sumaXP der))] ;otra forma [(= signal 2) (+ (izq 2) (der 2))]
        [(= signal 3) izq]
        [(= signal 4) der]))))


(define valorP
  (lambda (x)
    (lambda (signal)
      (cond
        [(= signal 1) 'valor]
        [(= signal 2) x]))))
 
;predicados
(define sumaP?
  (lambda (proc)
    (eqv? (proc 1) 'suma)))

(define valorP?
  (lambda (proc)
    (eqv? (proc 1) 'valor)))

;(sumaP 3 5)
;((sumaP 3 5) 1)
;((sumaP 3 5) 2)
;(valorP? (sumaP 3 5) )




;extractores
(define sumaP->valDer
  (lambda (proc)
    (proc 4)))

(define sumaP->valIzq
  (lambda (proc)
    (proc 3)))

(define valorP->numero
  (lambda (proc)
    (proc 2)))

;(define p (sumaP (valorP 3) (valorP 5) ))
;(valorP? p)
;(sumaP? p)
;(sumaP->valDer p)
;(sumaP? (sumaP->valDer p))
;(valorP? (sumaP->valDer p))


;código cliente

(define suma-anidadaP
  (lambda (exp)
    (if (valorP? exp)
        (valorP->numero exp)
        (+ (suma-anidadaP (sumaP->valIzq exp))
           (suma-anidadaP (sumaP->valDer exp))
           )
        )
    )
  )


(define sumaXP
  (lambda (exp)
    (exp 2)))




(define aP
  (sumaP (valorP 4)        
        (sumaP (valorP 5) (valorP 6) )
        ))

;dos posibles ejecuciones:
(suma-anidadaP aP)
(sumaXP aP)