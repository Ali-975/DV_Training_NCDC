`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:47:12 PM
// Design Name: 
// Module Name: bcd_ripple_decade_tb
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


module bcd_ripple_decade_tb;

    // Inputs
    reg clk;
    reg rst_n;
    
    // Outputs
    wire [11:0] bcd_out;
    
    // Instantiate the counter
    bcd_ripple_decade dut (
        .clk(clk),
        .rst_n(rst_n),
        .bcd_out(bcd_out)
    );
    
    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Stimulus
    initial begin
        // Initialize and reset
        rst_n = 0;
        #20;
        rst_n = 1;
        
        // Let it count to 999 (1000 clock cycles)
        #10000;
        
        // Display final message
        $display("Counter reached %03d", 
                {bcd_out[11:8], bcd_out[7:4], bcd_out[3:0]});
        $finish;
    end
    
    // Monitor the counting
    initial begin
        $timeformat(-9, 0, " ns", 6);
        $monitor("Time = %t | Count = %03d", $time, 
                {bcd_out[11:8], bcd_out[7:4], bcd_out[3:0]});
    end

endmodule
