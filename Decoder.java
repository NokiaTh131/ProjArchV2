
public class Decoder {

    public Decoder() {
    }

    public static final int OPCODE_ADD = 0b000;
    public static final int OPCODE_NAND = 0b001;
    public static final int OPCODE_LW = 0b010;
    public static final int OPCODE_SW = 0b011;
    public static final int OPCODE_BEQ = 0b100;
    public static final int OPCODE_JALR = 0b101;
    public static final int OPCODE_HALT = 0b110;
    public static final int OPCODE_NOOP = 0b111;

    /**
     * Decodes a raw binary instruction into an Instruction object.
     * 
     * @param instruction The raw binary instruction.
     * @return Decoded Instruction object.
     */
    public void decode(Stage stage) {
        int instruction = stage.getInstruction();
        // Extract opcode (bits 24-22)
        int opcode = (instruction >> 22) & 0b111;
        switch (opcode) {
            case OPCODE_ADD , OPCODE_NAND:
                // R-type: opcode, rs (21-19), rt (18-16), rd (2-0)
                int rsR = (instruction >>> 19) & 0b111;
                int rtR = (instruction >>> 16) & 0b111;
                int rd = instruction & 0b111;
                Rtype.getInstance().executeR(stage, opcode, rsR, rtR, rd);

            case OPCODE_BEQ ,OPCODE_SW ,OPCODE_LW:
                // I-type: opcode, rs (21-19), rt (18-16), offset (15-0)
                int rsI = (instruction >>> 19) & 0b111;
                int rtI = (instruction >>> 16) & 0b111;
                int offset = instruction & 0xFFFF;
                Itype.getInstance().executeI(stage, opcode, rsI, rtI, offset);

            case OPCODE_JALR:
                // J-type: opcode, rs (21-19), rd (18-16)
                int rsJ = (instruction >>> 19) & 0b111;
                int rdJ = (instruction >>> 16) & 0b111;
                Jtype.getInstance().executeJ(stage, opcode, rsJ, rdJ);

            case OPCODE_NOOP,OPCODE_HALT:
                // O-type: opcode only
                Otype.getInstance().executeO(stage, opcode);
        }
    }
}
