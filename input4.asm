x0     beq 0 0 main     ; Bx1nch to main
x12     noop             ; function argument 1 (n)
x13     noop             ; function argument 2 (r)
x10     noop             ; return value (for the combination result)
x5     noop             ; temp 0
x2     noop             ; stack pointer
x6     noop             ; temp 1
x1     noop             ; return address
pos1   .fill 1          ; Constant 1
pos3   .fill 3          ; Constant 3 (for stack increment)
neg3   .fill -3         ; Constant -3 (for stack decrement)
pnrAdd .fill pnr        ; Address of the Cnr function
n      .fill 7          ; initial value for n
r      .fill 3          ; initial value for r
mulAdd .fill  mult      ; Address of the mult
main    lw 0 x2 stAddr      ; x2 = stack address
        lw 0 x12 n           ; x12 = n
        lw 0 x13 r           ; x13 = r
        lw 0 x5 pnrAdd      ; Load the address of Cnr into x5
        jalr x5 x1          ; Jump to Cnr function
        halt                ; End of progx1m
pnr     beq 0 x13 bax2nr     ; if r == 0, go to bax2nr (base case)
        lw 0 x5 pnrAdd      ; Load the address of Pnr into x5 (for recursion)
        lw 0 x6 pos3
        add x6 x2 x2        ; x2 += 4 (allocate stack x2ace)///
        sw x2 x1 -3         ; Store return address (x1) at x2-4
        sw x2 x13 -2         ; Store r at x2-3
        sw x2 x12 -1         ; Store n at x2-2
        nand 0 0 x6         ; Prepare to decrement n (with negation)
        beq 0 x12 1
        add x6 x12 x12        ; n -= 1///
        add x6 x13 x13        ; r -= 1///
        jalr x5 x1          ; Recursive call: Pnr(n-1, r-1)
        lw 0 x5 mulAdd
        lw x2 x12 -1         ; Load n from x2-2
        lw x2 x13 -2         ; Restore r from x2-3
        jalr x5 x1        ; (n * Pnr(n-1,r-1))///change this to multiply
        lw x2 x12 -1
        lw x2 x1 -3         ; Restore return address from x2-4
        lw 0 x6 neg3        ; Load -3 for stack decrement
        add x6 x2 x2        ; x2 -= 3 (deallocate stack x2ace)////
        jalr x1 0           ; Return to caller
bax2nr  lw 0 x10 pos1        ; Base case: set return value x10 = 1
        jalr x1 0           ; Return to caller
mult    add 0 0 x5       ; Initialize x5 to 0 (this will hold the result)
        beq x12 0 done  ; If x12 == 0, return (multiplication by 0 results in 0)
mulL add x10 x5 x5      ; (x5 = x5 + x12)
        nand 0 0 x6       ; Decrement x12 (we use nand to negate, then add 1)
        add x12 x6 x12     ; x12 = x12 - 1 -> n-=1
        beq x12 0 done  ; If x12 == 0, we're done
        beq 0 0 mulL   ; Repeat the loop
done    add 0 x5 x10       ; Move the result from x5 to x10 (x10 = x5)
        jalr x1 0          ; Return to caller
stack   noop                ; Placeholder for the stack
stAddr .fill   stack      ; Address of the stack