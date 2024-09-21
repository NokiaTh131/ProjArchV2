import java.util.Base64.Decoder;

public class Stage {
    private final int MEMORY_SIZE = 65536;
    private final int REGISTER_SIZE = 8;
    private final int HALT_INSTRUCTION = 0x1C00000;

    private final int[] memory;      // Memory array
    private final int[] register;    // Register array
    private int pc;                  // Program counter
    private int nextPc;              // Next program counter
    private int stepCount;           // Number of steps
    private final Decoder decoder;   // Instruction decoder
    private int instructionCount;    // Instruction count to display
    private boolean isLast;          // is last execute
    private final StringBuilder sb;  // For printing state details

    //Constructor
    public Stage() {
        memory = new int[MEMORY_SIZE];
        register = new int[REGISTER_SIZE];
        pc = 0;
        nextPc = 0;
        isLast = false;
        stepCount = 0;
        decoder = Decoder.decoderInstance();
        sb = new StringBuilder();
    }

    //execute
    public void iterate() {
        nextPc = (pc + 1) % MEMORY_SIZE;
        decoder.decode(this);
        register[0] = 0;  //reg[0] always be 0
        pc = nextPc;
        stepCount++;
}

    //simulator
    public void simulate() {
        printState();
        while (!isLast) {
            iterate();
        }
    }

    //get instruction
    public int getInstruction() {
        if (pc >= 0 && pc < MEMORY_SIZE) {
            return memory[pc];
        } else {
            return HALT_INSTRUCTION;  // Halt on invalid memory access
        }
    }

    //get memory
    public int[] getMemory() {
        return memory;
    }

    //get redister
    public int[] getRegister() {
        return register;
    }

    //get current pc
    public int getPc() {
        return pc;
    }

    //set next pc
    public void setNextPc(int newPc) {
        nextPc = newPc;
    }

    //set isLast to true
    public void setlast() {
        isLast = true;
    }

    // Sets the instruction count to print.
    public void setInstructionCount(int newInstructionCount) {
        instructionCount = newInstructionCount;
    }

    
    //print state
    public void printState() {
        sb.setLength(0); // Clear stringBuilder
        
        //topic fot last state
        if (isLast) {
            sb.append("machine halted\n")
              .append("total of ").append(stepCount).append(" instructions executed\n")
              .append("final state of machine:\n");
        }

        sb.append("@@@\nstate:\n")
          .append("\tpc ").append(pc).append('\n')
          .append("\tmemory:\n");

        //memories set
        for (int i = 0; i < instructionCount; i++) {
            sb.append("\t\tmem[").append(i).append("] ").append(memory[i]).append('\n');
        }


        //registers set
        sb.append("\tregisters:\n");
        for (int i = 0; i < register.length; i++) {
            sb.append("\t\treg[").append(i).append("] ").append(register[i]).append('\n');
        }

        sb.append("end state\n\n");
        System.out.println(sb);
    }
}
