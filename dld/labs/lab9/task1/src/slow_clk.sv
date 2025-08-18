`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 03:04:44 PM
// Design Name: 
// Module Name: slow_clk
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


module slow_clk(
    input  logic clk,       // 100 MHz input clock
    input  logic rst,       // active-high synchronous reset
    output logic clk_1hz    // 1 Hz output clock
);

    // Number of cycles for 0.5 second = 100_000_000 / 2
    localparam integer MAX_COUNT = 50_000_000;

    logic [25:0] counter = 0;

    always_ff @(posedge clk) begin
        if (rst) begin
            counter  <= 0;
            clk_1hz  <= 0;
        end else begin
            if (counter == MAX_COUNT - 1) begin
                counter  <= 0;
                clk_1hz  <= ~clk_1hz; // toggle every 0.5s ? full period = 1s
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
