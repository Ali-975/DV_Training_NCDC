`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 09:42:46 AM
// Design Name: 
// Module Name: bcd_up_cntr_tb
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


module bcd_up_cntr_tb;

    logic clk;
    logic rst;
    logic [3:0] q;

    // Instantiate DUT
    bcd_up_cntr dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // VCD dump
        $dumpfile("bcd_up_cntr.vcd");
        $dumpvars(0, bcd_up_cntr_tb);

        // Initial values
        clk = 0;
        rst = 1;

        // Apply reset
        #10 rst = 0;

        // Let it count
        #160;

        // Apply another reset
        rst = 1;
        #10 rst = 0;

        // Run again
        #100;

        $finish;
    end

endmodule

