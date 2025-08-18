`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2025 08:20:20 PM
// Design Name: 
// Module Name: task12
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: a
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module task13 (
    input logic u, v, w, x,
    input logic [1:0] s,
    output logic m
);
    always_comb begin
        case (s)
            2'b00: m = u;
            2'b01: m = v;
            2'b10: m = w;
            2'b11: m = x;
        endcase
    end
endmodule
