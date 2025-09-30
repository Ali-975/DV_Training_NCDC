`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: control_unit
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
    input logic [6: 0] opcode,
    
    output logic we,
    output logic [1: 0] alu_op,
    output logic op_b_sel
    );
    
    always_comb begin
        if(opcode == 7'b0110011) begin
            we = 1'b1;
            alu_op = 2'b10;
            op_b_sel = 1'b0;
        end
        
        else if(opcode == 7'b0010011) begin
            we = 1'b1;
            alu_op = 2'b10;
            op_b_sel = 1'b1;
        end
        else begin
            we = 1'b0;
            alu_op = 2'b00;
            op_b_sel = 1'b0;
        end
    end
    
endmodule
