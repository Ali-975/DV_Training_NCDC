`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: prog_cntr
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module prog_cntr(
    input logic clk,
    input logic rst,
    input logic [31: 0] next_pc,
    
    output logic [31: 0] pc
);
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 0;
        end
        else begin
            pc <= next_pc;
        end
    end
endmodule