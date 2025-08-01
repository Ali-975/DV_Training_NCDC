`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 09:12:56 AM
// Design Name: 
// Module Name: barrel_shifter
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


module barrel_shifter (
    input  logic [3:0] data_in,
    input  logic [1:0] shift_amt,
    input  logic       dir,     // 0 = left, 1 = right
    output logic [3:0] data_out,
    output logic       hold0, hold1, hold2, hold3
);
    
    logic [3:0] inL0, inL1, inL2, inL3; // Left Circular Shift Inputs
    
    logic [3:0] inR0, inR1, inR2, inR3; // Right Circular Shift Inputs
    
    logic [3:0] in0, in1, in2, in3; // Selected inputs depending on dir

    // For left shift rotation
    assign inL0 = {data_in[0], data_in[1], data_in[2], data_in[3]};
    assign inL1 = {data_in[1], data_in[2], data_in[3], data_in[0]};
    assign inL2 = {data_in[2], data_in[3], data_in[0], data_in[1]};
    assign inL3 = {data_in[3], data_in[0], data_in[1], data_in[2]};

    // For right shift rotation
    assign inR0 = {data_in[0], data_in[1], data_in[2], data_in[3]};
    assign inR1 = {data_in[3], data_in[0], data_in[1], data_in[2]};
    assign inR2 = {data_in[2], data_in[3], data_in[0], data_in[1]};
    assign inR3 = {data_in[1], data_in[2], data_in[3], data_in[0]};

    assign in0 = dir ? inR0 : inL0; // If dir = 1, inR, Otherwise inL
    assign in1 = dir ? inR1 : inL1; // If dir = 1, inR, Otherwise inL
    assign in2 = dir ? inR2 : inL2; // If dir = 1, inR, Otherwise inL
    assign in3 = dir ? inR3 : inL3; // If dir = 1, inR, Otherwise inL

    // Instantiate 4-to-1 MUXes
    mux m0 (
        .in(in0), 
        .s(shift_amt), 
        .m(hold0)
        );
        
    mux m1 (
        .in(in1), 
        .s(shift_amt), 
        .m(hold1)
        );
        
    mux m2 (
        .in(in2), 
        .s(shift_amt), 
        .m(hold2)
        );
        
    mux m3 (
        .in(in3), 
        .s(shift_amt), 
        .m(hold3)
    );

    assign data_out = {hold3, hold2, hold1, hold0};

endmodule