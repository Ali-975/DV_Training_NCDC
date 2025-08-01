`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2025 08:20:20 PM
// Design Name: 
// Module Name: task11
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


module task11 (
    input logic u, v, w, x,
    input logic s1, s0,
    output logic m
);
    logic n0, n1, n2, n3, s0n, s1n;

    not (s0n, s0);
    not (s1n, s1);

    and (n0, u, s1n, s0n);
    and (n1, v, s1n, s0);
    and (n2, w, s1, s0n);
    and (n3, x, s1, s0);

    or (m, n0, n1, n2, n3);
endmodule
