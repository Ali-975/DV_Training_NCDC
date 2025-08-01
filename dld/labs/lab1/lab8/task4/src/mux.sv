`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 05:25:14 PM
// Design Name: 
// Module Name: mux
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


module mux (
    input logic [3:0] in,
    input logic [1:0] s,
    output logic m
);
    logic n0, n1, n2, n3, s0n, s1n;

    not (s0n, s[0]);
    not (s1n, s[1]);

    and (n0, in[0], s1n, s0n);
    and (n1, in[1], s1n, s[0]);
    and (n2, in[2], s[1], s0n);
    and (n3, in[3], s[1], s[0]);

    or (m, n0, n1, n2, n3);
endmodule
