public class Rtype {
    // Singleton instance
    private static Rtype instance;

    // Private constructor to prevent instantiation
    private Rtype() {}

    // Static method to return the singleton instance
    public static Rtype getInstance() {
        if (instance == null) {
            instance = new Rtype();
        }
        return instance;
    }

    // Method to execute R-type instructions based on opcode
    public void executeR(Stage stage, int opcode, int rs, int rt, int rd) {
        int[] reg = stage.getRegister();

        // No operation if destination register is 0
        if (rd == 0) {
            return;
        }

        // Opcode 0: Addition (rd = rs + rt)
        if (opcode == 0) {
            reg[rd] = reg[rs] + reg[rt];
        }
        // Opcode 1: NOR (rd = ~(rs & rt))
        else if (opcode == 1) {
            reg[rd] = ~(reg[rs] & reg[rt]);
        }
    }
}
