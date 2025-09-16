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
    
    output logic bclk,
    output logic bclkx8
);
    
    logic clk_div_8;
    logic A, B, C, D;
    logic baud0, baud1, baud2, baud3;
    
    //system clock division
    clk_div #(.COUNT(4)) clk_div_8_gen(
        .clk(clk), .rst(rst), .q(clk_div_8)
    );
    
    counter_param paramet_cntr_gen(
       .clk_div_8(clk_div_8), .rst(rst),  
       .A(A), .B(B), .C(C), .D(D)
    ); 
    
    //rx_baud rate x8 than tx baud rate
    mux_4x1 mux(
        .A(A), .B(B), .C(C), .D(D),
        .sel(sel_baud), .out(bclkx8)
    );
    
    // tx baud rate generation
    clk_div #(.COUNT(4)) clk_div_8_gen1(
        .clk(bclkx8), .rst(rst), .q(bclk)
    );
endmodule
