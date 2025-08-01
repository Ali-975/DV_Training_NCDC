`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 09:14:01 AM
// Design Name: 
// Module Name: barrel_shifter_tb
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


module barrel_shifter_tb;
    logic [3:0] data_in, data_out;
    logic [1:0] shift_amt;
    logic dir;

    barrel_shifter uut (.data_in(data_in), .shift_amt(shift_amt), .dir(dir), .data_out(data_out));

    initial begin
        $dumpfile("barrel.vcd");
        $dumpvars(0, barrel_shifter_tb);

        data_in = 4'b0001;

        dir = 0; 
        shift_amt = 1; #10;
        shift_amt = 2; #10;
        shift_amt = 3; #10;
        shift_amt = 0; #10;
        
        dir = 1;
        shift_amt = 1; #10;
        shift_amt = 2; #10;
        shift_amt = 3; #10;
        shift_amt = 0; #10;

        $finish;
    end
endmodule

