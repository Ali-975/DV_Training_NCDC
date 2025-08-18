`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:46:57 PM
// Design Name: 
// Module Name: bcd_ripple_decade
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


// T-Flip-Flop Module
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

// BCD Digit Module (0-9 counter)
module bcd_digit (
    input logic clk,
    input logic rst_n,
    output logic [3:0] bcd_out,
    output logic carry_out
);
    logic Q0, Q1, Q2, Q3;
    logic clear_count;
    
    // Detect when counter reaches 10 (binary 1010)
    assign clear_count = Q3 & Q1;
    assign carry_out = clear_count; // Carry out when wrapping from 9 to 0
    
    // Instantiate T-flip-flops
    t_ff ff0 (.T(1'b1), .clk(clk),         .rst_n(rst_n & ~clear_count), .Q(Q0));
    t_ff ff1 (.T(1'b1), .clk(Q0),          .rst_n(rst_n & ~clear_count), .Q(Q1));
    t_ff ff2 (.T(1'b1), .clk(Q1),          .rst_n(rst_n & ~clear_count), .Q(Q2));
    t_ff ff3 (.T(1'b1), .clk(Q2),          .rst_n(rst_n & ~clear_count), .Q(Q3));
    
    assign bcd_out = {Q3, Q2, Q1, Q0};
endmodule

// 12-bit BCD Ripple Counter (0-999)
module bcd_ripple_decade (
    input logic clk,
    input logic rst_n,
    output logic [11:0] bcd_out
);
    logic carry_0, carry_1;
    
    // Instantiate three BCD digits
    bcd_digit digit0 (
        .clk(clk),
        .rst_n(rst_n),
        .bcd_out(bcd_out[3:0]),
        .carry_out(carry_0)
    );
    
    bcd_digit digit1 (
        .clk(carry_0),
        .rst_n(rst_n),
        .bcd_out(bcd_out[7:4]),
        .carry_out(carry_1)
    );
    
    bcd_digit digit2 (
        .clk(carry_1),
        .rst_n(rst_n),
        .bcd_out(bcd_out[11:8]),
        .carry_out() // Final carry out not needed
    );
endmodule