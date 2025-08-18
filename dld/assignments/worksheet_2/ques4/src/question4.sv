`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 10:02:45 PM
// Design Name: 
// Module Name: question4
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


module d_ff (
    input  logic clk,
    input  logic rst,
    input  logic d,
    output logic q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule

module question4(
    input  logic clk,
    input  logic rst,
    input logic in,
    
    output logic q,
    output logic out
);

    d_ff ff0(
        .clk(clk),
        .rst(rst),
        .d(in),
        .q(q)
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            out <= 1'b0;
        else
            out <= q ^ in;
    end
endmodule
