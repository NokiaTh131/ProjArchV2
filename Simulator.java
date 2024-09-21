import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Simulator {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("java Simulator <file_name>");
            System.exit(1);
        }
        String filename = args[0];
        File inputFile = new File(filename);
        boolean isExist = inputFile.exists();
        if (!isExist) {
            System.out.println(filename + "' doesn't exist.");
            System.exit(1);
        }
        Stage stage = new Stage();
        int[] memory = stage.getMemory();
        int pc = 0;
        try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                try {
                    memory[pc] = Integer.parseInt(line.trim());
                } catch (NumberFormatException e) {
                    System.out.println(e.getMessage());
                    System.exit(1);
                }
                pc++;
            }
            stage.setInstructionCount(pc);
        } catch (IOException e) {
            e.printStackTrace();
        }
            stage.simulate();
            System.exit(0);
        }
        
}
