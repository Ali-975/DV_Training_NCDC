`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 08:39:50 PM
// Design Name: 
// Module Name: carry_look_adder
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


module carry_look_adder (
    input  logic [3:0] A, B,
//    input  logic       Cin,
    output logic [3:0] Sum,
    output logic       Cout,
    output logic [6:0] seg,  // seg[6] = a, seg[0] = g
    output logic [7:0] AN
);
    assign AN = 8'b01111111; // To enable only one seven segment
    
    logic [3:0] G, P;
    logic C1, C2, C3, C4;
    localparam logic Cin = 1'b0;

//    assign Cin = 1'b0; // Hard coded zero for first Full Adder
    // Gn and Pn
    assign G = A & B;
    assign P = A ^ B;

    // Carry Look Ahead Logic
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    // Final Sum and Carry-out
    assign Sum[0] = P[0] ^ Cin;
    assign Sum[1] = P[1] ^ C1;
    assign Sum[2] = P[2] ^ C2;
    assign Sum[3] = P[3] ^ C3;
    assign Cout   = C4;
    
    always_comb begin
        case (Sum)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            4'd10: seg = 7'b0001000; // A ? dot, a, b, c, e, f, g
            4'd11: seg = 7'b1100000; // B ? dot, c, d, e, f, g (lowercase b style)
            4'd12: seg = 7'b0110001; // C ? dot, a, d, e, f
            4'd13: seg = 7'b1000010; // D ? dot, b, c, d, e, g
            4'd14: seg = 7'b0110000; // E ? dot, a, d, e, f, g
            4'd15: seg = 7'b0111000; // F ? dot, a, e, f, g
            default: seg = 7'b0000001;  // dash or blank
        endcase
    end
endmodule


