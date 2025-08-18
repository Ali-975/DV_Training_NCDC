`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:39:41 PM
// Design Name: 
// Module Name: ripple_up_dn_cntr_tb
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


module ripple_up_dn_cntr_tb;
    // Testbench signals
    logic clk;
    logic rst;
    logic up_down;
    logic [3:0] count;

    // Instantiate the DUT (Device Under Test)
    ripple_up_dn_cntr uut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        up_down = 1; // start with UP counting
        #10;

        rst = 0; // release reset
        $display("Starting UP count...");
        repeat (15) begin
            #10;
            $display("Time = %0t | Count = %0d", $time, count);
        end

        // Change direction to DOWN
        up_down = 0;
        $display("Switching to DOWN count...");
        repeat (16) begin
            #10;
            $display("Time = %0t | Count = %0d", $time, count);
        end

        $display("Simulation finished.");
        $stop;
    end
endmodule