`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 08:12:08 PM
// Design Name: 
// Module Name: bdrate_gen
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


module bdrate_gen(
    input logic clk,
    input logic rst,
    
    input logic [1:0] sel_baud,
    output logic bclk, bclkx8
);
    
    logic clk_div_8;
    logic A, B, C, D;
    logic baud0, baud1, baud2, baud3;
    
    clk_div #(.COUNT(3)) clk_div_8_gen(clk_div_8, clk, rst); //system clock division
    
    counter_param paramet_cntr_gen(A, B, C, D, clk_div_8, rst); 
    
    mux_4x1 mux(bclkx8, A, B, C, D, sel_baud); //rx_baud rate x8 than tx baud rate
    
    clk_div #(.COUNT(3)) clk_div_8_gen1(bclk, bclkx8, rst); // tx baud rate generation
endmodule