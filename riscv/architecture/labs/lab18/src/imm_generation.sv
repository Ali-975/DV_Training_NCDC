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
            // I-type (ADDI, SLTI, etc.)
            // I-type immediate: sign-extend bits [31:20]
            7'b0010011: imm = {{20{instr[31]}}, instr[31:20]};
            
            default: begin
                imm = 32'h0;
            end
        endcase
    end
    
endmodule
