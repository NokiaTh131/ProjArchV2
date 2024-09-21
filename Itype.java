public class Itype {
    // Singleton instance
    private static Itype instance;

    // Private constructor to prevent instantiation
    private Itype() {}

    // Static method to return the singleton instance
    public static Itype getInstance() {
        if (instance == null) {
            instance = new Itype();
        }
        return instance;
    }

    // Method to sign-extend a 16-bit number to a 32-bit number
    private int signExtend(int num) {
        if ((num & (1 << 15)) != 0) {
            num -= (1 << 16);
        }
        return num;
    }

    // Method to execute I-type instructions based on opcode
    public void executeI(Stage stage, int opcode, int rs, int rt, int offset) {
        int[] reg = stage.getRegister();
        int[] mem = stage.getMemory();
        int offsetField = signExtend(offset);
        int memAddress = offsetField + reg[rs];

        // Load instruction (opcode == 2)
        if (opcode == 2) {
            if (rt == 0) {
                return;
            }
            reg[rt] = mem[memAddress];
        }
        // Store instruction (opcode == 3)
        else if (opcode == 3) {
            mem[memAddress] = reg[rt];
        }
        // Branch if equal (opcode == 4)
        else if (opcode == 4) {
            if (reg[rs] == reg[rt]) {
                int newPc = stage.getPc() + 1 + offsetField;
                stage.setNextPc(newPc);
            }
        }
    }
}
