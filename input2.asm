x0      beq 0 0 main    ; bx1nch to 'main' (register 0 used)
x12      noop            ; function argument 1
x13      noop            ; function argument 2
x10      noop            ; return value
x5      noop            ; temp register 0
x2      noop            ; stack pointer
x6      noop            ; temp register 1
x1      noop            ; return address
pos1    .fill 1       ; constant 1
neg1    .fill -1      ; constant -1
overf  .fill 32768 ; constant 32768 (2^15) for check overflow 16 bit
mulAdr  .fill mul   ; address of 'mul' function
mcand   .fill 32769  ; multiplicand
mplier  .fill 1 ; multiplier
main    lw 0 x2 neg1         ; load x2 with -1
        lw 0 x12 mcand        ; load multiplicand into x12
        lw 0 x13 mplier       ; load multiplier into x13
        lw 0 x5 mulAdr       ; load address of 'mul' function into x5
        jalr x5 x1           ; jump to 'mul' and save return address in x1
        halt                 ; end progx1m
mul     sw 0 x2 x2           ; save x2 onto stack
        sw 0 x1 x1           ; save x1 onto stack
        add x0 x0 x10         ; initialize sum (x10) to 0//
        lw 0 x6 neg1         ; load -1 into x6
        lw 0 x2 overf       ; load 65536 into x2 (2^16)
        lw 0 x5 pos1         ; initialize x5 to 1 (for bit shifting)
muladd  nand x12 x5 x1        ; x1 = ~(x12 & x5)
        beq x6 x1 shAdd      ; if x6 == x1 (i.e., if x1 is -1), skip addition
        add x13 x10 x10         ; sum (x10) += x13 (multiplier)
shAdd   add x5 x5 x5         ; x5 <<= 1 (bit shift left)
        add x13 x13 x13         ; x13 <<= 1 (bit shift left)
        beq x2 x5 mulret     ; if x5 == 2^16, return from 'mul'
        beq 0 0 muladd       ; otherwise, loop back to 'muladd'
mulret  lw 0 x1 x1           ; restore x1 from stack
        lw 0 x2 x2           ; restore x2 from stack
        jalr x1 0            ; return to the calling function