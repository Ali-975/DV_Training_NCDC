`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 11:22:12 AM
// Design Name: 
// Module Name: bin_dn_cntr
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

module bin_dn_cntr(
    input logic clk,
    input logic rst,
    output logic [3:0]q
);
    logic [3:0]d; 
    
    d_ff ff0 (.clk(clk), .rst(rst), .d(d[0]), .q(q[0]));
    d_ff ff1 (.clk(clk), .rst(rst), .d(d[1]), .q(q[1]));
    d_ff ff2 (.clk(clk), .rst(rst), .d(d[2]), .q(q[2]));
    d_ff ff3 (.clk(clk), .rst(rst), .d(d[3]), .q(q[3]));
    
    assign d[0] = ~ q[0];
    assign d[1] = ~(q[1] ^ q[0] );
    assign d[2] = ~(q[2] ^ (q[0] | q[1]));
    assign d[3] = ~(q[3] ^ (q[0] | q[1] | q[2]));
endmodule
