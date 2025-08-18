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



module mux_4x1(out, A, B, C, D, sel);
    output logic out;
    input logic A, B, C, D;
    input logic [1:0]sel;
    logic temp1, temp2;
    mux_2x1 mux1(temp1, A, B, sel[0]);
    mux_2x1 mux2(temp2, C, D, sel[0]);
    mux_2x1 mux3(out, temp1, temp2, sel[1]);
endmodule
