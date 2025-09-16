`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 09:27:04 PM
// Design Name: 
// Module Name: mux_4x1
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



module mux_4x1(
    input logic A,
    input logic B,
    input logic C,
    input logic D,
    input logic [1:0]sel,
    
    output logic out
);
    
    logic temp_1, temp_2;
    
    mux_2x1 mux1(.A(A), .B(B), .sel(sel[0]), .out(temp_1));
    mux_2x1 mux2(.A(C), .B(D), .sel(sel[0]), .out(temp_2));
    mux_2x1 mux3(.A(temp_1), .B(temp_1), .sel(sel[1]), .out(out));
    
endmodule
