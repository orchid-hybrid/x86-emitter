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
