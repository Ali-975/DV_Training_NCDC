`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 04:33:33 PM
// Design Name: 
// Module Name: top
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


module top(
    input logic clk,
    input logic rst,
    output logic [6:0] seg,
    output logic [7:0] AN
);
    logic clk_1Hz;
    logic [5:0] seconds, minutes;
    logic [4:0] hours;

    clock_divider clk_div (
        .clk_100MHz(clk),
        .rst(rst),
        .clk_1Hz(clk_1Hz)
    );

    digital_clk d_clk (
        .clk_1Hz(clk_1Hz),
        .rst(rst),
        .seconds(seconds),
        .minutes(minutes),
        .hours(hours)
    );

    seven_segment_display display (
        .hours(hours),
        .minutes(minutes),
        .seconds(seconds),
        .clk(clk),
        .seg(seg),
        .AN(AN)
    );
endmodule
