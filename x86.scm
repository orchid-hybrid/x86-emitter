;; http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html

(define x86-registers
  ;; page 69,70
  ;; these are quadword registers
  '(rax rbx rcx rdx
    rdi rsi rbp rsp
    r8 r9 r10 r11
    r12 r13 r14 r15))
(define (x86-register? t)
  (and (symbol? t) (member t x86-registers)))

(define x86-valid-moves
  ;; page 157
  ;; mov Y,X is valid if (X Y) is in this table
  '((location register)
    (register register)
    (immediate register)
    (immediate location)))

;; Operand:
;; Immediate (number)
;; Memory Location
;; General Purpose Registers

;; Instructions:
;; mov
;; push pop
;; call ret
;; add sub mul div inc dec
;; and or xor not
;; test cmp
;; jmp
;; je/jz jne/jnz
;; jg/jnle jge/jnl jl/jnge jle/jng

(define x86-instructions
  '((mov (operand operand))
    (push (operand)) (pop (operand))
    (call (label)) (ret ())
    ))

(define (x86-emit program)
  ;; A 'program' is a list of 3 things: the data section,
  ;; bss, then a list of instructions and labels.
  ;; There should be a __start label.
  (let* ((data (first program))
         (bss (second program))
         (instructions (third program))
         (vars '()) ;; TODO
         (labels (filter symbol? instructions)))
    (if (not (member '__start labels))
        (error "Program has no __start label")
        (for-each (lambda (inst) (x86-emit-instruction vars labels inst))
                  instructions))))

(define x86-indentation "    ")

(define (x86-emit-instruction variables labels instruction)
  ;; TODO: check that mov's are valid against the mov table
  ;; TODO: check 'operand' type is a register or a variable from bss/data or a label from the program
  (cond ((symbol? instruction)
         (display instruction) (display ":") (newline))
        ((and (pair? instruction)
              (assoc (car instruction) x86-instructions)) =>
         (lambda (result)
           (let ((types (second result)))
             (if (not (= (length types) (length (cdr instruction))))
                 (error "Instruction used with wrong number of operands: " instruction)
                 (begin
                   (display x86-indentation)
                   (display (car instruction))
                   (display " ")
                   (let loop ((operands (cdr instruction))
                              (types types))
                     (if (null? operands)
                         #f
                         (begin
                           (case (car types)
                             ((operand)
                              (if (list? (car operands))
                                  (begin (display "[")
                                         (display (first (car operands)))
                                         (display "]"))
                                  (display (car operands))))
                             ((label) (display (car operands)))
                             (else (error "Unknown operand type: " t)))))
                     (if (null? (cdr operands))
                         #f
                         (begin
                           (display ",")
                           (loop (cdr operands)
                                 (cdr types)))))
                   (newline))))))
        (else (error "Invalid/unknown instruction: " instruction))))
