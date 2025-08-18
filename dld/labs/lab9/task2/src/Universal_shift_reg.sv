`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 08:55:12 PM
// Design Name: 
// Module Name: Universal_shift_reg
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

//===========       S I S O      =============
module siso_shift_reg (
    input  logic clk,
    input  logic rst,
    input  logic s_in,       // Serial input
    output logic s_out       // Serial output (last bit)
);

    logic [3:0] q;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0000;
        else
            q <= {s_in, q[3:1]};  // Shift right
    end

    assign s_out = q[0];  // Last bit shifted out

endmodule

//===========       S I P O      =============
module sipo_shift_reg (
    input  logic clk,
    input  logic rst,
    input  logic s_in,     // Serial input
    output logic [3:0] q   // Parallel output
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0000;
        else
            q <= {s_in, q[3:1]};  // Shift right
    end

endmodule

//===========       P I S O      =============
module piso_shift_reg (
    input  logic clk,
    input  logic rst,
    input  logic load,         // Load enable
    input  logic [3:0] p_in,   // Parallel input
    output logic s_out         // Serial output
);

    logic [3:0] q;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= p_in;              // Load parallel input
        else
            q <= {1'b0, q[3:1]};    // Shift right
    end

    assign s_out = q[0];

endmodule

//===========       P I P O      =============
module pipo_shift_reg (
    input  logic clk,
    input  logic rst,
    input  logic load,         // Load enable
    input  logic [3:0] p_in,   // Parallel input
    output logic [3:0] q       // Parallel output
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 4'b0000;
        end
        else if (load) begin
            q <= p_in;         // Load parallel input
        end
    end

endmodule
