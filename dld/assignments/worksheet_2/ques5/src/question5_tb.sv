`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 11:50:02 AM
// Design Name: 
// Module Name: question5_tb
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


module question5_tb;

    // Inputs
    logic clk;
    logic rst;
    logic C;
    logic I;
    
    // Output
    logic X;

    // Instantiate the D Flip-Flop
    question5 dut (
        .clk(clk),
        .rst(rst),
        .C(C),
        .I(I),
        .X(X)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        C = 0; I = 0;

        // VCD dump for waveform
        $dumpfile("question5.vcd");
        $dumpvars(0, question5_tb);

        // Apply reset
        #10;
        rst = 0;

        // Apply some test inputs
        #10 C = 0;
        
        #10 I = 0;
        #10 I = 0;
        #10 I = 1;
        #10 I = 0;
        #10 I = 1;
        #10 I = 1;
        #10 I = 1;
        #10 I = 0;
        
        #10 C = 1;
        
        #10 I = 0;
        #10 I = 0;
        #10 I = 1;
        #10 I = 0;
        #10 I = 1;
        #10 I = 1;
        #10 I = 1;
        #10 I = 0;

        // Apply reset again
        #10 rst = 1;
        #10 rst = 0;

        // End simulation
        #20;
        $finish;
    end

endmodule