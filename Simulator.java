import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Simulator {
    public static void main(String[] args) {
        //ccheck invalid number of args
        if (args.length != 1) {
            System.out.println("java Simulator <file_name>");
            System.exit(1);
        }
        String filename = args[0];
        File inputFile = new File(filename);
        boolean isExist = inputFile.exists();
        //if file is doesn't exist do exit(1)
        if (!isExist) {
            System.out.println(filename + "' doesn't exist.");
            System.exit(1);
        }
        Stage stage = new Stage();
        int[] memory = stage.getMemory();
        int pc = 0;
        //read file each line to set arra memmmor to be address of each instruction Then do simulate   
        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
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
