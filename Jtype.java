public class Jtype {

    // Singleton instance
    private static Jtype instance;

    // Private constructor to prevent instantiation
    private Jtype() {}

    // Static method to return the singleton instance
    public static Jtype getInstance() {
        if (instance == null) {
            instance = new Jtype();
        }
        return instance;
    }

    public void executeJ(Stage stage, int opcode, int rs, int rd) {
        int[] reg = stage.getRegister();

        if (opcode == 5) {  // JALR instruction
            if (rd != 0) {
                reg[rd] = stage.getPc() + 1;
            }
            stage.setNextPc(reg[rs]);
        }
    }
}
