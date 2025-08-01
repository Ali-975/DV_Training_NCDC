`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 06:55:55 PM
// Design Name: 
// Module Name: bcd_to_7seg
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


module bcd_to_7seg (
    input  logic [3:0] bcd,
    output logic [6:0] seg,  // a to g
    output logic [7:0] AN
);
    assign AN = 8'b01111111;
    always_comb begin
        case (bcd)
            4'd0: seg = 7'b0000001; // a, b, c, d, e, f
            4'd1: seg = 7'b1001111; // b, c
            4'd2: seg = 7'b0010010; // a, b, d, e, g
            4'd3: seg = 7'b0000110; // a, b, c, d, g
            4'd4: seg = 7'b1001100; // b, c, f, g
            4'd5: seg = 7'b0100100; // a, c, d, f, g
            4'd6: seg = 7'b0100000; // a, c, d, e, f, g
            4'd7: seg = 7'b0001111; // a, b, c
            4'd8: seg = 7'b0000000; // a, b, c, d, e, f, g
            4'd9: seg = 7'b0000100; // a, b, c, d, f, g
            default: seg = 7'b1111110; // dash
        endcase
    end
endmodule

