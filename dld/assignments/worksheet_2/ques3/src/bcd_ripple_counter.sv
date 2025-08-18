`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:12:56 PM
// Design Name: 
// Module Name: bcd_ripple_counter
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


module t_ff (
  input logic T,
  input logic clk,
  input logic rst_n, // Active-low reset
  output logic Q
);
  always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Q <= 1'b0;
    end else begin
      if (T) begin
        Q <= ~Q;
      end      
    end
  end
endmodule

module bcd_ripple_counter (
  input logic clk,
  input logic rst_n,
  output logic [3:0] bcd_out
);

  logic Q0, Q1, Q2, Q3;
  logic clear_count;

  // Logic to clear the counter when it reaches 10 (binary 1010)
  // This ensures it wraps around from 9 to 0
  assign clear_count = Q3 & Q1; // This condition is true when bcd_out is 1010 (binary 10)

  // Instantiate T-flip-flops
  // Q0 is the LSB, Q3 is the MSB
  t_ff ff0 (.T(1'b1), .clk(clk), .rst_n(rst_n & ~clear_count), .Q(Q0));
  t_ff ff1 (.T(1'b1), .clk(Q0), .rst_n(rst_n & ~clear_count), .Q(Q1));
  t_ff ff2 (.T(1'b1), .clk(Q1), .rst_n(rst_n & ~clear_count), .Q(Q2));
  t_ff ff3 (.T(1'b1), .clk(Q2), .rst_n(rst_n & ~clear_count), .Q(Q3));

  assign bcd_out = {Q3, Q2, Q1, Q0};

endmodule

