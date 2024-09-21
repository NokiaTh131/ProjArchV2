To run have 2 step
Type these command in terminal

1.) gcc -o assembler assembler.c

2.) ./assembler inputfilename outputfilename

Add this in Inputfile

         lw       0        1        7      load reg1 with 5 (uses symbolic address)

         lw       1        2        3        load reg2 with -1 (uses numeric address)
        
start   add     1        2        1        decrement reg1

        beq     0        1        2        goto end of program when reg1==0
        
        beq     0        0        start    go back to the beginning of the loop
        
        noop
        
done    halt                                  end of program

five    .fill      5

neg1    .fill      -1

stAddr  .fill      start                        will contain the address of start
