`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 11:49:35 AM
// Design Name: 
// Module Name: question5
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

module question5(
    input  logic clk,
    input  logic rst,
    input logic C,
    input logic I,

    output logic X
);

    logic [1:0] q;
    logic [1:0] d;

    d_ff ff0(.clk(clk), .rst(rst), .d(d[0]), .q(q[0]));
    d_ff ff1(.clk(clk), .rst(rst), .d(d[1]), .q(q[1]));
    
    assign d[0] = C & (q[1] | ~I);
    assign d[1] = C & (q[1] | I);
    assign X = I ^ q[1];
    
endmodule

