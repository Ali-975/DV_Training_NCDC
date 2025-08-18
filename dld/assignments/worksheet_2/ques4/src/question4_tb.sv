`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 10:03:03 PM
// Design Name: 
// Module Name: question4_tb
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


module question4_tb;

    // Inputs
    logic clk;
    logic rst;
    logic in;

    // Output
    logic out;
    logic q;

    // Instantiate the D Flip-Flop
    question4 dut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        in = 0;

        // VCD dump for waveform
        $dumpfile("question4.vcd");
        $dumpvars(0, question4_tb);

        // Apply reset
        #10;
        rst = 0;

        // Apply some test inputs
        #10 in = 1;
        #10 in = 1;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 0;
        #10 in = 0;

        // Apply reset again
        #10 rst = 1;
        #10 rst = 0;

        // More inputs after reset
        #10 in = 1;
        #10 in = 1;

        // End simulation
        #20;
        $finish;
    end

endmodule

