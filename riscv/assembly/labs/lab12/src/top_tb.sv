`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Mr Muddassir Ali Siddiqui
// Project Name: Custom Processor
//
// Create Date: 08/20/2025 04:27:00 PM
// Module Name: top_tb
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb;
    localparam IMEM_DEPTH = 4;
    localparam REGF_WIDTH = 16;
    localparam ALU_WIDTH = 16;
    localparam PROG_VALUE = 3;

    logic clk;
    logic rst;

    // Instantiate DUT (Device Under Test)
    top #(
        .IMEM_DEPTH(IMEM_DEPTH),
        .REGF_WIDTH(REGF_WIDTH),
        .ALU_WIDTH(ALU_WIDTH),
        .PROG_VALUE(PROG_VALUE)
    ) dut (
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