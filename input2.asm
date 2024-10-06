x0      beq 0 0 main    ; branch to 'main' (register 0 used)
a1      noop            ; function argument 1
a2      noop            ; function argument 2
a0      noop            ; return value
t0      noop            ; temp register 0
sp      noop            ; stack pointer
t1      noop            ; temp register 1
ra      noop            ; return address
pos1    .fill 1       ; constant 1
neg1    .fill -1      ; constant -1
c65536  .fill 65536 ; constant 65536 (2^16)
mulAdr  .fill mul   ; address of 'mul' function
mcand   .fill 32766  ; multiplicand
mplier  .fill 10383 ; multiplier
main    lw 0 sp neg1         ; load sp with -1
        lw 0 a1 mcand        ; load multiplicand into a1
        lw 0 a2 mplier       ; load multiplier into a2
        lw 0 t0 mulAdr       ; load address of 'mul' function into t0
        jalr t0 ra           ; jump to 'mul' and save return address in ra
        halt                 ; end program
mul     sw 0 sp sp           ; save sp onto stack
        sw 0 ra ra           ; save ra onto stack
        add x0 x0 a0         ; initialize sum (a0) to 0//
        lw 0 t1 neg1         ; load -1 into t1
        lw 0 sp c65536       ; load 65536 into sp (2^16)
        lw 0 t0 pos1         ; initialize t0 to 1 (for bit shifting)
muladd  nand a1 t0 ra        ; ra = ~(a1 & t0)
        beq t1 ra skAdd      ; if t1 == ra (i.e., if ra is -1), skip addition
        add a2 a0 a0         ; sum (a0) += a2 (multiplier)
skAdd   add t0 t0 t0         ; t0 <<= 1 (bit shift left)
        add a2 a2 a2         ; a2 <<= 1 (bit shift left)
        beq sp t0 mulret     ; if t0 == 2^16, return from 'mul'
        beq 0 0 muladd       ; otherwise, loop back to 'muladd'
mulret  lw 0 ra ra           ; restore ra from stack
        lw 0 sp sp           ; restore sp from stack
        jalr ra 0            ; return to the calling function