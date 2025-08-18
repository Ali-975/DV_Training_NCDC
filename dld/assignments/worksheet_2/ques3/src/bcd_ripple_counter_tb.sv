`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:13:29 PM
// Design Name: 
// Module Name: bcd_ripple_counter_tb
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


module bcd_ripple_counter_tb;

  // Testbench signals
  logic clk;
  logic rst_n;
  logic [3:0] bcd_out;

  // Instantiate the counter
  bcd_ripple_counter uut (
    .clk(clk),
    .rst_n(rst_n),
    .bcd_out(bcd_out)
  );

  // Clock generation: 10ns period => 100 MHz
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;

    // Apply reset
    #10;
    rst_n = 1;

    // Let it run for a while
    #200;

    // Apply reset again mid-count
    rst_n = 0;
    #20;
    rst_n = 1;

    // Run for a bit longer
    #200;

    $stop;  // End simulation
  end

  // Monitor output
//  initial begin
//    $display("Time\tclk\trst_n\tBCD_Out");
//    $monitor("%0t\t%b\t%b\t%04b", $time, clk, rst_n, bcd_out);
//  end

endmodule

