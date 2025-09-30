`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: imm_generation
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module imm_generation(
    input  logic [31:0] instr,
    output logic [31:0] imm
);

    logic [6:0] opcode;
    assign opcode = instr[6:0];
    
     always_comb begin
        case (opcode)
            7'b0010011, // I-type (ADDI, SLTI, etc.)
            7'b0000011, // Load instructions
            7'b1100111: begin // JALR
                // I-type immediate: sign-extend bits [31:20]
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            
            7'b0100011: begin // S-type (Store instructions)
                // S-type immediate: sign-extend {bits[31:25], bits[11:7]}
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            
            7'b1101111: begin // JAL
                // J-type immediate: sign-extend {bit[31], bits[19:12], bit[20], bits[30:21], 1'b0}
                imm = {{11{instr[31]}}, instr[31], instr[19:12],
                            instr[20], instr[30:21], 1'b0};
            end
            
            default: begin
                imm = 32'h0;
            end
        endcase
    end
    
endmodule
