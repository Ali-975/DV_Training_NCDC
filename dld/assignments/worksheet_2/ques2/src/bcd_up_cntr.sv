`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 09:30:14 AM
// Design Name: 
// Module Name: bcd_up_cntr
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


module tff(
    input logic clk,
    input logic rst,
    input logic t,
	output logic q
);
	
	always@(posedge clk or posedge rst)begin
		if(rst)
			q <= 1'b0;
		else begin
			if( t == 1'b1)
				q <= ~q;
			else
				q <= q; 
		end
		
	end
endmodule

module bcd_up_cntr(
	input logic clk,
	input logic rst,
	output logic [3:0]q
);
    logic [3:0]t;

    // Instantiate T flip-flops
	tff tff0 (.clk(clk), .rst(rst || (q == 4'd10)), .t(t[0]), .q(q[0]));
    tff tff1 (.clk(clk), .rst(rst || (q == 4'd10)), .t(t[1]), .q(q[1]));
    tff tff2 (.clk(clk), .rst(rst || (q == 4'd10)), .t(t[2]), .q(q[2]));
    tff tff3 (.clk(clk), .rst(rst || (q == 4'd10)), .t(t[3]), .q(q[3]));
	
	// Toggle conditions
	assign t[0] = 1'b1;
	assign t[1] = q[0] & ( ~q[3] );
	assign t[2] = q[0] & q[1];
	assign t[3] = q[0] & ( q[3] | (q[1] & q[2] ));
	
endmodule