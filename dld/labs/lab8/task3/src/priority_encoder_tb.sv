`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 08:19:46 PM
// Design Name: 
// Module Name: priority_encoder_tb
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


module priority_encoder_tb;
    logic [8:0] An;
    logic [3:0] On;

    priority_encoder uut (.An(An), .On(On));

    initial begin
        $dumpfile("encoder.vcd");
        $dumpvars(0, priority_encoder_tb);

        An = 9'b111111111; #1;
        An = 9'b111111110; #1;
        An = 9'b111111101; #1;
        An = 9'b111111011; #1;
        An = 9'b111110111; #1;
        An = 9'b111101111; #1;
        An = 9'b111011111; #1;
        An = 9'b110111111; #1;
        An = 9'b101111111; #1;
        An = 9'b011111111; #1;

        $finish;
    end
endmodule