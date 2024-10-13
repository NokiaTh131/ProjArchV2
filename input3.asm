x0     beq 0 0 main     ; Branch to main
x12     noop             ; function argument 1 (n)
x13     noop             ; function argument 2 (r)
x10     noop             ; return value (for the combination result)
x5     noop             ; temp 0
x2     noop             ; stack pointer
x6     noop             ; temp 1
x1     noop             ; return address
pos1   .fill 1          ; Constant 1
pos4   .fill 4          ; Constant 4 (for stack increment)
neg4   .fill -4         ; Constant -4 (for stack decrement)
cnrAdd .fill cnr        ; Address of the Cnr function
n      .fill 7          ; n = 7 (initial value for n)
r      .fill 3          ; r = 3 (initial value for r)
main    lw 0 x2 stAdd      ; x2 = stack address
        lw 0 x12 n           ; x12 = n
        lw 0 x13 r           ; x13 = r
        lw 0 x5 cnrAdd      ; Load the address of Cnr into x5
        jalr x5 x1          ; Jump to Cnr function
        halt                ; End of program
cnr     beq 0 x13 basCnr     ; if r == 0, go to basCnr (base case)
        beq x12 x13 basCnr    ; if n == r, go to basCnr (base case)
        lw 0 x5 cnrAdd      ; Load the address of Cnr into x5 (for recursion)
        lw 0 x6 pos4        ; Load 4 into x6 
        add x6 x2 x2        ; x2 += 4 (allocate stack x2ace)
        sw x2 x1 -4         ; Store return address (x1) at x2-4
        sw x2 x13 -3         ; Store r at x2-3
        sw x2 x12 -2         ; Store n at x2-2
        nand 0 0 x6         ; Prepare to decrement n (with negation)
        add x6 x12 x12        ; n -= 1
        jalr x5 x1          ; Recursive call: Cnr(n-1, r)
        sw x2 x10 -1         ; Store result of Cnr(n-1, r) at x2-1
        nand 0 0 x6         ; Prepare to decrement r
        add x6 x13 x13        ; r -= 1
        jalr x5 x1          ; Recursive call: Cnr(n-1, r-1)
        lw x2 x12 -1         ; Load Cnr(n-1, r) from x2-1
        add x12 x10 x10        ; Add the two results (Cnr(n-1,r) + Cnr(n-1,r-1))
        lw x2 x12 -2         ; Restore n from x2-2
        lw x2 x13 -3         ; Restore r from x2-3
        lw x2 x1 -4         ; Restore return address from x2-4
        lw 0 x6 neg4        ; Load -4 for stack decrement
        add x6 x2 x2        ; x2 -= 4 (deallocate stack x2ace)
        jalr x1 0           ; Return to caller
basCnr  lw 0 x10 pos1        ; Base case: set return value x10 = 1
        jalr x1 0           ; Return to caller
stack   noop                ; Placeholder for the stack
stAdd .fill   stack      ; Address of the stack