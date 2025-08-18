`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2025 02:41:25 PM
// Design Name: 
// Module Name: serial_shift_reg
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
    always_ff @(posedge clk or posedge rst)
        if (rst)
            q <= 0;
        else
            q <= d;
endmodule

module serial_shift_reg (
    input  logic        clk,
    input  logic        rst,
    input  logic        s_in,
    input  logic [1:0]  ctrl,

    output logic        s_out,
    output logic [7:0]  q
);

    logic [7:0] next_q;
    logic       next_s_out;

    // Shift logic (sync version)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            next_q     = 8'b0;
            next_s_out = 1'b0;
        end else begin
            unique case (ctrl)
                2'b00: begin next_q = {s_in, q[7:1]};  next_s_out = q[0]; end // Shift Right
                2'b01: begin next_q = {q[6:0], q[7]};  next_s_out = q[7]; end // Shift Left
                2'b10: begin next_q = {q[0], q[7:1]};  next_s_out = q[0]; end // Rotate Right
                2'b11: begin next_q = {q[6:0], q[7]};  next_s_out = q[7]; end // Rotate Left
            endcase
        end
    end

    // Instantiate D flip-flops
    d_ff d0 (.clk(clk), .rst(rst), .d(next_q[0]), .q(q[0]));
    d_ff d1 (.clk(clk), .rst(rst), .d(next_q[1]), .q(q[1]));
    d_ff d2 (.clk(clk), .rst(rst), .d(next_q[2]), .q(q[2]));
    d_ff d3 (.clk(clk), .rst(rst), .d(next_q[3]), .q(q[3]));
    d_ff d4 (.clk(clk), .rst(rst), .d(next_q[4]), .q(q[4]));
    d_ff d5 (.clk(clk), .rst(rst), .d(next_q[5]), .q(q[5]));
    d_ff d6 (.clk(clk), .rst(rst), .d(next_q[6]), .q(q[6]));
    d_ff d7 (.clk(clk), .rst(rst), .d(next_q[7]), .q(q[7]));

    // Serial output latch
    d_ff s_latch (.clk(clk), .rst(rst), .d(next_s_out), .q(s_out));

endmodule