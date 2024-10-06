x0     beq 0 0 main     ; Branch to main
a1     noop             ; function argument 1 (n)
a2     noop             ; function argument 2 (r)
a0     noop             ; return value (for the combination result)
t0     noop             ; temp 0
sp     noop             ; stack pointer
t1     noop             ; temp 1
ra     noop             ; return address
pos1   .fill 1          ; Constant 1
pos4   .fill 4          ; Constant 4 (for stack increment)
neg4   .fill -4         ; Constant -4 (for stack decrement)
cnrAdr .fill cnr        ; Address of the Cnr function
n      .fill 7          ; n = 7 (initial value for n)
r      .fill 3          ; r = 3 (initial value for r)
main    lw 0 sp spAddr      ; sp = stack address
        lw 0 a1 n           ; a1 = n
        lw 0 a2 r           ; a2 = r
        lw 0 t0 cnrAdr      ; Load the address of Cnr into t0
        jalr t0 ra          ; Jump to Cnr function
        halt                ; End of program
cnr     beq 0 a2 basCnr     ; if r == 0, go to basCnr (base case)
        beq a1 a2 basCnr    ; if n == r, go to basCnr (base case)
        lw 0 t0 cnrAdr      ; Load the address of Cnr into t0 (for recursion)
        lw 0 t1 pos4
        add sp t1 sp        ; sp += 4 (allocate stack space)///
        sw sp ra -4         ; Store return address (ra) at sp-4
        sw sp a2 -3         ; Store r at sp-3
        sw sp a1 -2         ; Store n at sp-2
        nand t1 0 0         ; Prepare to decrement n (with negation)
        add a1 t1 a1        ; n -= 1///
        jalr t0 ra          ; Recursive call: Cnr(n-1, r)
        sw sp a0 -1         ; Store result of Cnr(n-1, r) at sp-1
        nand t1 0 0         ; Prepare to decrement r
        add a2 t1 a2        ; r -= 1///
        jalr t0 ra          ; Recursive call: Cnr(n-1, r-1)
        lw sp a1 -1         ; Load Cnr(n-1, r) from sp-1
        add a0 a1 a0        ; Add the two results (Cnr(n-1,r) + Cnr(n-1,r-1))///
        lw sp a1 -2         ; Restore n from sp-2
        lw sp a2 -3         ; Restore r from sp-3
        lw sp ra -4         ; Restore return address from sp-4
        lw 0 t1 neg4        ; Load -4 for stack decrement
        add sp t1 sp        ; sp -= 4 (deallocate stack space)////
        jalr ra 0           ; Return to caller
basCnr  lw 0 a0 pos1        ; Base case: set return value a0 = 1
        jalr ra 0           ; Return to caller
stack   noop                ; Placeholder for the stack
spAddr .fill   stack      ; Address of the stack