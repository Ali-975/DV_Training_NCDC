`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 07:56:23 PM
// Design Name: 
// Module Name: priority_encoder
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


module priority_encoder (
    input  logic [8:0] An,    // active-low
    output logic [7:0] seg,
    output logic [3:0] On,    // inverted output
    output logic [7:0] AN
);
    assign AN = 8'b01111111;
    
    always_comb begin
//        On = 4'b1111;
        casex (An)
            9'bxxxxxxxx0: begin On = ~4'b0001; seg = 8'b01001111; end // An[0] = 0 ? Key 0
            9'bxxxxxxx01: begin On = ~4'b0010; seg = 8'b00010010; end // An[1] = 0 ? Key 1
            9'bxxxxxx011: begin On = ~4'b0011; seg = 8'b00000110; end // An[2] = 0 ? Key 2
            9'bxxxxx0111: begin On = ~4'b0100; seg = 8'b01001100; end // An[3] = 0 ? Key 3
            9'bxxxx01111: begin On = ~4'b0101; seg = 8'b00100100; end // An[4] = 0 ? Key 4
            9'bxxx011111: begin On = ~4'b0110; seg = 8'b00100000; end // An[5] = 0 ? Key 5
            9'bxx0111111: begin On = ~4'b0111; seg = 8'b00001111; end // An[6] = 0 ? Key 6
            9'bx01111111: begin On = ~4'b1000; seg = 8'b00000000; end // An[7] = 0 ? Key 7
            9'b011111111: begin On = ~4'b1001; seg = 8'b00000100; end // An[8] = 0 ? Key 8
            default:      begin On = 4'b1111; seg = 8'b00111000; end // Default ? Dash
        endcase
    end
endmodule

