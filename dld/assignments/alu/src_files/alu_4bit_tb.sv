`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 11:39:14 PM
// Design Name: 
// Module Name: alu_4bit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_4bit_tb;
    logic [3:0] a, b, opcode;
    logic [3:0] result;
    logic carry_out, overflow;

    alu_4bit uut (
        .operand_a(a), .operand_b(b), .opcode(opcode),
        .result(result), .carry_out(carry_out), .overflow(overflow)
    );

    initial begin
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, alu_4bit_tb);

        // Test cases
        a = 4'b0011; b = 4'b0001; // 3 + 1
        
        opcode = 4'd0; #10;
        opcode = 4'd1; #10;
        opcode = 4'd2; #10;
        opcode = 4'd3; #10;
        opcode = 4'd4; #10;
        opcode = 4'd5; #10;
        opcode = 4'd6; #10;
        opcode = 4'd7; #10;
        opcode = 4'd8; #10;
        opcode = 4'd9; #10;
        opcode = 4'd10; #10;

        $finish;
    end
endmodule
