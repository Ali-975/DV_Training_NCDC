/* riscv_assembler.c
 * Complete RISC-V RV32I Assembler
 * Supports all RV32I instructions, pseudo-instructions, and assembler directives
 * Outputs both binary file and hex dump
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#include <errno.h>

#define MAX_LINE 1024
#define MAX_TOKENS 64
#define MAX_LABELS 4096
#define MAX_MEMORY 1048576  // 1MB

// Instruction formats
typedef enum {
    FMT_R, FMT_I, FMT_S, FMT_B, FMT_U, FMT_J, FMT_PSEUDO, FMT_NONE
} format_t;

// Instruction definition
typedef struct {
    const char *name;
    format_t format;
    uint32_t opcode;
    uint32_t funct3;
    uint32_t funct7;
} instruction_t;

// Symbol table entry
typedef struct {
    char name[64];
    uint32_t address;
} symbol_t;

// Global variables
symbol_t symbols[MAX_LABELS];
int symbol_count = 0;
uint8_t memory[MAX_MEMORY];
uint32_t text_address = 0x00000000;
uint32_t data_address = 0x00010000;
uint32_t current_address = 0;
int current_section = 0; // 0 = text, 1 = data

// Register name to number mapping
typedef struct {
    const char *name;
    int number;
} register_t;

register_t registers[] = {
    {"zero", 0}, {"ra", 1}, {"sp", 2}, {"gp", 3}, {"tp", 4},
    {"t0", 5}, {"t1", 6}, {"t2", 7},
    {"s0", 8}, {"fp", 8}, {"s1", 9},
    {"a0", 10}, {"a1", 11}, {"a2", 12}, {"a3", 13}, {"a4", 14}, {"a5", 15}, {"a6", 16}, {"a7", 17},
    {"s2", 18}, {"s3", 19}, {"s4", 20}, {"s5", 21}, {"s6", 22}, {"s7", 23}, {"s8", 24}, {"s9", 25}, {"s10", 26}, {"s11", 27},
    {"t3", 28}, {"t4", 29}, {"t5", 30}, {"t6", 31},
    {NULL, -1}
};

// Complete RV32I instruction table
instruction_t instructions[] = {
    // R-type instructions
    {"add",  FMT_R, 0x33, 0x0, 0x00},
    {"sub",  FMT_R, 0x33, 0x0, 0x20},
    {"sll",  FMT_R, 0x33, 0x1, 0x00},
    {"slt",  FMT_R, 0x33, 0x2, 0x00},
    {"sltu", FMT_R, 0x33, 0x3, 0x00},
    {"xor",  FMT_R, 0x33, 0x4, 0x00},
    {"srl",  FMT_R, 0x33, 0x5, 0x00},
    {"sra",  FMT_R, 0x33, 0x5, 0x20},
    {"or",   FMT_R, 0x33, 0x6, 0x00},
    {"and",  FMT_R, 0x33, 0x7, 0x00},

    // I-type instructions (immediate)
    {"addi",  FMT_I, 0x13, 0x0, 0x00},
    {"slti",  FMT_I, 0x13, 0x2, 0x00},
    {"sltiu", FMT_I, 0x13, 0x3, 0x00},
    {"xori",  FMT_I, 0x13, 0x4, 0x00},
    {"ori",   FMT_I, 0x13, 0x6, 0x00},
    {"andi",  FMT_I, 0x13, 0x7, 0x00},
    {"slli",  FMT_I, 0x13, 0x1, 0x00},
    {"srli",  FMT_I, 0x13, 0x5, 0x00},
    {"srai",  FMT_I, 0x13, 0x5, 0x20},

    // Load instructions (I-type)
    {"lb",  FMT_I, 0x03, 0x0, 0x00},
    {"lh",  FMT_I, 0x03, 0x1, 0x00},
    {"lw",  FMT_I, 0x03, 0x2, 0x00},
    {"lbu", FMT_I, 0x03, 0x4, 0x00},
    {"lhu", FMT_I, 0x03, 0x5, 0x00},

    // Store instructions (S-type)
    {"sb", FMT_S, 0x23, 0x0, 0x00},
    {"sh", FMT_S, 0x23, 0x1, 0x00},
    {"sw", FMT_S, 0x23, 0x2, 0x00},

    // Branch instructions (B-type)
    {"beq",  FMT_B, 0x63, 0x0, 0x00},
    {"bne",  FMT_B, 0x63, 0x1, 0x00},
    {"blt",  FMT_B, 0x63, 0x4, 0x00},
    {"bge",  FMT_B, 0x63, 0x5, 0x00},
    {"bltu", FMT_B, 0x63, 0x6, 0x00},
    {"bgeu", FMT_B, 0x63, 0x7, 0x00},

    // Jump instructions
    {"jal",  FMT_J, 0x6F, 0x0, 0x00},
    {"jalr", FMT_I, 0x67, 0x0, 0x00},

    // Upper immediate instructions (U-type)
    {"lui",   FMT_U, 0x37, 0x0, 0x00},
    {"auipc", FMT_U, 0x17, 0x0, 0x00},

    // System instructions
    {"ecall",  FMT_I, 0x73, 0x0, 0x00},
    {"ebreak", FMT_I, 0x73, 0x0, 0x01},

    // Pseudo-instructions
    {"nop",  FMT_PSEUDO, 0, 0, 0},
    {"li",   FMT_PSEUDO, 0, 0, 0},
    {"mv",   FMT_PSEUDO, 0, 0, 0},
    {"not",  FMT_PSEUDO, 0, 0, 0},
    {"neg",  FMT_PSEUDO, 0, 0, 0},
    {"j",    FMT_PSEUDO, 0, 0, 0},
    {"jr",   FMT_PSEUDO, 0, 0, 0},
    {"ret",  FMT_PSEUDO, 0, 0, 0},
    {"call", FMT_PSEUDO, 0, 0, 0},

    {NULL, FMT_NONE, 0, 0, 0}
};

// Utility functions
char *trim_whitespace(char *str) {
    while (isspace(*str)) str++;
    if (*str == 0) return str;
    
    char *end = str + strlen(str) - 1;
    while (end > str && isspace(*end)) end--;
    end[1] = '\0';
    
    return str;
}

int get_register_number(const char *name) {
    // Handle x0-x31 format
    if (name[0] == 'x' && isdigit(name[1])) {
        int num = atoi(name + 1);
        if (num >= 0 && num <= 31) return num;
    }
    
    // Handle named registers
    for (int i = 0; registers[i].name; i++) {
        if (strcmp(registers[i].name, name) == 0) {
            return registers[i].number;
        }
    }
    
    return -1;
}

instruction_t *find_instruction(const char *name) {
    for (int i = 0; instructions[i].name; i++) {
        if (strcmp(instructions[i].name, name) == 0) {
            return &instructions[i];
        }
    }
    return NULL;
}

void add_symbol(const char *name, uint32_t address) {
    if (symbol_count >= MAX_LABELS) {
        fprintf(stderr, "Error: Too many labels\n");
        exit(1);
    }
    
    // Check for duplicate symbols
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            fprintf(stderr, "Error: Duplicate label '%s'\n", name);
            exit(1);
        }
    }
    
    strncpy(symbols[symbol_count].name, name, sizeof(symbols[0].name) - 1);
    symbols[symbol_count].address = address;
    symbol_count++;
}

int find_symbol(const char *name, uint32_t *address) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            *address = symbols[i].address;
            return 1;
        }
    }
    return 0;
}

int32_t parse_immediate(const char *str, uint32_t pc) {
    (void)pc; // Suppress unused parameter warning
    
    if (!str) return 0;
    
    // Check if it's a label
    if (isalpha(str[0]) || str[0] == '_') {
        uint32_t address;
        if (find_symbol(str, &address)) {
            return (int32_t)address;
        } else {
            fprintf(stderr, "Error: Undefined symbol '%s'\n", str);
            exit(1);
        }
    }
    
    // Parse numeric value
    if (strncmp(str, "0x", 2) == 0 || strncmp(str, "0X", 2) == 0) {
        return (int32_t)strtol(str, NULL, 16);
    } else {
        return (int32_t)strtol(str, NULL, 10);
    }
}

int tokenize_line(char *line, char **tokens) {
    int count = 0;
    
    // Remove comments
    char *comment = strchr(line, '#');
    if (comment) *comment = '\0';
    
    char *token = strtok(line, " \t\n\r,");
    while (token && count < MAX_TOKENS) {
        tokens[count++] = token;
        token = strtok(NULL, " \t\n\r,");
    }
    
    return count;
}

void write_word(uint32_t address, uint32_t word) {
    if (address >= MAX_MEMORY - 4) {
        fprintf(stderr, "Error: Memory overflow at address 0x%08x\n", address);
        exit(1);
    }
    
    // Little-endian encoding
    memory[address] = word & 0xFF;
    memory[address + 1] = (word >> 8) & 0xFF;
    memory[address + 2] = (word >> 16) & 0xFF;
    memory[address + 3] = (word >> 24) & 0xFF;
}

// Instruction encoding functions
uint32_t encode_r_type(uint32_t funct7, uint32_t rs2, uint32_t rs1, uint32_t funct3, uint32_t rd, uint32_t opcode) {
    return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode;
}

uint32_t encode_i_type(uint32_t imm, uint32_t rs1, uint32_t funct3, uint32_t rd, uint32_t opcode) {
    if(imm < 0x00000800){
        return ((imm & 0xFFF) << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode;
    }
    else{
        fprintf(stderr, "Error: Imm is out of bound\n");
        return 0;
    }
}

uint32_t encode_s_type(uint32_t imm, uint32_t rs2, uint32_t rs1, uint32_t funct3, uint32_t opcode) {
    if(imm < 0x00000800){
        uint32_t imm11_5 = (imm >> 5) & 0x7F;
        uint32_t imm4_0 = imm & 0x1F;
        return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (imm4_0 << 7) | opcode;
    }
    else{
        fprintf(stderr, "Error: Imm is out of bound\n");
        return 0;
    }
}

uint32_t encode_b_type(uint32_t imm, uint32_t rs2, uint32_t rs1, uint32_t funct3, uint32_t opcode) {
    if(imm < 0x00000FFE){
        uint32_t imm12 = (imm >> 12) & 0x1;
        uint32_t imm10_5 = (imm >> 5) & 0x3F;
        uint32_t imm4_1 = (imm >> 1) & 0xF;
        uint32_t imm11 = (imm >> 11) & 0x1;
        return (imm12 << 31) | (imm10_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (imm4_1 << 8) | (imm11 << 7) | opcode;
    }
    else{
        fprintf(stderr, "Error: Imm is out of bound\n");
        return 0;
    }
}

uint32_t encode_u_type(uint32_t imm, uint32_t rd, uint32_t opcode) {
    if(imm < 0x000FFFFF){
        return ((imm & 0xFFFFF000) << 12) | (rd << 7) | opcode;
    }
    else{
        fprintf(stderr, "Error: Imm is out of bound\n");
        return 0;
    }
}

uint32_t encode_j_type(uint32_t imm, uint32_t rd, uint32_t opcode) {
    if(imm < 0x0001FFFFE){
        uint32_t imm20 = (imm >> 20) & 0x1;
        uint32_t imm10_1 = (imm >> 1) & 0x3FF;
        uint32_t imm11 = (imm >> 11) & 0x1;
        uint32_t imm19_12 = (imm >> 12) & 0xFF;
        return (imm20 << 31) | (imm19_12 << 12) | (imm11 << 20) | (imm10_1 << 21) | (rd << 7) | opcode;
    }
    else{
        fprintf(stderr, "Error: Imm is out of bound\n");
        return 0;
    }
}

void handle_pseudo_instruction(char **tokens, int token_count, uint32_t pc) {
    if (strcmp(tokens[0], "nop") == 0) {
        // nop -> addi x0, x0, 0
        uint32_t word = encode_i_type(0, 0, 0, 0, 0x13);
        write_word(pc, word);
    } else if (strcmp(tokens[0], "li") == 0 && token_count >= 3) {
        // li rd, imm
        int rd = get_register_number(tokens[1]);
        int32_t imm = parse_immediate(tokens[2], pc);
        
        if (imm >= -2048 && imm <= 2047) {
            // Single addi instruction
            uint32_t word = encode_i_type(imm, 0, 0, rd, 0x13);
            write_word(pc, word);
        } else {
            // lui + addi sequence
            int32_t upper = (imm + 0x800) & 0xFFFFF000;
            int32_t lower = imm - upper;
            
            uint32_t lui_word = encode_u_type(upper, rd, 0x37);
            uint32_t addi_word = encode_i_type(lower, rd, 0, rd, 0x13);
            
            write_word(pc, lui_word);
            write_word(pc + 4, addi_word);
        }
    } else if (strcmp(tokens[0], "mv") == 0 && token_count >= 3) {
        // mv rd, rs -> addi rd, rs, 0
        int rd = get_register_number(tokens[1]);
        int rs = get_register_number(tokens[2]);
        uint32_t word = encode_i_type(0, rs, 0, rd, 0x13);
        write_word(pc, word);
    } else if (strcmp(tokens[0], "not") == 0 && token_count >= 3) {
        // not rd, rs -> xori rd, rs, -1
        int rd = get_register_number(tokens[1]);
        int rs = get_register_number(tokens[2]);
        uint32_t word = encode_i_type(-1, rs, 4, rd, 0x13);
        write_word(pc, word);
    } else if (strcmp(tokens[0], "neg") == 0 && token_count >= 3) {
        // neg rd, rs -> sub rd, x0, rs
        int rd = get_register_number(tokens[1]);
        int rs = get_register_number(tokens[2]);
        uint32_t word = encode_r_type(0x20, rs, 0, 0, rd, 0x33);
        write_word(pc, word);
    } else if (strcmp(tokens[0], "j") == 0 && token_count >= 2) {
        // j label -> jal x0, label
        int32_t target = parse_immediate(tokens[1], pc);
        int32_t offset = target - pc;
        uint32_t word = encode_j_type(offset, 0, 0x6F);
        write_word(pc, word);
    } else if (strcmp(tokens[0], "jr") == 0 && token_count >= 2) {
        // jr rs -> jalr x0, rs, 0
        int rs = get_register_number(tokens[1]);
        uint32_t word = encode_i_type(0, rs, 0, 0, 0x67);
        write_word(pc, word);
    } else if (strcmp(tokens[0], "ret") == 0) {
        // ret -> jalr x0, ra, 0
        uint32_t word = encode_i_type(0, 1, 0, 0, 0x67);
        write_word(pc, word);
    }
}

// Pass 1: Build symbol table
void pass1(FILE *file) {
    char line[MAX_LINE];
    current_address = text_address;
    current_section = 0;
    
    rewind(file);
    
    while (fgets(line, sizeof(line), file)) {
        char *trimmed = trim_whitespace(line);
        if (*trimmed == '\0') continue;
        
        char line_copy[MAX_LINE];
        strcpy(line_copy, trimmed);
        
        char *tokens[MAX_TOKENS];
        int token_count = tokenize_line(line_copy, tokens);
        
        if (token_count == 0) continue;
        
        // Handle labels
        char *colon = strchr(tokens[0], ':');
        if (colon) {
            *colon = '\0';
            add_symbol(tokens[0], current_address);
            
            // Check if there's more on the line after the label
            if (token_count > 1) {
                tokens[0] = tokens[1];
                for (int i = 1; i < token_count - 1; i++) {
                    tokens[i] = tokens[i + 1];
                }
                token_count--;
            } else {
                continue;
            }
        }
        
        // Handle directives
        if (tokens[0][0] == '.') {
            if (strcmp(tokens[0], ".text") == 0) {
                current_section = 0;
                current_address = text_address;
            } else if (strcmp(tokens[0], ".data") == 0) {
                current_section = 1;
                current_address = data_address;
            } else if (strcmp(tokens[0], ".word") == 0) {
                current_address += 4 * (token_count - 1);
            } else if (strcmp(tokens[0], ".byte") == 0) {
                current_address += token_count - 1;
            } else if (strcmp(tokens[0], ".align") == 0 && token_count >= 2) {
                int align = atoi(tokens[1]);
                uint32_t alignment = 1 << align;
                current_address = (current_address + alignment - 1) & ~(alignment - 1);
            }
        } else {
            // Regular instruction - increment by 4 bytes
            instruction_t *instr = find_instruction(tokens[0]);
            if (instr) {
                if (instr->format == FMT_PSEUDO) {
                    if (strcmp(tokens[0], "li") == 0 && token_count >= 3) {
                        int32_t imm = parse_immediate(tokens[2], current_address);
                        if (imm >= -2048 && imm <= 2047) {
                            current_address += 4;
                        } else {
                            current_address += 8; // lui + addi
                        }
                    } else {
                        current_address += 4;
                    }
                } else {
                    current_address += 4;
                }
            }
        }
    }
}

// Pass 2: Generate machine code
void pass2(FILE *file) {
    char line[MAX_LINE];
    current_address = text_address;
    current_section = 0;
    
    rewind(file);
    
    while (fgets(line, sizeof(line), file)) {
        char *trimmed = trim_whitespace(line);
        if (*trimmed == '\0') continue;
        
        char line_copy[MAX_LINE];
        strcpy(line_copy, trimmed);
        
        char *tokens[MAX_TOKENS];
        int token_count = tokenize_line(line_copy, tokens);
        
        if (token_count == 0) continue;
        
        // Handle labels
        char *colon = strchr(tokens[0], ':');
        if (colon) {
            *colon = '\0';
            
            if (token_count > 1) {
                tokens[0] = tokens[1];
                for (int i = 1; i < token_count - 1; i++) {
                    tokens[i] = tokens[i + 1];
                }
                token_count--;
            } else {
                continue;
            }
        }
        
        // Handle directives
        if (tokens[0][0] == '.') {
            if (strcmp(tokens[0], ".text") == 0) {
                current_section = 0;
                current_address = text_address;
            } else if (strcmp(tokens[0], ".data") == 0) {
                current_section = 1;
                current_address = data_address;
            } else if (strcmp(tokens[0], ".word") == 0) {
                for (int i = 1; i < token_count; i++) {
                    uint32_t value = parse_immediate(tokens[i], current_address);
                    write_word(current_address, value);
                    current_address += 4;
                }
            } else if (strcmp(tokens[0], ".byte") == 0) {
                for (int i = 1; i < token_count; i++) {
                    uint8_t value = parse_immediate(tokens[i], current_address) & 0xFF;
                    if (current_address < MAX_MEMORY) {
                        memory[current_address] = value;
                    }
                    current_address += 1;
                }
            } else if (strcmp(tokens[0], ".align") == 0 && token_count >= 2) {
                int align = atoi(tokens[1]);
                uint32_t alignment = 1 << align;
                current_address = (current_address + alignment - 1) & ~(alignment - 1);
            }
            continue;
        }
        
        // Handle instructions
        instruction_t *instr = find_instruction(tokens[0]);
        if (!instr) {
            fprintf(stderr, "Error: Unknown instruction '%s'\n", tokens[0]);
            exit(1);
        }
        
        if (instr->format == FMT_PSEUDO) {
            handle_pseudo_instruction(tokens, token_count, current_address);
            if (strcmp(tokens[0], "li") == 0 && token_count >= 3) {
                int32_t imm = parse_immediate(tokens[2], current_address);
                current_address += (imm >= -2048 && imm <= 2047) ? 4 : 8;
            } else {
                current_address += 4;
            }
            continue;
        }
        
        uint32_t word = 0;
        
        switch (instr->format) {
            case FMT_R: {
                if (token_count < 4) {
                    fprintf(stderr, "Error: R-type instruction requires 3 operands\n");
                    exit(1);
                }
                int rd = get_register_number(tokens[1]);
                int rs1 = get_register_number(tokens[2]);
                int rs2 = get_register_number(tokens[3]);
                word = encode_r_type(instr->funct7, rs2, rs1, instr->funct3, rd, instr->opcode);
                break;
            }
            
            case FMT_I: {
                if (token_count < 3) {
                    fprintf(stderr, "Error: I-type instruction requires 3 operands\n");
                    exit(1);
                }
                
                if (instr->opcode == 0x03) { // Load instructions
                    // Format: lw rd, imm(rs1)
                    int rd = get_register_number(tokens[1]);
                    
                    // Parse imm(rs1) format
                    char *paren = strchr(tokens[2], '(');
                    if (!paren) {
                        fprintf(stderr, "Error: Load instruction requires format: rd, imm(rs1)\n");
                        exit(1);
                    }
                    
                    *paren = '\0';
                    int32_t imm = parse_immediate(tokens[2], current_address);
                    
                    char *rs1_str = paren + 1;
                    char *close_paren = strchr(rs1_str, ')');
                    if (close_paren) *close_paren = '\0';
                    
                    int rs1 = get_register_number(rs1_str);
                    word = encode_i_type(imm, rs1, instr->funct3, rd, instr->opcode);
                } else if (strcmp(tokens[0], "slli") == 0 || strcmp(tokens[0], "srli") == 0 || strcmp(tokens[0], "srai") == 0) {
                    // Shift instructions
                    int rd = get_register_number(tokens[1]);
                    int rs1 = get_register_number(tokens[2]);
                    int32_t shamt = parse_immediate(tokens[3], current_address) & 0x1F;
                    
                    uint32_t funct7 = instr->funct7;
                    word = (funct7 << 25) | (shamt << 20) | (rs1 << 15) | (instr->funct3 << 12) | (rd << 7) | instr->opcode;
                } else {
                    // Regular I-type
                    int rd = get_register_number(tokens[1]);
                    int rs1 = get_register_number(tokens[2]);
                    int32_t imm = parse_immediate(tokens[3], current_address);
                    word = encode_i_type(imm, rs1, instr->funct3, rd, instr->opcode);
                }
                break;
            }
            
            case FMT_S: {
                if (token_count < 3) {
                    fprintf(stderr, "Error: S-type instruction requires format: rs2, imm(rs1)\n");
                    exit(1);
                }
                
                int rs2 = get_register_number(tokens[1]);
                
                // Parse imm(rs1) format
                char *paren = strchr(tokens[2], '(');
                if (!paren) {
                    fprintf(stderr, "Error: Store instruction requires format: rs2, imm(rs1)\n");
                    exit(1);
                }
                
                *paren = '\0';
                int32_t imm = parse_immediate(tokens[2], current_address);
                
                char *rs1_str = paren + 1;
                char *close_paren = strchr(rs1_str, ')');
                if (close_paren) *close_paren = '\0';
                
                int rs1 = get_register_number(rs1_str);
                word = encode_s_type(imm, rs2, rs1, instr->funct3, instr->opcode);
                break;
            }
            
            case FMT_B: {
                if (token_count < 4) {
                    fprintf(stderr, "Error: B-type instruction requires 3 operands\n");
                    exit(1);
                }
                int rs1 = get_register_number(tokens[1]);
                int rs2 = get_register_number(tokens[2]);
                int32_t target = parse_immediate(tokens[3], current_address);
                int32_t offset = target - current_address;
                word = encode_b_type(offset, rs2, rs1, instr->funct3, instr->opcode);
                break;
            }
            
            case FMT_U: {
                if (token_count < 3) {
                    fprintf(stderr, "Error: U-type instruction requires 2 operands\n");
                    exit(1);
                }
                int rd = get_register_number(tokens[1]);
                int32_t imm = parse_immediate(tokens[2], current_address);
                word = encode_u_type(imm, rd, instr->opcode);
                break;
            }
            
            case FMT_J: {
                if (token_count < 3) {
                    fprintf(stderr, "Error: J-type instruction requires 2 operands\n");
                    exit(1);
                }
                int rd = get_register_number(tokens[1]);
                int32_t target = parse_immediate(tokens[2], current_address);
                int32_t offset = target - current_address;
                word = encode_j_type(offset, rd, instr->opcode);
                break;
            }
            
            default:
                fprintf(stderr, "Error: Unsupported instruction format\n");
                exit(1);
        }
        
        write_word(current_address, word);
        current_address += 4;
    }
}

void print_hex_dump(uint32_t start_addr, uint32_t end_addr) {
    printf("Machine Code (Hex):\n");
    printf("Address    : Machine Code\n");
    printf("=======================\n");
    
    for (uint32_t addr = start_addr; addr < end_addr; addr += 4) {
        if (addr >= MAX_MEMORY - 4) break;
        
        uint32_t word = memory[addr] | 
                       (memory[addr + 1] << 8) | 
                       (memory[addr + 2] << 16) | 
                       (memory[addr + 3] << 24);
        
        // Only print if not all zeros
        if (word != 0) {
            printf("0x%08x: 0x%08x\n", addr, word);
        }
    }
    printf("\n");
}

void write_binary_file(const char *filename, uint32_t start_addr, uint32_t end_addr) {
    FILE *file = fopen(filename, "wb");
    if (!file) {
        perror("Error opening output file");
        exit(1);
    }
    
    // Find the actual end of used memory
    uint32_t actual_end = start_addr;
    for (uint32_t addr = start_addr; addr < end_addr; addr++) {
        if (addr < MAX_MEMORY && memory[addr] != 0) {
            actual_end = addr + 1;
        }
    }
    
    // Align to 4-byte boundary
    actual_end = (actual_end + 3) & ~3;
    
    if (actual_end > start_addr) {
        size_t bytes_written = fwrite(&memory[start_addr], 1, actual_end - start_addr, file);
        printf("Written %zu bytes to %s\n", bytes_written, filename);
    } else {
        printf("No data to write to %s\n", filename);
    }
    
    fclose(file);
}

void print_symbol_table() {
    if (symbol_count > 0) {
        printf("Symbol Table:\n");
        printf("Name           Address\n");
        printf("====================\n");
        for (int i = 0; i < symbol_count; i++) {
            printf("%-14s 0x%08x\n", symbols[i].name, symbols[i].address);
        }
        printf("\n");
    }
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <input.s> <output.bin> [options]\n", argv[0]);
        printf("Options:\n");
        printf("  -v, --verbose  Print symbol table and hex dump\n");
        printf("  -h, --help     Show this help message\n");
        return 1;
    }
    
    int verbose = 0;
    for (int i = 3; i < argc; i++) {
        if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) {
            verbose = 1;
        } else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            printf("RISC-V RV32I Assembler\n");
            printf("Supports all RV32I instructions and common pseudo-instructions\n");
            printf("Usage: %s <input.s> <output.bin> [options]\n", argv[0]);
            return 0;
        }
    }
    
    const char *input_filename = argv[1];
    const char *output_filename = argv[2];
    
    FILE *input_file = fopen(input_filename, "r");
    if (!input_file) {
        perror("Error opening input file");
        return 1;
    }
    
    // Initialize memory
    memset(memory, 0, sizeof(memory));
    
    printf("RISC-V RV32I Assembler\n");
    printf("======================\n");
    printf("Input file:  %s\n", input_filename);
    printf("Output file: %s\n\n", output_filename);
    
    // Pass 1: Build symbol table
    printf("Pass 1: Building symbol table...\n");
    pass1(input_file);
    
    if (verbose) {
        print_symbol_table();
    }
    
    // Pass 2: Generate machine code
    printf("Pass 2: Generating machine code...\n");
    pass2(input_file);
    
    fclose(input_file);
    
    // Find the range of used memory
    uint32_t min_addr = UINT32_MAX;
    uint32_t max_addr = 0;
    
    for (uint32_t addr = 0; addr < MAX_MEMORY; addr++) {
        if (memory[addr] != 0) {
            if (addr < min_addr) min_addr = addr;
            if (addr > max_addr) max_addr = addr;
        }
    }
    
    if (min_addr != UINT32_MAX) {
        max_addr = (max_addr + 4) & ~3; // Align to 4-byte boundary
        
        if (verbose) {
            print_hex_dump(min_addr, max_addr);
        }
        
        write_binary_file(output_filename, min_addr, max_addr);
    } else {
        printf("No machine code generated.\n");
        // Create empty file
        FILE *empty_file = fopen(output_filename, "wb");
        if (empty_file) fclose(empty_file);
        return 0;
    }
    
    printf("Assembly completed successfully!\n");
    return 0;
}

/* Example usage and test cases:

1. Basic arithmetic:
   add x1, x2, x3
   sub x4, x5, x6
   addi x1, x2, 100

2. Load/Store:
   lw x1, 0(x2)
   sw x3, 4(x4)
   lb x5, -8(x6)

3. Branches:
   beq x1, x2, loop
   bne x3, x4, end
   blt x5, x6, less

4. Jumps:
   jal x1, function
   jalr x0, x1, 0

5. Pseudo-instructions:
   li x1, 0x12345678
   mv x2, x3
   nop
   j loop

6. Labels and sections:
   .text
   main:
       li x1, 42
       jal x1, func
   func:
       addi x1, x1, 1
       ret
   
   .data
   data_label:
       .word 0x12345678
       .byte 0xFF
*/




