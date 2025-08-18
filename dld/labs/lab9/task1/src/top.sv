//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 08/01/2025 07:26:49 PM
//// Design Name: 
//// Module Name: top
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module top (
    input  logic        clk,
    input  logic        rst,
    input  logic        s_in,
    input  logic [1:0]  ctrl,

    output logic        s_out,
    output logic [7:0]  q
);

    logic clk_1hz;

    slow_clk sc(
        .clk(clk),
        .rst(rst),
        .clk_1hz(clk_1hz)
    );
    
    serial_shift_reg ssr(
        .clk(clk_1hz),
        .rst(rst),
        .s_in(s_in),
        .ctrl(ctrl),
    
        .s_out(s_out),
        .q(q)
        );

endmodule
