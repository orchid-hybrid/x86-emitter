;; rlwrap csi utilities.scm x86.scm x86-test.scm

(define test-1
  (list '()
        '()
        '(__start
          (mov rax rbx)
          (mov rbx (rax))
          bar
          (mov rcx 993434))))

;; #;1> (x86-emit test-1)
;; __start:
;;     mov rax,rbx
;;     mov rbx,[rax]
;; bar:
;;     mov rcx,993434


;; ;;; nasm -g -felf64 printn.asm && ld printn.o -o printn
;; section .data
;; digits: db  "0123456789",10
;; n: dq 420

;; section .text
;;     global _start

(define test-2
  '(((digits db "0123456789" 10)
     (n dq 420))
    ()
    (end
     (xor rdi rdi)
     (mov rax 60)
     (syscall)

     decomp_loop
     (test rax rax)
     (jz print)
     (mov rdx 0)
     (mov rbx 10)
     (div rbx)
     (add rdx digits)
     (push rdx)
     (jmp decomp_loop)

     print
     (mov rdx 1)
     (mov rdi 1)
     
     print_loop
     (pop rax)
     (test rax rax)
     (jz end)
     (mov rsi rax)
     (mov rax 1)
     (syscall)
     (jmp print_loop)
     
     __start
     (mov rax (n))
     (push 0)
     (jmp decomp_loop))))
     
(x86-emit test-2)

(exit)
