`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 09:15:51 AM
// Design Name: 
// Module Name: top
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


module top (
    input  logic [3:0] data_in,
    input  logic [1:0] shift_amt,
    input  logic       dir,
    output logic [3:0] data_out,
    output logic       hold0, hold1, hold2, hold3
);

    // Internal wires connected to submodule
    barrel_shifter bs (
        .data_in(data_in),
        .shift_amt(shift_amt),
        .dir(dir),
        .data_out(data_out),
        .hold0(hold0),
        .hold1(hold1),
        .hold2(hold2),
        .hold3(hold3)
    );

endmodule

