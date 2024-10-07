x0     beq 0 0 main     ; Branch to main
a1     noop             ; function argument 1 (n)
a2     noop             ; function argument 2 (r)
a0     noop             ; return value (for the combination result)
t0     noop             ; temp 0
sp     noop             ; stack pointer
t1     noop             ; temp 1
ra     noop             ; return address
pos1   .fill 1          ; Constant 1
pos3   .fill 3          ; Constant 3 (for stack increment)
neg3   .fill -3         ; Constant -3 (for stack decrement)
pnrAdr .fill pnr        ; Address of the Cnr function
n      .fill 2          ; initial value for n
r      .fill 7          ; initial value for r
mulAddr .fill  mult      ; Address of the mult
main    lw 0 sp spAddr      ; sp = stack address
        lw 0 a1 n           ; a1 = n
        lw 0 a2 r           ; a2 = r
        lw 0 t0 pnrAdr      ; Load the address of Cnr into t0
        jalr t0 ra          ; Jump to Cnr function
        halt                ; End of program
pnr     beq 0 a2 basPnr     ; if r == 0, go to basPnr (base case)
        lw 0 t0 pnrAdr      ; Load the address of Pnr into t0 (for recursion)
        lw 0 t1 pos3
        add t1 sp sp        ; sp += 4 (allocate stack space)///
        sw sp ra -3         ; Store return address (ra) at sp-4
        sw sp a2 -2         ; Store r at sp-3
        sw sp a1 -1         ; Store n at sp-2
        nand 0 0 t1         ; Prepare to decrement n (with negation)
        beq 0 a1 1
        add t1 a1 a1        ; n -= 1///
        add t1 a2 a2        ; r -= 1///
        jalr t0 ra          ; Recursive call: Pnr(n-1, r-1)
        lw 0 t0 mulAddr
        lw sp a1 -1         ; Load n from sp-2
        lw sp a2 -2         ; Restore r from sp-3
        jalr t0 ra        ; (n * Pnr(n-1,r-1))///change this to multiply
        lw sp a1 -1
        lw sp ra -3         ; Restore return address from sp-4
        lw 0 t1 neg3        ; Load -3 for stack decrement
        add t1 sp sp        ; sp -= 3 (deallocate stack space)////
        jalr ra 0           ; Return to caller
basPnr  lw 0 a0 pos1        ; Base case: set return value a0 = 1
        jalr ra 0           ; Return to caller
mult    add 0 0 t0       ; Initialize t0 to 0 (this will hold the result)
        beq a1 0 doneMult  ; If a1 == 0, return (multiplication by 0 results in 0)
multLoop add a0 t0 t0      ; (t0 = t0 + a1)
        nand 0 0 t1       ; Decrement a1 (we use nand to negate, then add 1)
        add a1 t1 a1     ; a1 = a1 - 1 -> n-=1
        beq a1 0 doneMult  ; If a1 == 0, we're done
        beq 0 0 multLoop   ; Repeat the loop
doneMult add 0 t0 a0       ; Move the result from t0 to a0 (a0 = t0)
        jalr ra 0          ; Return to caller
stack   noop                ; Placeholder for the stack
spAddr .fill   stack      ; Address of the stack