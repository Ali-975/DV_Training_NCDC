`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 10:57:49 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb;

    logic clk;
    logic rst;

    // Instantiate DUT (Device Under Test)
    top dut(
        .clk(clk),
        .rst(rst)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin

        rst = 1;
        #10;      // Hold reset for 20ns
        rst = 0;
        #10;      // Hold reset for 20ns
        rst = 0;

        #100;
        $finish;
    end

endmodule
