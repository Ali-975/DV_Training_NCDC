`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2025 04:59:36 PM
// Design Name: 
// Module Name: serial_shift_register_tb
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


module serial_shift_reg_tb;
    logic clk;
    logic rst;
    logic s_in;
    logic [1:0] ctrl;
    logic s_out;
    logic [7:0] q;

    serial_shift_reg uut (
        .clk(clk),
        .rst(rst),
        .s_in(s_in),
        .ctrl(ctrl),
        .s_out(s_out),
        .q(q)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initial values
        rst = 1;
        s_in = 0;
        ctrl = 2'b00;
        
        // Reset the shift register
        #10;
        rst = 0;
        
        s_in = 1;
        #10;
        s_in = 0;
        #10;#10;#10;

        // Shift right with s_in = 1
        ctrl = 2'b00;
        #10;#10;#10;

        // Shift left with s_in = 0
        ctrl = 2'b01;
        #10;#10;#10;

        // Rotate right
        ctrl = 2'b10;
        #10;#10;#10;#10;#10;#10;#10;#10;#10;

        // Rotate left
        ctrl = 2'b11;
        #10;#10;#10;#10;#10;#10;#10;#10;#10;

        // Finish simulation
        #10;
        $finish;
    end

endmodule
