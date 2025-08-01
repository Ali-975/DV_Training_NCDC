`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 07:50:06 PM
// Design Name: 
// Module Name: bcd_to_7seg_tb
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


module bcd_to_7seg_tb;
    logic [3:0] bcd;
    logic [6:0] seg;

    bcd_to_7seg uut (.bcd(bcd), .seg(seg));

    initial begin
        $dumpfile("bcd7seg.vcd");
        $dumpvars(0, bcd_to_7seg_tb);

        for (int i = 0; i <= 9; i++) begin
            bcd = i;
            #10;
        end

        $finish;
    end
endmodule

