#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAXLINELENGTH 1000
#define MAX_LABELS 5000

typedef struct {
    char label[MAXLINELENGTH];
    int address;
} Label;

Label labels[MAX_LABELS];
int labelCount = 0;


int readAndParse(FILE *, char *, char *, char *, char *, char *);
int isNumber(char *);
void decimalToBinary(int num, char *binaryStr);
int binaryToDecimal(const char *binaryStr);
void firstPass(FILE *inFilePtr);
int resolveLabel(char *symbol);

int main(int argc, char *argv[])
{
    char *inFileString, *outFileString;
    FILE *inFilePtr, *outFilePtr;
    char label[MAXLINELENGTH], opcode[MAXLINELENGTH], arg0[MAXLINELENGTH],
            arg1[MAXLINELENGTH], arg2[MAXLINELENGTH];

    if (argc != 3) {
        printf("error: usage: %s <assembly-code-file> <machine-code-file>\n",
            argv[0]);
        exit(1);
    }

    inFileString = argv[1];
    outFileString = argv[2];

    inFilePtr = fopen(inFileString, "r");
    if (inFilePtr == NULL) {
        printf("error in opening %s\n", inFileString);
        exit(1);
    }
    outFilePtr = fopen(outFileString, "w");
    if (outFilePtr == NULL) {
        printf("error in opening %s\n", outFileString);
        exit(1);
    }

    //firstpass for find all symbolic address
    firstPass(inFilePtr);

    rewind(inFilePtr);
    
    int pc = 0;
    while(readAndParse(inFilePtr, label, opcode, arg0, arg1, arg2) ) {
        int machineCode;
        if (!strcmp(opcode, "add") || !strcmp(opcode, "nand")) {
            int opbi = strcmp(opcode, "add") == 0 ? 0 : 1;
            int regA;
            int regB;
            int rd;
            //check isAlpha regB
            if (isalpha(arg1[0])) {
                regB = resolveLabel(arg1);
            } else {
                regB = atoi(arg1);
            }
            //check isAlpha regA
            if (isalpha(arg0[0])) {
                regA = resolveLabel(arg0);
            } else {
                regA = atoi(arg0);
            }
            //check isAlpha rd
            if (isalpha(arg2[0])) {
                rd = resolveLabel(arg2);
            } else {
                rd = atoi(arg2);
            }
            machineCode = (opbi << 22) | (regA << 19) | (regB << 16) | rd;
        }

        else if (!strcmp(opcode, "lw") || !strcmp(opcode, "sw") || !strcmp(opcode, "beq")) {
            int opbi = (!strcmp(opcode, "lw")) ? 2 : (!strcmp(opcode, "sw")) ? 3 : 4;
            int regA;
            int regB;
            int offset;
            //check isAlpha offset
            if (isalpha(arg2[0])) {
                offset = resolveLabel(arg2);
            } else {
                offset = atoi(arg2);
            }
            //check isAlpha regB
            if (isalpha(arg1[0])) {
                regB = resolveLabel(arg1);
            } else {
                regB = atoi(arg1);
            }
            //check isAlpha regA
            if (isalpha(arg0[0])) {
                regA = resolveLabel(arg0);
            } else {
                regA = atoi(arg0);
            }

            if (offset > 32767 || offset < -32768) {
                printf("error offset bit is too much %s\n", arg2);
                exit(1);
            }

            if (isalpha(arg2[0])) {
                if(!strcmp(opcode, "beq")) offset = offset - pc - 1;
            }
            machineCode = (opbi << 22) | (regA << 19) | (regB << 16) | (offset & 0xFFFF);
        }

        else if (!strcmp(opcode, "jalr")) {
            int opbi = 5;
            int regA;
            int regB;
            //check isAlpha regB
            if (isalpha(arg1[0])) {
                regB = resolveLabel(arg1);
            } else {
                regB = atoi(arg1);
            }
            //check isAlpha regA
            if (isalpha(arg0[0])) {
                regA = resolveLabel(arg0);
            } else {
                regA = atoi(arg0);
            }
            machineCode = (opbi << 22) | (regA << 19) | (regB << 16);

        }

        else if (!strcmp(opcode, "halt") || !strcmp(opcode, "noop")) {
            int opbi = (!strcmp(opcode, "halt")) ? 6 : 7;
            machineCode = (opbi << 22);
        }
        else if (!strcmp(opcode, ".fill")) {
            int field;
            if (isalpha(arg0[0])) {
                field = resolveLabel(arg0);
            } else {
                field = atoi(arg0);
            }
            
            machineCode = field ;
            
        }
        else{
            printf("error: unrecognized opcode %s\n", opcode);
            exit(1);
        }
        fprintf(outFilePtr, "%d\n", machineCode);
        pc++;

    }
    printf("Process successful.\n");


    

    return(0);
}

/*
 * Read and parse a line of the assembly-language file.  Fields are returned
 * in label, opcode, arg0, arg1, arg2 (these strings must have memory already
 * allocated to them).
 *
 * Return values:
 *     0 if reached end of file
 *     1 if all went well
 *
 */
int readAndParse(FILE *inFilePtr, char *label, char *opcode, char *arg0,
    char *arg1, char *arg2)
{
    char line[MAXLINELENGTH];
    char *ptr = line;

    /* delete prior values */
    label[0] = opcode[0] = arg0[0] = arg1[0] = arg2[0] = '\0';

    /* read the line from the assembly-language file */
    if (fgets(line, MAXLINELENGTH, inFilePtr) == NULL) {
	/* reached end of file */
        return(0);
    }

    /* is there a label? */
    ptr = line;
    if (sscanf(ptr, "%[^\t\n ]", label)) {
	/* successfully read label; advance pointer over the label */
        ptr += strlen(label);
    }

    /*
     * Parse the rest of the line.  Would be nice to have real regular
     * expressions, but scanf will suffice.
     */
    sscanf(ptr, "%*[\t\n ]%[^\t\n ]%*[\t\n ]%[^\t\n ]%*[\t\n ]%[^\t\n ]%*[\t\n ]%[^\t\n ]",
        opcode, arg0, arg1, arg2);
    return(1);
}

int isNumber(char *string)
{
    /* return 1 if string is a number */
    int i;
    return( (sscanf(string, "%d", &i)) == 1);
}

/*
 * Read and parse a line of the assembly-language file for first time to get symbolic address.
 * and store it in Label[] 
 */
void firstPass(FILE *inFilePtr) {
    char label[MAXLINELENGTH], opcode[MAXLINELENGTH], arg0[MAXLINELENGTH], arg1[MAXLINELENGTH], arg2[MAXLINELENGTH];
    int address = 0;

    while (readAndParse(inFilePtr, label, opcode, arg0, arg1, arg2)) {
        // Store label addresses
        if (strlen(label) > 0) {
            
            for (int i = 0; i < labelCount; i++) {
                if (strcmp(labels[i].label, label) == 0) {
                    printf("error Duplicate label '%s' found at address %d\n", label, address);
                    exit(1);
                    return;
                }
            }
            strcpy(labels[labelCount].label, label);
            labels[labelCount].address = address;
            if (!isalpha(labels[labelCount].label[0])) {
                printf("error: label '%s' must start with a letter\n", label);
                exit(1);
                return;
            }
            if(strlen(labels[labelCount].label) > 6) {
                printf("error label '%s' too long %d\n", label, address);
                exit(1);
                return;
            }
            printf("Label found: %s, Address: %d\n", labels[labelCount].label, labels[labelCount].address);
            labelCount++;
        }
        // Increment address for the next instruction
        address ++;
    }
}

/*
 * this function will resolve label by check label in labels[] 
 * if have symbol from output return address 
 * else print error exit(1)  
 * 
 */
int resolveLabel(char *symbol) {
    for (int i = 0; i < labelCount; i++) {
        if (strcmp(labels[i].label, symbol) == 0) {
            return labels[i].address;
        }
        
    }
    // Handle error: label not found
    printf("Error: Undefined label %s\n", symbol);
    exit(1);
    return -36769; 
}
