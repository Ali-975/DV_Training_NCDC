`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: top_tb
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb;

    logic clk;
    logic rst;

    // Instantiate DUT (Device Under Test)
    top_5_stage_pipeline dut(
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

        #1000;
        $finish;
    end

endmodule
