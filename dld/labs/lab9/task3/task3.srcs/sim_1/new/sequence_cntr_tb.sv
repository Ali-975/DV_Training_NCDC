`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 04:01:50 PM
// Design Name: 
// Module Name: sequence_cntr_tb
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


module sequence_cntr_tb;

    logic clk, rst;
    logic [2:0] count;
    logic [6:0] seg;
    logic [7:0] AN;

    // Instantiate the DUT (Device Under Test)
    sequence_cntr dut (
        .clk(clk),
        .rst(rst),
        .count(count),
        .seg(seg),
        .AN(AN)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk=0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
       
        rst = 1;     // Apply reset
        #10;
        rst = 0;     // Release reset

        // Let counter run for a few cycles
        #180;

        $finish;
    end

endmodule
