//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 07/28/2025 08:20:20 PM
//// Design Name: 
//// Module Name: task12
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module task12 (
    input logic u, v, w, x,
    input logic [1:0] s,
    output logic m
);
    always_comb begin
        if (s == 2'b00) m = u;
        else if (s == 2'b01) m = v;
        else if (s == 2'b10) m = w;
        else m = x;
    end
endmodule

