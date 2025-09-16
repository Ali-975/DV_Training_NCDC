`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Mr Muddassir Ali Siddiqui
// Project Name: Custom Processor
//
// Create Date: 08/19/2025 09:01:01 PM
// Module Name: alu
// 
//////////////////////////////////////////////////////////////////////////////////


module alu#(
    parameter ALU_WIDTH = 16)(
    input logic [ALU_WIDTH - 1: 0] op1,
    input logic [ALU_WIDTH - 1: 0] op2,
    input logic [$clog2($clog2(ALU_WIDTH))-1: 0]opcode,
    
    output logic [ALU_WIDTH - 1: 0] result
);
    
    always_comb begin
        case(opcode)
            2'b00: result = op1 + op2;
            2'b01: result = op1 - op2;
            2'b10: result = op1 & op2;
            2'b11: result = op1 | op2;
        endcase
    end
    
endmodule
