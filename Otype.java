public class Otype {

    // Singleton instance
    private static Otype instance;

    // Private constructor to prevent instantiation
    private Otype() {}

    // Return the singleton instance of the class
    public static Otype getInstance() {
        if (instance == null) {
            instance = new Otype();
        }
        return instance;
    }

    //Execute an O-type instruction for the input state.

    public void executeO(Stage stage, int opcode) {
        if (opcode == 6) {  // halt instruction
            stage.setHalt();
        } else if (opcode == 7) {  // noop instruction
            // does nothing.
        }
    }
}
