`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:32:59 PM
// Design Name: 
// Module Name: ripple_up_dn_cntr
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


module ripple_up_dn_cntr(
    input logic clk,
    input logic rst,
    input logic up_down,           // 1 = up, 0 = down
    output logic [3:0] count
);
    logic [3:0] q;
    logic t = 1;

    always_ff @(negedge clk or posedge rst) begin
        if (rst)
            q[0] <= 0;
        else
            q[0] <= q[0] ^ t;
    end

    always_ff @(negedge q[0] or posedge rst) begin
        if (rst)
            q[1] <= 0;
        else
            q[1] <= q[1] ^ t;
    end

    always_ff @(negedge q[1] or posedge rst) begin
        if (rst)
            q[2] <= 0;
        else
            q[2] <= q[2] ^ t;
    end

    always_ff @(negedge q[2] or posedge rst) begin
        if (rst)
            q[3] <= 0;
        else
            q[3] <= q[3] ^ t;
    end

    // Handle up/down logic by inverting bits if down
    always_comb begin
        count = up_down ? q : ~q;
    end
endmodule

