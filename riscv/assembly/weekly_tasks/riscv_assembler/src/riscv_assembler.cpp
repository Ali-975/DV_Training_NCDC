/**
 * RISC-V RV32I Assembler
 * Complete implementation supporting all RV32I instructions
 * Outputs both hexadecimal and binary formats
 * 
 * Usage: ./assembler <input.s> <output> [-h|-b]
 *   -h: Output hexadecimal format
 *   -b: Output binary stream
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <map>
#include <unordered_map>
#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <cctype>

class RISCVAssembler {
private:
    // Instruction formats
    enum class Format {
        R_TYPE, I_TYPE, S_TYPE, B_TYPE, U_TYPE, J_TYPE, PSEUDO
    };

    // Instruction definition
    struct Instruction {
        Format format;
        uint32_t opcode;
        uint32_t funct3;
        uint32_t funct7;
    };

    // Register mapping
    std::unordered_map<std::string, int> registers = {
        // ABI names
        {"zero", 0}, {"ra", 1}, {"sp", 2}, {"gp", 3}, {"tp", 4},
        {"t0", 5}, {"t1", 6}, {"t2", 7},
        {"s0", 8}, {"fp", 8}, {"s1", 9},
        {"a0", 10}, {"a1", 11}, {"a2", 12}, {"a3", 13}, 
        {"a4", 14}, {"a5", 15}, {"a6", 16}, {"a7", 17},
        {"s2", 18}, {"s3", 19}, {"s4", 20}, {"s5", 21}, 
        {"s6", 22}, {"s7", 23}, {"s8", 24}, {"s9", 25}, 
        {"s10", 26}, {"s11", 27},
        {"t3", 28}, {"t4", 29}, {"t5", 30}, {"t6", 31}
    };

    // Instruction table
    std::unordered_map<std::string, Instruction> instructions = {
        // R-type instructions
        {"add",  {Format::R_TYPE, 0x33, 0x0, 0x00}},
        {"sub",  {Format::R_TYPE, 0x33, 0x0, 0x20}},
        {"sll",  {Format::R_TYPE, 0x33, 0x1, 0x00}},
        {"slt",  {Format::R_TYPE, 0x33, 0x2, 0x00}},
        {"sltu", {Format::R_TYPE, 0x33, 0x3, 0x00}},
        {"xor",  {Format::R_TYPE, 0x33, 0x4, 0x00}},
        {"srl",  {Format::R_TYPE, 0x33, 0x5, 0x00}},
        {"sra",  {Format::R_TYPE, 0x33, 0x5, 0x20}},
        {"or",   {Format::R_TYPE, 0x33, 0x6, 0x00}},
        {"and",  {Format::R_TYPE, 0x33, 0x7, 0x00}},

        // I-type instructions (immediate)
        {"addi",  {Format::I_TYPE, 0x13, 0x0, 0x00}},
        {"slti",  {Format::I_TYPE, 0x13, 0x2, 0x00}},
        {"sltiu", {Format::I_TYPE, 0x13, 0x3, 0x00}},
        {"xori",  {Format::I_TYPE, 0x13, 0x4, 0x00}},
        {"ori",   {Format::I_TYPE, 0x13, 0x6, 0x00}},
        {"andi",  {Format::I_TYPE, 0x13, 0x7, 0x00}},
        {"slli",  {Format::I_TYPE, 0x13, 0x1, 0x00}},
        {"srli",  {Format::I_TYPE, 0x13, 0x5, 0x00}},
        {"srai",  {Format::I_TYPE, 0x13, 0x5, 0x20}},

        // Load instructions
        {"lb",  {Format::I_TYPE, 0x03, 0x0, 0x00}},
        {"lh",  {Format::I_TYPE, 0x03, 0x1, 0x00}},
        {"lw",  {Format::I_TYPE, 0x03, 0x2, 0x00}},
        {"lbu", {Format::I_TYPE, 0x03, 0x4, 0x00}},
        {"lhu", {Format::I_TYPE, 0x03, 0x5, 0x00}},

        // Store instructions
        {"sb", {Format::S_TYPE, 0x23, 0x0, 0x00}},
        {"sh", {Format::S_TYPE, 0x23, 0x1, 0x00}},
        {"sw", {Format::S_TYPE, 0x23, 0x2, 0x00}},

        // Branch instructions
        {"beq",  {Format::B_TYPE, 0x63, 0x0, 0x00}},
        {"bne",  {Format::B_TYPE, 0x63, 0x1, 0x00}},
        {"blt",  {Format::B_TYPE, 0x63, 0x4, 0x00}},
        {"bge",  {Format::B_TYPE, 0x63, 0x5, 0x00}},
        {"bltu", {Format::B_TYPE, 0x63, 0x6, 0x00}},
        {"bgeu", {Format::B_TYPE, 0x63, 0x7, 0x00}},

        // Jump instructions
        {"jal",  {Format::J_TYPE, 0x6F, 0x0, 0x00}},
        {"jalr", {Format::I_TYPE, 0x67, 0x0, 0x00}},

        // Upper immediate instructions
        {"lui",   {Format::U_TYPE, 0x37, 0x0, 0x00}},
        {"auipc", {Format::U_TYPE, 0x17, 0x0, 0x00}},

        // System instructions
        {"ecall",  {Format::I_TYPE, 0x73, 0x0, 0x00}},
        {"ebreak", {Format::I_TYPE, 0x73, 0x0, 0x01}},

        // Pseudo-instructions
        {"nop",  {Format::PSEUDO, 0, 0, 0}},
        {"li",   {Format::PSEUDO, 0, 0, 0}},
        {"mv",   {Format::PSEUDO, 0, 0, 0}},
        {"not",  {Format::PSEUDO, 0, 0, 0}},
        {"neg",  {Format::PSEUDO, 0, 0, 0}},
        {"j",    {Format::PSEUDO, 0, 0, 0}},
        {"jr",   {Format::PSEUDO, 0, 0, 0}},
        {"ret",  {Format::PSEUDO, 0, 0, 0}},
        {"call", {Format::PSEUDO, 0, 0, 0}}
    };

    // Symbol table
    std::map<std::string, uint32_t> labels;
    std::vector<uint32_t> machineCode;
    uint32_t currentAddress = 0;
    bool outputHex = false;
    bool outputBinary = false;

    // Utility functions
    std::string trim(const std::string& str) {
        size_t start = str.find_first_not_of(" \t\r\n");
        if (start == std::string::npos) return "";
        size_t end = str.find_last_not_of(" \t\r\n");
        return str.substr(start, end - start + 1);
    }

    std::vector<std::string> tokenize(const std::string& line) {
        std::vector<std::string> tokens;
        std::stringstream ss(line);
        std::string token;
        
        // Remove comments
        size_t commentPos = line.find('#');
        std::string cleanLine = (commentPos != std::string::npos) ? 
                               line.substr(0, commentPos) : line;
        
        ss.str(cleanLine);
        while (std::getline(ss, token, ' ')) {
            token = trim(token);
            if (!token.empty()) {
                // Remove commas and parentheses as separate tokens
                size_t pos = 0;
                while ((pos = token.find(',')) != std::string::npos) {
                    if (pos > 0) tokens.push_back(token.substr(0, pos));
                    token = token.substr(pos + 1);
                }
                if (!token.empty()) tokens.push_back(token);
            }
        }
        return tokens;
    }

    int getRegisterNumber(const std::string& reg) {
        // Handle x0-x31 format
        if (reg.length() > 1 && reg[0] == 'x' && std::isdigit(reg[1])) {
            int num = std::stoi(reg.substr(1));
            if (num >= 0 && num <= 31) return num;
        }
        
        // Handle named registers
        auto it = registers.find(reg);
        if (it != registers.end()) {
            return it->second;
        }
        
        throw std::runtime_error("Invalid register: " + reg);
    }

    int32_t parseImmediate(const std::string& str) {
        // Check if it's a label
        if (std::isalpha(str[0]) || str[0] == '_') {
            auto it = labels.find(str);
            if (it != labels.end()) {
                return static_cast<int32_t>(it->second);
            } else {
                throw std::runtime_error("Undefined label: " + str);
            }
        }
        
        // Parse numeric value
        if (str.substr(0, 2) == "0x" || str.substr(0, 2) == "0X") {
            return static_cast<int32_t>(std::stoul(str, nullptr, 16));
        } else {
            return static_cast<int32_t>(std::stoi(str));
        }
    }

    // Instruction encoding functions
    uint32_t encodeRType(uint32_t funct7, uint32_t rs2, uint32_t rs1, uint32_t funct3, uint32_t rd, uint32_t opcode) {
        return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode;
    }

    uint32_t encodeIType(uint32_t imm, uint32_t rs1, uint32_t funct3, uint32_t rd, uint32_t opcode) {
        if(imm < 0x00000800){
            return ((imm & 0xFFF) << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode;
        }
        else{
            fprintf(stderr, "Error: Imm is out of bound\n");
            return 0;
        }
    }

    uint32_t encodeSType(uint32_t imm, uint32_t rs2, uint32_t rs1, uint32_t funct3, uint32_t opcode) {
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

    uint32_t encodeBType(uint32_t imm, uint32_t rs2, uint32_t rs1, uint32_t funct3, uint32_t opcode) {
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

    uint32_t encodeUType(uint32_t imm, uint32_t rd, uint32_t opcode) {
        if(imm < 0x000FFFFF){
            return ((imm & 0xFFFFF000) << 12) | (rd << 7) | opcode;
        }
        else{
            fprintf(stderr, "Error: Imm is out of bound\n");
            return 0;
        }
    }

    uint32_t encodeJType(uint32_t imm, uint32_t rd, uint32_t opcode) {
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

    void handlePseudoInstruction(const std::vector<std::string>& tokens) {
        if (tokens[0] == "nop") {
            // nop -> addi x0, x0, 0
            machineCode.push_back(encodeIType(0, 0, 0, 0, 0x13));
        } else if (tokens[0] == "li" && tokens.size() >= 3) {
            // li rd, imm
            int rd = getRegisterNumber(tokens[1]);
            int32_t imm = parseImmediate(tokens[2]);
            
            if (imm >= -2048 && imm <= 2047) {
                // Single addi instruction
                machineCode.push_back(encodeIType(imm, 0, 0, rd, 0x13));
            } else {
                // lui + addi sequence
                int32_t upper = (imm + 0x800) & 0xFFFFF000;
                int32_t lower = imm - upper;
                
                machineCode.push_back(encodeUType(upper, rd, 0x37));
                currentAddress += 4;
                machineCode.push_back(encodeIType(lower, rd, 0, rd, 0x13));
            }
        } else if (tokens[0] == "mv" && tokens.size() >= 3) {
            // mv rd, rs -> addi rd, rs, 0
            int rd = getRegisterNumber(tokens[1]);
            int rs = getRegisterNumber(tokens[2]);
            machineCode.push_back(encodeIType(0, rs, 0, rd, 0x13));
        } else if (tokens[0] == "not" && tokens.size() >= 3) {
            // not rd, rs -> xori rd, rs, -1
            int rd = getRegisterNumber(tokens[1]);
            int rs = getRegisterNumber(tokens[2]);
            machineCode.push_back(encodeIType(-1, rs, 4, rd, 0x13));
        } else if (tokens[0] == "neg" && tokens.size() >= 3) {
            // neg rd, rs -> sub rd, x0, rs
            int rd = getRegisterNumber(tokens[1]);
            int rs = getRegisterNumber(tokens[2]);
            machineCode.push_back(encodeRType(0x20, rs, 0, 0, rd, 0x33));
        } else if (tokens[0] == "j" && tokens.size() >= 2) {
            // j label -> jal x0, label
            int32_t target = parseImmediate(tokens[1]);
            int32_t offset = target - currentAddress;
            machineCode.push_back(encodeJType(offset, 0, 0x6F));
        } else if (tokens[0] == "jr" && tokens.size() >= 2) {
            // jr rs -> jalr x0, rs, 0
            int rs = getRegisterNumber(tokens[1]);
            machineCode.push_back(encodeIType(0, rs, 0, 0, 0x67));
        } else if (tokens[0] == "ret") {
            // ret -> jalr x0, ra, 0
            machineCode.push_back(encodeIType(0, 1, 0, 0, 0x67));
        }
    }

    void firstPass(std::ifstream& file) {
        std::string line;
        currentAddress = 0;
        
        while (std::getline(file, line)) {
            line = trim(line);
            if (line.empty() || line[0] == '#') continue;
            
            auto tokens = tokenize(line);
            if (tokens.empty()) continue;
            
            // Handle labels
            if (tokens[0].back() == ':') {
                std::string labelName = tokens[0].substr(0, tokens[0].length() - 1);
                labels[labelName] = currentAddress;
                
                // Check if there's more on the line after the label
                if (tokens.size() > 1) {
                    tokens.erase(tokens.begin());
                } else {
                    continue;
                }
            }
            
            // Handle directives
            if (tokens[0][0] == '.') {
                if (tokens[0] == ".text") {
                    currentAddress = 0;
                } else if (tokens[0] == ".data") {
                    // For simplicity, continue with same address space
                }
                continue;
            }
            
            // Handle instructions - increment address
            if (instructions.find(tokens[0]) != instructions.end()) {
                if (tokens[0] == "li" && tokens.size() >= 3) {
                    try {
                        int32_t imm = parseImmediate(tokens[2]);
                        currentAddress += (imm >= -2048 && imm <= 2047) ? 4 : 8;
                    } catch (...) {
                        currentAddress += 8; // Assume worst case for undefined labels
                    }
                } else {
                    currentAddress += 4;
                }
            }
        }
    }

    void secondPass(std::ifstream& file) {
        std::string line;
        currentAddress = 0;
        
        file.clear();
        file.seekg(0);
        
        while (std::getline(file, line)) {
            line = trim(line);
            if (line.empty() || line[0] == '#') continue;
            
            auto tokens = tokenize(line);
            if (tokens.empty()) continue;
            
            // Handle labels
            if (tokens[0].back() == ':') {
                if (tokens.size() > 1) {
                    tokens.erase(tokens.begin());
                } else {
                    continue;
                }
            }
            
            // Handle directives
            if (tokens[0][0] == '.') continue;
            
            // Handle instructions
            auto instrIt = instructions.find(tokens[0]);
            if (instrIt == instructions.end()) {
                throw std::runtime_error("Unknown instruction: " + tokens[0]);
            }
            
            const Instruction& instr = instrIt->second;
            uint32_t word = 0;
            
            if (instr.format == Format::PSEUDO) {
                handlePseudoInstruction(tokens);
                if (tokens[0] == "li" && tokens.size() >= 3) {
                    int32_t imm = parseImmediate(tokens[2]);
                    currentAddress += (imm >= -2048 && imm <= 2047) ? 4 : 8;
                } else {
                    currentAddress += 4;
                }
                continue;
            }
            
            switch (instr.format) {
                case Format::R_TYPE: {
                    if (tokens.size() < 4) throw std::runtime_error("R-type needs 3 operands");
                    int rd = getRegisterNumber(tokens[1]);
                    int rs1 = getRegisterNumber(tokens[2]);
                    int rs2 = getRegisterNumber(tokens[3]);
                    word = encodeRType(instr.funct7, rs2, rs1, instr.funct3, rd, instr.opcode);
                    break;
                }
                
                case Format::I_TYPE: {
                    if (instr.opcode == 0x03) { // Load instructions
                        int rd = getRegisterNumber(tokens[1]);
                        
                        // Parse imm(rs1) format
                        std::string memAccess = tokens[2];
                        size_t parenPos = memAccess.find('(');
                        if (parenPos == std::string::npos) {
                            throw std::runtime_error("Load instruction needs format: rd, imm(rs1)");
                        }
                        
                        int32_t imm = parseImmediate(memAccess.substr(0, parenPos));
                        std::string rs1Str = memAccess.substr(parenPos + 1);
                        rs1Str = rs1Str.substr(0, rs1Str.find(')'));
                        int rs1 = getRegisterNumber(rs1Str);
                        
                        word = encodeIType(imm, rs1, instr.funct3, rd, instr.opcode);
                    } else if (tokens[0] == "slli" || tokens[0] == "srli" || tokens[0] == "srai") {
                        // Shift instructions
                        int rd = getRegisterNumber(tokens[1]);
                        int rs1 = getRegisterNumber(tokens[2]);
                        int32_t shamt = parseImmediate(tokens[3]) & 0x1F;
                        
                        uint32_t funct7 = instr.funct7;
                        word = (funct7 << 25) | (shamt << 20) | (rs1 << 15) | 
                               (instr.funct3 << 12) | (rd << 7) | instr.opcode;
                    } else {
                        // Regular I-type
                        int rd = getRegisterNumber(tokens[1]);
                        int rs1 = getRegisterNumber(tokens[2]);
                        int32_t imm = parseImmediate(tokens[3]);
                        word = encodeIType(imm, rs1, instr.funct3, rd, instr.opcode);
                    }
                    break;
                }
                
                case Format::S_TYPE: {
                    int rs2 = getRegisterNumber(tokens[1]);
                    
                    // Parse imm(rs1) format
                    std::string memAccess = tokens[2];
                    size_t parenPos = memAccess.find('(');
                    if (parenPos == std::string::npos) {
                        throw std::runtime_error("Store instruction needs format: rs2, imm(rs1)");
                    }
                    
                    int32_t imm = parseImmediate(memAccess.substr(0, parenPos));
                    std::string rs1Str = memAccess.substr(parenPos + 1);
                    rs1Str = rs1Str.substr(0, rs1Str.find(')'));
                    int rs1 = getRegisterNumber(rs1Str);
                    
                    word = encodeSType(imm, rs2, rs1, instr.funct3, instr.opcode);
                    break;
                }
                
                case Format::B_TYPE: {
                    int rs1 = getRegisterNumber(tokens[1]);
                    int rs2 = getRegisterNumber(tokens[2]);
                    int32_t target = parseImmediate(tokens[3]);
                    int32_t offset = target - currentAddress;
                    word = encodeBType(offset, rs2, rs1, instr.funct3, instr.opcode);
                    break;
                }
                
                case Format::U_TYPE: {
                    int rd = getRegisterNumber(tokens[1]);
                    int32_t imm = parseImmediate(tokens[2]);
                    word = encodeUType(imm, rd, instr.opcode);
                    break;
                }
                
                case Format::J_TYPE: {
                    int rd = getRegisterNumber(tokens[1]);
                    int32_t target = parseImmediate(tokens[2]);
                    int32_t offset = target - currentAddress;
                    word = encodeJType(offset, rd, instr.opcode);
                    break;
                }
                
                default:
                    throw std::runtime_error("Unsupported instruction format");
            }
            
            machineCode.push_back(word);
            currentAddress += 4;
        }
    }

public:
    void assemble(const std::string& inputFile, const std::string& outputFile, 
                 bool hexOutput, bool binOutput) {
        outputHex = hexOutput;
        outputBinary = binOutput;
        
        std::ifstream file(inputFile);
        if (!file.is_open()) {
            throw std::runtime_error("Cannot open input file: " + inputFile);
        }
        
        std::cout << "RISC-V RV32I Assembler\n";
        std::cout << "======================\n";
        std::cout << "Input:  " << inputFile << "\n";
        std::cout << "Output: " << outputFile << "\n\n";
        
        // Pass 1: Build symbol table
        std::cout << "Pass 1: Building symbol table...\n";
        firstPass(file);
        
        // Print symbol table
        if (!labels.empty()) {
            std::cout << "\nSymbol Table:\n";
            std::cout << "Label          Address\n";
            std::cout << "====================\n";
            for (const auto& label : labels) {
                std::cout << std::left << std::setw(14) << label.first 
                         << " 0x" << std::hex << std::setfill('0') 
                         << std::setw(8) << label.second << std::dec << "\n";
            }
        }
        
        // Pass 2: Generate machine code
        std::cout << "\nPass 2: Generating machine code...\n";
        secondPass(file);
        
        file.close();
        
        // Output results
        if (outputHex) {
            outputHexFormat(outputFile);
        } else if (outputBinary) {
            outputBinaryFormat(outputFile);
        } else {
            // Default to hex if no format specified
            outputHexFormat(outputFile);
        }
        
        std::cout << "\nAssembly completed successfully!\n";
        std::cout << "Generated " << machineCode.size() << " instructions.\n";
    }
    
private:
    void outputHexFormat(const std::string& outputFile) {
        std::ofstream file(outputFile);
        if (!file.is_open()) {
            throw std::runtime_error("Cannot create output file: " + outputFile);
        }
        
        std::cout << "\nMachine Code (Hex):\n";
        std::cout << "Address    : Machine Code\n";
        std::cout << "=======================\n";
        
        uint32_t address = 0;
        for (uint32_t code : machineCode) {
            std::string hexStr = "0x" + 
                               (std::ostringstream{} << std::hex << std::setfill('0') 
                                << std::setw(8) << code).str();
            
            std::cout << "0x" << std::hex << std::setfill('0') << std::setw(8) 
                     << address << ": " << hexStr << std::dec << "\n";
            file << hexStr << "\n";
            address += 4;
        }
        
        file.close();
        std::cout << "\nHexadecimal output written to: " << outputFile << "\n";
    }
    
    void outputBinaryFormat(const std::string& outputFile) {
        std::ofstream file(outputFile, std::ios::binary);
        if (!file.is_open()) {
            throw std::runtime_error("Cannot create output file: " + outputFile);
        }
        
        for (uint32_t code : machineCode) {
            // Write in little-endian format
            file.write(reinterpret_cast<const char*>(&code), sizeof(code));
        }
        
        file.close();
        std::cout << "\nBinary stream output written to: " << outputFile << "\n";
        std::cout << "Size: " << machineCode.size() * 4 << " bytes\n";
    }
};

void printUsage(const char* programName) {
    std::cout << "RISC-V RV32I Assembler\n";
    std::cout << "Usage: " << programName << " <input.s> <output> [-h|-b]\n";
    std::cout << "  -h: Output hexadecimal format\n";
    std::cout << "  -b: Output binary stream format\n";
    std::cout << "\nExample:\n";
    std::cout << "  " << programName << " program.s output.hex -h\n";
    std::cout << "  " << programName << " program.s output.bin -b\n";
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printUsage(argv[0]);
        return 1;
    }
    
    std::string inputFile = argv[1];
    std::string outputFile = argv[2];
    bool hexOutput = false;
    bool binOutput = false;
    
    // Parse command line arguments
    for (int i = 3; i < argc; i++) {
        std::string arg = argv[i];
        if (arg == "-h") {
            hexOutput = true;
        } else if (arg == "-b") {
            binOutput = true;
        } else {
            std::cerr << "Unknown option: " << arg << std::endl;
            printUsage(argv[0]);
            return 1;
        }
    }
    
    // If no output format specified, default to hex
    if (!hexOutput && !binOutput) {
        hexOutput = true;
    }
    
    try {
        RISCVAssembler assembler;
        assembler.assemble(inputFile, outputFile, hexOutput, binOutput);
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}

/* Example RISC-V Assembly Programs for Testing:

1. Basic Arithmetic (test1.s):
```
.text
main:
    addi x1, x0, 10        # x1 = 10
    addi x2, x0, 20        # x2 = 20
    add x3, x1, x2         # x3 = x1 + x2 = 30
    sub x4, x3, x1         # x4 = x3 - x1 = 20
    and x5, x1, x2         # x5 = x1 & x2
    or x6, x1, x2          # x6 = x1 | x2
    xor x7, x1, x2         # x7 = x1 ^ x2
```

2. Memory Operations (test2.s):
```
.text
main:
    lui x1, 0x10000        # Load upper immediate
    addi x1, x1, 0x100     # x1 = 0x10000100
    addi x2, x0, 42        # x2 = 42
    sw x2, 0(x1)           # Store word: mem[x1] = x2
    lw x3, 0(x1)           # Load word: x3 = mem[x1]
    sb x2, 4(x1)           # Store byte
    lb x4, 4(x1)           # Load byte
```

3. Control Flow (test3.s):
```
.text
main:
    addi x1, x0, 5         # x1 = 5
    addi x2, x0, 10        # x2 = 10
    beq x1, x2, equal      # Branch if equal
    blt x1, x2, less       # Branch if less than
    j end                  # Jump to end

equal:
    addi x3, x0, 1         # x3 = 1 (equal)
    j end

less:
    addi x3, x0, 2         # x3 = 2 (less)

end:
    nop                    # No operation
```

4. Pseudo-instructions (test4.s):
```
.text
main:
    li x1, 0x12345678      # Load immediate (large)
    li x2, 100             # Load immediate (small)
    mv x3, x1              # Move x1 to x3
    not x4, x2             # Bitwise NOT
    neg x5, x2             # Negate
    j loop                 # Jump to loop

loop:
    nop                    # Loop body
    ret                    # Return
```

5. Function Call Example (test5.s):
```
.text
main:
    addi sp, sp, -16       # Allocate stack space
    li a0, 10              # First argument
    li a1, 20              # Second argument
    jal ra, add_func       # Call function
    addi sp, sp, 16        # Deallocate stack
    j end

add_func:
    add a0, a0, a1         # Add arguments
    jalr x0, ra, 0         # Return

end:
    nop
```

Compilation Examples:
```bash
# Compile for hexadecimal output
./assembler test1.s test1.hex -h

# Compile for binary output  
./assembler test2.s test2.bin -b

# Default output (hex)
./assembler test3.s test3.out
```
*/
// # Compile the assembler
// g++ -o assembler riscv_assembler.cpp -std=c++11

// # Assemble for hexadecimal output
// ./assembler program.s output.hex -h

// # Assemble for binary output
// ./assembler program.s output.bin -b

// # Default output (hexadecimal)
// ./assembler program.s output.out