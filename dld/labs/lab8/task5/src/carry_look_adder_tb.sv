`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 08:40:39 PM
// Design Name: 
// Module Name: carry_look_adder_tb
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


module carry_look_adder_tb;
    logic [3:0] A, B, Sum;
//    logic Cin, Cout;
    logic Cout;
    logic [6:0] seg;

    carry_look_adder uut (
        .A(A), 
        .B(B), 
//        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout),
        .seg(seg)
        );

    initial begin
        $dumpfile("carry_look_adder.vcd");
        $dumpvars(0, carry_look_adder_tb);

//        Cin = 0;
        A = 4'b0100; B = 4'b0010; #10;
        A = 4'b0011; B = 4'b0110; #10;
        
        A = 4'b0101; B = 4'b0011; #10;
        A = 4'b0111; B = 4'b0111; #10;
        A = 4'b1111; B = 4'b0101; #10;
        A = 4'b1110; B = 4'b0001; #10;
        A = 4'b1000; B = 4'b0111; #10;
        A = 4'b1010; B = 4'b0101; #10;

        $finish;
    end
endmodule

